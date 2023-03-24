---
title: configmap
description: configmap
---

# Overview
Sections in the configmap.yaml file to customize:

>[!note] Do not use “TABS” for spacing in the .yaml file.  Use the space bar to indent as needed.

# ZooKeeper Service
Your ZooKeeper Service as described in the ZooKeeper yaml file.
```
ZK_CONN_STR: "myzk:2181"   
```
# RadiantOne Cluster Name
Your RadantOne cluster name:
```
ZK_CLUSTER: "fid"
```
# Credentials to connect to ZooKeeper
The ZooKeeper client credentials, for RadiantOne nodes to connect to ZooKeeper.
```
ZK_PASSWORD:
```
# RadiantOne Super User Credentials
Directory Super User credentials.
```
FID_PASSWORD:
```

In the default configmap.yaml, the ZooKeeper client credentials and the RadiantOne FID super user (e.g. cn=directory manager) credentials are set to the same value of: secret1234
```
kind: Secret
metadata:
  name: rootcreds
type: Opaque
data:
  username: Y249RGlyZWN0b3J5IE1hbmFnZXI=
  password: c2VjcmV0MTIzNA==
```
The encoded values can be generated using this command (example below is for the password):
```
echo -n "secret1234" | base64
c2VjcmV0MTIzNA==
```
You can leverage [Kubernetes secrets](https://kubernetes.io/docs/concepts/configuration/secret/#creating-a-secret-manually) instead of using clear text passwords for the ZooKeeper client credentials and the Directory Super User credentials in the .yaml file. 

The password key can be used to map to both the ZK_PASSWORD and FID_PASSWORD. To use different passwords for the ZooKeeper client credentials and the RadiantOne FID super user password, add another key (e.g. fid_password) and add it in the secrets config. 
```
  echo -n "mysecret1234" | base64
  bXlzZWNyZXQxMjM0

  kind: Secret
metadata:
  name: rootcreds
type: Opaque
data:
  username:
  password: 
  fid_password:  bXlzZWNyZXQxMjM0
```
 
You also need to refer to that secret key in the [fid.yaml](fidyaml.md) file. 
``` 
        - name: FID_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rootcreds
              key: fid_password
```

# RadiantOne License
Your RadiantOne FID license key value:
``` 	
LICENSE: "{rlib}INSERT_YOUR_RLI_LICENSE_KEY"
```
