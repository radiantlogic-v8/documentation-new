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


## Requirements

* All TLS certificates must include Subject Alternative Names (SANs) for each hostname, as modern TLS implementations no longer rely on the common name (CN) alone.
* To support StatefulSet scaling, the certificates must cover all potential pod replicas, such as fid-0 through fid-n.
* The keystore format must be PKCS12, since JKS is deprecated and no longer recommended. Additionally, the keystore file must be named rli.keystore and secured with the password radiantlogic.

## Certificate types 

### Ingress Certificate

This certificate is used to secure external traffic entering the cluster (e.g., from web browsers or external LDAP clients). It is associated with public-facing hostnames (e.g., `your.identitydatamangementurl.com`).
Ingress certificates need to be installed as a Kubernetes TLS secret.

**Ingress-Level TLS Termination Behavior:**

- Incoming external traffic is decrypted at the ingress controller.
- Traffic from the ingress to FID pods is unencrypted (unless TLS passthrough is enabled).
- Identity Data Management FID certificates are still required for LDAPS (port 2636) and internal HTTPS services.
- Accessing the Control Panel may require valid certificates at both the ingress and pod levels.


### Steps to set up an ingress certificate

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

Pods certificates are required by the following components:

* LDAPS services require valid pod certificates for handling direct LDAP over TLS (LDAPS) connections.
* Internal HTTPS requires valid pod certificates for pod-to-pod secure communication.
* Control Panel UI requires valid pod certificates while accessing Identity Data Management interfaces.
* Classic Control Panel requires valid pod certificates, even when TLS is terminated at the ingress.

### How Ingress TLS Affects Pod Certificates

Ingress TLS impacts which certificates are used based on the type of traffic:

* For HTTP/HTTPS traffic, the ingress controller terminates the TLS connection and forwards plain HTTP to the iddm-proxy service. As a result, FID pod certificates are not used for handling external web traffic.

* For LDAP/LDAPS traffic, the ingress is configured with TCP passthrough, which allows encrypted traffic to be forwarded directly to the FID pods. In this case, FID pod certificates are used, and clients validate these certificates directly.

* When accessing the Control Panel, the certificate used depends on the access path: if accessed through ingress, the ingress certificate is used; if accessed directly at the pod level, the FID pod certificate is used. The Classic Control Panel may require validation of both ingress and pod certificates, depending on the configuration.

### Steps to set up and manage pod level ceritificate

Even with Ingress TLS in place, services like LDAPS and internal APIs require certificates at the pod level for direct communication and mutual TLS (mTLS) if enabled.

**1. Create certificate configuration**

```bash
# Create pod certificate configuration with StatefulSet scaling support
cat > fid-pod-cert.conf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = US
ST = State
L = City
O = Organization
OU = IDDM
CN = fid-0.fid-headless.iddm-gnanirahul.svc.cluster.local

[v3_req]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
basicConstraints = CA:FALSE
subjectAltName = @alt_names

[alt_names]
# Support for StatefulSet scaling (0-4 = 5 replicas)
DNS.1 = fid-0.fid-headless.iddm-gnanirahul.svc.cluster.local
DNS.2 = fid-1.fid-headless.iddm-gnanirahul.svc.cluster.local
DNS.3 = fid-2.fid-headless.iddm-gnanirahul.svc.cluster.local
DNS.4 = fid-3.fid-headless.iddm-gnanirahul.svc.cluster.local
DNS.5 = fid-4.fid-headless.iddm-gnanirahul.svc.cluster.local
# Headless service
DNS.6 = fid-headless.iddm-gnanirahul.svc.cluster.local
DNS.7 = *.fid-headless.iddm-gnanirahul.svc.cluster.local
# Regular service
DNS.8 = fid.iddm-gnanirahul.svc.cluster.local
# Short names for internal access
DNS.9 = fid-0
DNS.10 = fid-1
DNS.11 = fid-2
DNS.12 = fid-3
DNS.13 = fid-4
# Localhost for testing
DNS.14 = localhost
IP.1 = 127.0.0.1
EOF
```

**2. Generate key, certificate and PKCS12 keystore for Identity Data Management:**

```bash
# Generate private key and certificate
openssl genrsa -out fid-key.pem 4096
openssl req -new -key fid-key.pem -out fid.csr -config fid-pod-cert.conf
openssl x509 -req -in fid.csr -signkey fid-key.pem -out fid-cert.pem -days 365 -extensions v3_req -extfile fid-pod-cert.conf

# Create PKCS12 keystore (recommended over JKS)
openssl pkcs12 -export -out rli.keystore \
  -inkey fid-key.pem \
  -in fid-cert.pem \
  -name rli \
  -password pass:radiantlogic

# Verify the keystore
keytool -list -v -keystore rli.keystore -storepass radiantlogic -storetype PKCS12 | grep -A1 "Subject Alternative Name"
```


## Replacing Pod Certificates

To update certificates without breaking service, follow these steps:

1. Create a local backup for the existing cert and keystore.

Example commands for one pod:

```
C:\Users\abcuser>kubectl.exe cp ${NAMESPACE}/${RELEASE_NAME}-iddm-fid/fid-0:/opt/radiantone/vds/vds_server/conf/rli.keystore ./backup/rli.keystore.backup
C:\Users\abcuser>kubectl.exe cp ${NAMESPACE}/${RELEASE_NAME}-iddm-fid/fid-0:/opt/radiantone/vds/vds_server/conf/rli.cer ./backup/rli.cer.backup

```

`kubectl cp ./rli.keystore duploservices-qa2/fid-0:/opt/radiantone/vds/vds_server/conf/rlicopy.keystore ` 

Example script for multiple pods:

```
# Set variables
NAMESPACE="iddm-gnanirahul"
RELEASE_NAME="my-iddm"

# Create backup directory
mkdir -p ./backup/$(date +%Y%m%d)

# Backup from all pods if StatefulSet
for i in 0 1 2; do
  if kubectl get pod ${RELEASE_NAME}-iddm-fid-$i -n ${NAMESPACE} &>/dev/null; then
    kubectl cp ${NAMESPACE}/${RELEASE_NAME}-iddm-fid-$i:/opt/radiantone/vds/vds_server/conf/rli.keystore \
      ./backup/$(date +%Y%m%d)/rli.keystore.pod$i.backup
  fi
done
```



2. Upload the new certificate to the Control Panel trust store. 

Add the new certificate to the trust store by accessing your control panel URL. In Control Panel, navigate to Client Certificates and click IMPORT. Give it an alias name and browse your certificate file. After selecting the file, click OK. 

3. Once you have replaced the certificate, click on the certificate alias and navigate to the certificate properties tab. Ensure that your certificate has a SAN property assigned to it.  


4. Replace the pod's `rli.keystore` file.

Navigate to pod's /vds/vds_server/conf and rename the old rli.keystore to rliold.keystore. Then, rename the new rlinew.keystorefile to rli.keystore by following these steps: 

* Copy new keystore to first pod:
   ```bash
   kubectl cp ./rli.keystore ${NAMESPACE}/${RELEASE_NAME}-iddm-fid-0:/opt/radiantone/vds/vds_server/conf/rlinew.keystore
   ```

* Access the pod:
  `kubectl exec -it -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-0 -- bash`

* Replace the keystore and fix permissions:

  `cd /opt/radiantone/vds/vds_server/conf`
  `mv rli.keystore rliold.keystore.$(date +%Y%m%d)`
  `mv rlinew.keystore rli.keystore`
  `chown 1000:1000 rli.keystore`
  `chmod 660 rli.keystore`

* Update keystore type to PKCS12 if you haven't already done so:

  ```
  cd /opt/radiantone/vds/vds_server/conf/jetty
  cat config.properties  # Check current type
  # If changing from JKS to PKCS12, update:
  sed -i 's/jetty.ssl.keystore.type=JKS/jetty.ssl.keystore.type=PKCS12/' config.properties
  ```
  Then, exit bash by running the `exit` command. 

5. Restart the pod by following these steps (or delete pod for rolling restart):
   
* Access the pod:
  `kubectl exec -it -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-0 -- bash`

* After accessing it, stop the server and relaunch control panel:

```
  cd /opt/radiantone/vds/bin
  ./stopWebAppServer.sh
  sleep 5
  ./launchControlPanel.sh
```

* Wait for services to come back up: 
 `kubectl get pod ${RELEASE_NAME}-iddm-fid-0 -n ${NAMESPACE} -w`


## Verify Certificate Installation and Connectivity 

### LDAPS Test
```bash
kubectl port-forward -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-0 2636:2636 &
openssl s_client -connect localhost:2636 -showcerts | grep -A20 "Certificate chain"
```

### Check SANs
```bash
openssl s_client -connect localhost:2636 2>/dev/null | openssl x509 -noout -text | grep -A1 "Subject Alternative Name"
```

### Control Panel HTTPS Test
```bash
kubectl port-forward -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-0 7171:7171 &
curl -k https://localhost:7171 -v 2>&1 | grep "subject:"
```

### Cleanup
```bash
kill %1 %2
```

## StatefulSet Certificate Update (All Pods)

If you would like to replace certificates in all pods at once, you can create a script as shown below and execute the script. 

```bash
#!/bin/bash
NAMESPACE="iddm-gnanirahul"
RELEASE_NAME="my-iddm"
REPLICAS=3

# Step 1: Copy & Replace Keystore in All Pods
for i in $(seq 0 $((REPLICAS-1))); do
  echo "Updating fid-$i..."
  kubectl cp ./rli.keystore ${NAMESPACE}/${RELEASE_NAME}-iddm-fid-$i:/opt/radiantone/vds/vds_server/conf/rlinew.keystore
  kubectl exec -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-$i -- bash -c '
    cd /opt/radiantone/vds/vds_server/conf &&
    mv rli.keystore rliold.keystore &&
    mv rlinew.keystore rli.keystore &&
    chown 1000:1000 rli.keystore &&
    chmod 660 rli.keystore
  '
done

# Step 2: Restart StatefulSet
kubectl rollout restart statefulset ${RELEASE_NAME}-iddm-fid -n ${NAMESPACE}
kubectl rollout status statefulset ${RELEASE_NAME}-iddm-fid -n ${NAMESPACE}

# Step 3: Verify Each Pod
for i in $(seq 0 $((REPLICAS-1))); do
  echo "Verifying fid-$i..."
  kubectl exec -n ${NAMESPACE} ${RELEASE_NAME}-iddm-fid-$i -- \
    openssl s_client -connect localhost:2636 -servername fid-$i.fid-headless </dev/null 2>/dev/null | \
    grep "Verify return code"
done
```

## Double Certificate Verification

When both ingress-level and pod-level certificates are deployed, you will need to verify proper installation of both certificates. External HTTPS access validates the ingress certificate. Internal service communication may validate the pod-level certificate. Accessing the classic control panel often involves double verification, where both the ingress and pod certificates are validated.

Add the following properties to your values.yaml file to configure verification process:

```
# values.yaml
ingress:
  enabled: true
  tls:
    enabled: true
    secretName: iddm-ingress-tls  # Ingress (external) certificate

iddm:
  fid:
    tls:
      enabled: true
      # Pod-level certificate configuration is handled per pod

  iddmProxy:
    ssl:
      verifyBackend: true  # Enable verification of pod certificates
      trustStore: /opt/radiantone/vds/vds_server/conf/cacerts  # Trust store for internal certs
```

### Testing Double Certificate Chain

* Test external access (ingress certificate): 
  `curl -v https://iddm.example.com 2>&1 | grep "subject:"`

* Test internal access (pod certificate): 
  `kubectl exec -it deployment/iddm-proxy -- curl -v https://fid-0.fid-headless:8090 2>&1 | grep "subject:"`

* Verify both certificates in chain:
  `openssl s_client -connect iddm.example.com:443 -showcerts | grep "s:CN"`

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


