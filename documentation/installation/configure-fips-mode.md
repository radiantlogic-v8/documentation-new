---
title: Configure FIPS Mode and Internal TLS
description: Learn how to enable FIPS mode and Internal TLS in your Self-Managed RadiantOne Identity Data Management deployment.
---

# Configure FIPS Mode and Internal TLS

## Overview

The Federal Information Processing Standards (FIPS) are security standards published by the National Institute of Standards and Technology (NIST). FIPS 140-3 specifies security requirements for cryptographic modules that protect sensitive data.

In RadiantOne Identity Data Management 9.1.0 and later, FIPS compliance extends to every containerized component, including the core Identity Data Management engine (FID), ZooKeeper, and all supporting microservices. These components run on Chainguard FIPS base container images and use the JDK's preconfigured FIPS providers.

Version 9.1.0 also introduces Internal TLS, which encrypts all inter-service and pod-to-pod traffic within the Kubernetes cluster. When Internal TLS is enabled, no component accepts plain-text connections.

FIPS mode and Internal TLS are independent features:

| To… | Configure |
| :--- | :--- |
| Use only FIPS-validated cryptography | `fipsMode: ENABLED` |
| Encrypt all traffic between pods only | `internalTls.mode: SECRET` (or `ISTIO`) |
| Enable both capabilities | Both settings |

Both features are disabled by default. Existing deployments remain unchanged until you add these settings to your Helm values.

>[!note]
>FIPS mode and Internal TLS are supported only in Self-Managed RadiantOne Identity Data Management deployments.

## Prerequisites

Before deploying, confirm that you have:

- RadiantOne Identity Data Management version 9.1.0 or later.
- The `iddm-helm` Helm chart, version 9.1.0 or later.
- A Kubernetes cluster, version 1.27 or later, with `kubectl` and `helm` configured.
- For Internal TLS in Secret mode, a Kubernetes TLS secret containing a Certificate Authority (CA) signing certificate and its private key. See [Step 1](#step-1-create-the-ca-signing-secret).

## How Internal TLS Works

When `internalTls.mode` is set to `SECRET`:

1. **You provide a CA.** Before installing the chart, create a Kubernetes TLS secret containing your CA signing certificate and private key.
2. **Each pod generates its own certificate.** Before a service starts, the `internal-tls-cert-gen` init container runs in its pod. It generates an X.509 server certificate for the service's internal Kubernetes DNS name and signs it with your CA. If you customize service names through the Helm chart, the generated certificates automatically use those names.
3. **All components trust the same CA.** The CA is added to each component's trust store so that every component can verify the others.
4. **Only TLS ports are available.** Kubernetes Services expose only TLS ports, and applications listen only on those ports. This applies to FID, ZooKeeper, and all microservices. Legacy plain-text ports, such as LDAP port 2389, are not exposed. Microservices communicate exclusively over HTTPS on port 8443.
5. **ZooKeeper uses TLS ports.** ZooKeeper client and admin ports use different port numbers to indicate that they use TLS. The quorum and leader-election ports retain their standard numbers, but their traffic is also encrypted.

Identity Data Management's key store (`rli.keystore`) contains the certificate signed by your CA rather than a self-signed certificate.

### Additional behavior when FIPS mode is enabled

When `fipsMode: ENABLED` is configured together with Internal TLS, Internal TLS uses only FIPS-approved algorithms.

## Helm Configuration

Add the following settings to the `global` section of your `values.yaml` file:

```yaml
global:
  fipsMode: ENABLED        # ENABLED | DISABLED
  internalTls:
    mode: SECRET           # DISABLED | SECRET | ISTIO
    secret:
      signingCertSecretName: <your-ca-secret-name>
  imagePullSecrets:
    - name: regcred
```

### Image Pull Secrets

Internal TLS uses additional supporting images when pods are created. So that every subchart can pull these images, set `imagePullSecrets` at the global level:

```yaml
global:
  imagePullSecrets:
    - name: regcred
```

This global setting replaces the `imagePullSecrets` setting used in earlier versions. You don't need to remove your existing setting. It is safe to keep both.

>[!note]
>If you deploy `iddm-helm` as a subchart of your own parent chart, nest these values under the subchart's name, for example, `fid:` > `global:` > `fipsMode`.

### Parameter Reference

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `global.fipsMode` | string | `DISABLED` | Set to `ENABLED` to enforce FIPS 140-3 mode across all Identity Data Management pods and services. Allowed values: `DISABLED`, `ENABLED`. |
| `global.internalTls.mode` | string | `DISABLED` | Controls encryption of inter-pod traffic.<br>`DISABLED`: inter-service traffic uses unencrypted standard HTTP/LDAP.<br>`SECRET`: the chart automatically generates inter-service TLS certificates signed by the CA in the secret you provide.<br>`ISTIO`: uses your existing Istio service mesh for mutual TLS (mTLS). |
| `global.internalTls.secret.signingCertSecretName` | string | `""` | Required when mode is `SECRET`. Specifies the name of the Kubernetes TLS secret in the release namespace that contains the signing CA certificate and private key. |

>[!warning]
>The `PREVALIDATED` value available in version 8.5 has been removed. Setting `global.fipsMode: PREVALIDATED` causes a Helm validation error. Use `ENABLED` or `DISABLED` instead.

### Trusting Identity Data Management Certificates

Other applications in the cluster that connect to Identity Data Management, such as ingress controllers, gateway controllers, and monitoring tools, must be configured to trust the Identity Data Management certificates.

Because you supply the signing CA and, if applicable, the certificate trust chain, configure these applications to trust that same signing CA and trust chain. As long as all parties trust the certificates you supply, applications can communicate with Identity Data Management without issues.

Do not configure applications to trust individual **pod-level certificates**. These certificates are temporary and are re-created each time a pod starts.

### Configuring a certificate trust chain (optional)

Trust chains are supported, but are not required for every deployment. If your signing CA has a trust chain, store each certificate in the chain in its own TLS secret. Each secret needs only the `tls.crt` field. Do not include private keys.

Reference these secrets in the Helm chart under `fid.global.internalTls.secret.trustChainSecrets`:

```yaml
fid:
  global:
    internalTls:
      mode: SECRET
      secret:
        signingCertSecretName: signing-ca-secret
        trustChainSecrets:
          - name: trust-chain-ca-secret
```

Set `signingCertSecretName` to the name of the secret containing your signing certificate, and add an entry under `trustChainSecrets` for each certificate in the trust chain.

### Choosing between Secret mode and Istio mode

| Item | Secret mode | Istio mode |
| :--- | :--- | :--- |
| What you provide | A CA certificate and private key in a Kubernetes secret | An existing Istio service mesh |
| Certificate issuance | An init container in each pod automatically issues certificates | Istio manages certificate issuance |
| Certificate rotation | Requires restarting every pod, causing downtime | Istio handles rotation without downtime |
| Best for | Clusters without a service mesh | Clusters that already use Istio or require zero-downtime rotation |

## Enable FIPS with Internal TLS (Secret Mode)

Use Secret mode to encrypt all internal pod-to-pod communication when your environment does not use a service mesh such as Istio.

### Step 1: Create the CA signing secret

Create a Kubernetes TLS secret containing your root or intermediate CA certificate and its private key. Create the secret in the namespace where you will deploy Identity Data Management:

```bash
kubectl create secret tls iddm-ca-secret \
  --cert=/path/to/ca.crt \
  --key=/path/to/ca.key \
  -n <namespace>
```

>[!note]
>If your signing certificate is part of a trust chain, such as an intermediate CA, you must also provide the additional certificates in that chain. See [Configuring a certificate trust chain (optional)](#configuring-a-certificate-trust-chain-optional).

### Step 2: Configure values.yaml

Add the FIPS and Internal TLS settings alongside your other deployment values:

```yaml
global:
  fipsMode: ENABLED

  imagePullSecrets:
    - name: regcred
  internalTls:
    mode: SECRET
    secret:
      signingCertSecretName: iddm-ca-secret

# Top-level chart configuration
replicaCount: 1

fid:
  rootUser: cn=Directory Manager
  license: "<your-license>"
  rootPassword: "<your-password>"
  persistence:
    enabled: true
    storageClass: <your-storage-class>
    size: 30Gi

zookeeper:
  replicaCount: 3
  persistence:
    enabled: true
    storageClass: <your-storage-class>
    size: 10Gi
```

### Step 3: Install or deploy

Deploy Identity Data Management using the Helm chart:

```bash
helm -n <namespace> install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.1.0 \
  --values values.yaml
```

>[!warning]
>After you enable FIPS mode, you cannot disable it. See [Known Limitations](#known-limitations). Internal TLS can be enabled or disabled.

## Verify the Deployment

Test FIPS mode and Internal TLS individually before testing them together.

### 1. Verify FIPS enforcement in the logs

Check the FID startup log to confirm that the BouncyCastle FIPS security module is loaded:

```bash
kubectl -n <namespace> logs fid-0 -c fid | grep "running in FIPS mode"
```

Expected output:

```
WARN com.rli.slapd.server.VDSServer - ### Server started! The server is running in FIPS mode with the security module from: the JDK's preconfigured BouncyCastle FIPS providers
```

### 2. Verify the FIPS container images

Confirm that every running Identity Data Management workload uses a Chainguard FIPS image with a tag ending in `-fips`:

```bash
kubectl -n <namespace> get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{range .spec.containers[*]}{"  "}{.image}{"\n"}{end}{end}'
```

### 3. Verify Internal TLS certificate generation

Check the init container logs on any microservice pod to confirm that the certificate was issued and signed:

```bash
kubectl -n <namespace> logs deployment/iddm-api-gateway -c internal-tls-cert-gen
```

Then use the application as usual. Browse data in the Control Panel, verify that leadership is handled correctly across nodes, and confirm that data replicates between FID nodes.

## Rotating the CA Certificate

Certificates generated in Secret mode are signed by the CA you provide. When that CA expires, the certificates are no longer trusted. To rotate the CA:

1. Create a new CA.
2. Update the Kubernetes secret specified by `signingCertSecretName` with the new CA certificate and private key.
3. Restart all Identity Data Management pods.

>[!warning]
>Secret mode does not support zero-downtime certificate rotation. Rotation requires restarting all workloads, which causes downtime. For zero-downtime rotation, use `internalTls.mode: ISTIO`.

## Troubleshooting

| Symptom | Likely cause and fix |
| :--- | :--- |
| `helm install` fails with a validation error for `fipsMode` | `PREVALIDATED` is no longer supported. Set the value to `ENABLED` or `DISABLED`. |
| Connection errors occur between components | A component might be attempting to connect through a plain-text port, which is closed when Internal TLS is enabled. The connection fails with a hard error. |

## Known Limitations

- **Reverting FIPS mode:** You cannot change an existing deployment from `fipsMode: ENABLED` to `DISABLED`. FIPS-generated BCFKS key stores and data structures cannot be automatically converted back to standard formats. Reverting therefore requires a fresh installation.
- **Certificate rotation in Secret mode:** Rotation requires restarting all pods. Use Istio mode if you require zero-downtime rotation.
- **Git authentication over SSH:** When FIPS mode is enabled, Configuration Promotion supports Git over HTTPS only. SSH-based Git authentication is not supported.
- **Monitoring exporters:** Prometheus metrics and logging exporters require non-FIPS images. Logging and metrics exporters do not work when FIPS mode is enabled in version 9.1.0. This limitation will be addressed in a future release.
