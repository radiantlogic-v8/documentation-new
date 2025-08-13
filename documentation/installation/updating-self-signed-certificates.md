---
title: Updating ceritificates
description: Learn how to create and manage self-signed server certificates.
---

## Overview

Certificates are used for LDAPS (LDAP over TLS), internal HTTPS (pod-to-pod communication), 
accessing Identity Data Management via the Control Panel UI, and for accessing the Classic Control Panel.

This document provides steps on how to update your certificates in self-managed Identity Data Management. For each keystore type, steps are provided for two scenarios:

- **Unchanged password** – You use the same password as the old one (default value is `radiantlogic`) in the new keystore. This avoids modifying the `config.properties` password entry, so only the keystore file needs to be replaced.  
- **Changed password** – You use a different password for the new keystore. This requires updating `config.properties` (manually via CLI or automatically through the Control Panel) so FID can read the keystore at startup.

**Prerequisites**

* You must have access to your deployed self-managed Identity Data Management.
* You must have generated your certificate. 
* When you create your certificate, it must be properly formed and include all relevant hostnames using the Subject Alternative Name (SAN) extension. This is critical for compatibility with modern TLS clients and to avoid runtime errors due to hostname mismatches during certificate validation. For replica sets, it is recommended to include at least five pod FQDNs in your SAN. This approach supports better scalability.


To update certificates without breaking service, follow these steps:

## Step 1 – Mount the new keystore into the pods

Before making any changes, mount your new keystore into each Identity Data Management pod:

### 1.1 Create a Kubernetes secret (either JKS or PKCS#12) 

**JKS keystore**
```bash
kubectl create secret generic fid-keystore-secret \
  --from-file=rli.keystore -n <namespace>
```

**PKCS#12 keystore**
```bash
kubectl create secret generic fid-keystore-secret \
  --from-file=my-cert.p12 -n <namespace>
```


### 1.2 Update `values.yaml` to mount the secret into the pods

```yaml
extraVolumes:
  - name: fid-keystore
    secret:
      secretName: fid-keystore-secret

extraVolumeMounts:
  - name: fid-keystore
    mountPath: /etc/rli/certs
    readOnly: true
```


### 1.3 Update the helm deployment 

```bash
helm upgrade <release-name> oci://... -n <namespace> --values values.yaml
```

After this step, the keystore is available at `/etc/rli/certs/<filename>`.



## Step 2 – Activate the New Keystore

The activation process depends on keystore type (JKS or PKCS#12), password scenario (unchanged or changed), and update method (Control Panel or CLI). Follow the steps appropirate for your use case. 

### 2.1 JKS Keystore

#### Activate without changing the password

**Using Control Panel UI**
1. Log in to **Control Panel** → **Settings → Security → SSL**  
2. Enter the current password (`radiantlogic`) in **Keystore Password**  
3. Click **Save** (updates `config.properties` automatically)  
4. Restart pods:
```bash
kubectl rollout restart statefulset/fid -n <namespace>
```

**Using CLI**
```bash
POD=$(kubectl get pod -n <namespace> -l "app.kubernetes.io/name=fid" -o jsonpath="{.items[0].metadata.name}")
kubectl exec -it $POD -n <namespace> -- bash
cd /opt/radiantone/vds/vds_server/conf/
cp rli.keystore rli.keystore.bak
cp /etc/rli/certs/rli.keystore .
exit
kubectl rollout restart statefulset/fid -n <namespace>
```

#### Activate with a new password 

**Using Control Panel UI**
1. Go to **Settings → Security → SSL**  
2. Upload the new keystore if needed  
3. Set **Keystore Password** to the new value  
4. Click **Save** and restart:
```bash
kubectl rollout restart statefulset/fid -n <namespace>
```

**Using CLI**
```bash
# Replace keystore as above
kubectl exec -it $POD -n <namespace> -- bash
ENCRYPTED=$(/opt/radiantone/vds/bin/vdsconfig.sh encrypt-value -value 'NewPassword')
cd /opt/radiantone/vds/vds_server/conf/jetty/
sed -i "s|^jetty.ssl.keystore.password=.*|jetty.ssl.keystore.password=$ENCRYPTED|" config.properties
exit
kubectl rollout restart statefulset/fid -n <namespace>
```

### 2.2 PKCS#12 Keystore

#### Activate without changing the password

**Using Control Panel UI**
1. Set:
   - **Keystore type:** PKCS12  
   - **Keystore location:** `$RLI_HOME/vds_server/conf/custom.p12`  
   - **Keystore password:** current value  
2. Save and restart:
```bash
kubectl rollout restart statefulset/fid -n <namespace>
```

**Using CLI**
```bash
# inside the pod
cd /opt/radiantone/vds/vds_server/conf/
cp /etc/rli/certs/my-cert.p12 ./custom.p12
cd /opt/radiantone/vds/vds_server/conf/jetty/
sed -i 's|jetty.ssl.keystore.location=.*|jetty.ssl.keystore.location=$RLI_HOME/vds_server/conf/custom.p12|' config.properties
sed -i 's|jetty.ssl.keystore.type=.*|jetty.ssl.keystore.type=PKCS12|' config.properties
exit
kubectl rollout restart statefulset/fid -n <namespace>
```

#### Activate with a new password 

**Using Control Panel UI**
1. Configure `.p12` as in Scenario A  
2. Enter new password and save  
3. Restart:
```bash
kubectl rollout restart statefulset/fid -n <namespace>
```

**Using CLI**
```bash
ENCRYPTED=$(/opt/radiantone/vds/bin/vdsconfig.sh encrypt-value -value 'NewPassword')
sed -i 's|jetty.ssl.keystore.location=.*|jetty.ssl.keystore.location=$RLI_HOME/vds_server/conf/custom.p12|' config.properties
sed -i 's|jetty.ssl.keystore.type=.*|jetty.ssl.keystore.type=PKCS12|' config.properties
sed -i "s|^jetty.ssl.keystore.password=.*|jetty.ssl.keystore.password=$ENCRYPTED|" config.properties
exit
kubectl rollout restart statefulset/fid -n <namespace>
```


## Step 3 - Verify the certificate update

### Check rollout status
```bash
kubectl rollout status statefulset/fid -n <namespace>
```

### Test SSL connection
```bash
kubectl port-forward -n <namespace> fid-0 2636:2636 &
openssl s_client -connect localhost:2636 -showcerts | grep -A20 "Certificate chain"
```

### Check SAN entries
```bash
openssl s_client -connect localhost:2636 2>/dev/null | \
openssl x509 -noout -text | grep -A1 "Subject Alternative Name"
```
