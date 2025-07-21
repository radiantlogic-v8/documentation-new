---
title: Certificate Management
description: Learn how to manage certificates of your self-managed Identity Data Management.
---

## Overview

Several components of an Identity Data Management deployment need to communicate securely, both from external sources (e.g., users or applications via HTTPS/LDAPS) and internally (between pods and services).

Certificates are used to encrypt this communication and to authenticate each party involved. This guide explains how to securely configure and manage certificates for self-managed Identity Data Management deployments in a Kubernetes environment.

This guide provides details on how to secure, scale, and automate TLS certificate management for self-managed Identity Data Management deployments, including ingress termination, pod-level encryption, keystore modernization, and lifecycle automation.


## Components and certificates matrix

| Component                     | Certificate Type | Ports Used   | SANs Requirement                      |
|------------------------------|------------------|--------------|---------------------------------------|
| Ingress Controller           | External TLS     | 443, 636     | Public domain names                   |
| Identity Data Management Pods (fid pods) | Internal TLS     | 2636, 8090   | Pod FQDNs, headless service           |
| Identity Data Management Control Panel UI             | HTTPS            | 7070, 7171   | Internal service names                |
|  APIs                | HTTPS            | 8089, 8090   | Internal service names                |



## Certificate types 

### Ingress Certificate

This certificate is used to secure external traffic entering the cluster (e.g., from web browsers or external LDAP clients). It is associated with public-facing hostnames (e.g., `your.identitydatamangementurl.com`).
Ingress certificates need to be installed as a Kubernetes TLS secret.

**Ingress-Level TLS Termination Behavior:**

- Incoming external traffic is decrypted at the ingress controller.
- Traffic from the ingress to FID pods is unencrypted (unless TLS passthrough is enabled).
- Identity Data Management FID certificates are still required for LDAPS (port 2636) and internal HTTPS services.
- Accessing the Control Panel may require valid certificates at both the ingress and pod levels.


## Steps to set up an ingress certificate

**1. Create certificate with public DNS names:**

```
DNS.1 = iddm.example.com  
DNS.2 = *.iddm.example.com  
DNS.3 = api.iddm.example.com
````

**2. Generate TLS certificate:**

```bash
openssl req -new -x509 -days 365 \
  -keyout ingress.key -out ingress.crt \
  -subj "/CN=iddm.example.com" \
  -extensions san -config <(cat <<EOF
[req]
distinguished_name=req
req_extensions=san
[ san ]
subjectAltName=DNS:iddm.example.com,DNS:*.iddm.example.com
EOF
)
```

**3. Create Kubernetes TLS secret:**

```bash
kubectl create secret tls iddm-ingress-tls \
  --cert=ingress.crt --key=ingress.key \
  -n iddm-namespace
```

**4. Configure Helm deployment:**

```yaml
ingress:
  enabled: true
  tls:
    enabled: true
    secretName: iddm-ingress-tls
```

## Pod-Level Certificates

Each pod (e.g., `fid-0`) requires its own certificate for internal traffic and LDAPS. Certificates must include Subject Alternative Names (SANs) for each pod's DNS name. This type of certificate is stored in **PKCS12 format** (`rli.keystore`) with password `radiantlogic`.

## Steps to set up pod level ceritificate

Even with Ingress TLS in place, services like LDAPS and internal APIs require certificates at the pod level for direct communication and mutual TLS (mTLS) if enabled.

**1. Define SANs for each replica:**

```
DNS.1 = fid-0.fid-headless.namespace.svc.cluster.local  
DNS.2 = fid-1.fid-headless.namespace.svc.cluster.local  
...  
DNS.n = localhost
```

**2. Generate the certificate and PKCS12 keystore:**

```bash
openssl genrsa -out fid-key.pem 4096

openssl req -new -key fid-key.pem -out fid.csr -config fid-san.conf

openssl x509 -req -in fid.csr -signkey fid-key.pem -out fid-cert.pem -days 365

openssl pkcs12 -export \
  -out rli.keystore \
  -inkey fid-key.pem \
  -in fid-cert.pem \
  -name rli \
  -password pass:radiantlogic
```

**3. Deploy the keystore to pods:**

```bash
kubectl cp rli.keystore <namespace>/<fid-pod>:/opt/radiantone/vds/vds_server/conf/rlinew.keystore
```

**4. Inside the pod, rename the file:**

```bash
mv rlinew.keystore rli.keystore
```

**5. Restart the pod or service to apply the changes.**


## Replacing Pod Certificates

To update certificates without breaking service, follow these steps:

1. Backup the existing keystore from the pod.
2. Upload the new certificate to the Control Panel trust store.
3. Replace the pod's `rli.keystore` file.
4. Restart the pod service (or delete pod for rolling restart).
5. Verify connectivity using OpenSSL and curl.


## Certificate Verification Commands

**View SAN entries:**

```bash
openssl x509 -in fid-cert.pem -text | grep DNS
```

**Test LDAPS locally:**

```bash
openssl s_client -connect localhost:2636
```

**Test Control Panel HTTPS:**

```bash
curl -k https://localhost:7070
```

**Quick multi-port cert check:**

```bash
for port in 2636 7070 7171 8090; do
  echo "Testing port $port"
  openssl s_client -connect localhost:$port < /dev/null 2>/dev/null | grep -E "subject=|issuer=|Verify return code"
done
```

## Automating Certificate Rotation (Optional)

**If using cert-manager, you can automate certificate rotation by adding these to the values. yaml file:**

```yaml
certificates:
  certManager:
    enabled: true
```

* Create a **CronJob** to monitor certificate expiration and reload pods when rotation occurs.


## Troubleshooting

| Symptom                               | Cause                                  | Resolution                                    |
| ------------------------------------- | -------------------------------------- | --------------------------------------------- |
| Classic UI fails to load              | Certificate missing SANs               | Regenerate certificate with correct SANs      |
| LDAPS fails                           | No pod certificate or incorrect CN     | Use proper pod-level cert with SANs           |
| Internal HTTPS works only via Ingress | Mismatch between Ingress and pod certs | Ensure both certs are trusted or from same CA |
| Certificate chain validation fails    | Missing intermediate or root CA        | Add full cert chain to the keystore           |


## Best Practices

* Use **PKCS12 format** (`.p12`) instead of deprecated JKS.
* Always include **all possible DNS SANs** for pod replicas.
* Use consistent keystore naming: `rli.keystore` and password `radiantlogic`.
* Rotate certificates **at least every 90 days**.
* Use **automation** (e.g., cert-manager) for renewals in production.
* Maintain and monitor trusted **root/intermediate CAs** centrally.


