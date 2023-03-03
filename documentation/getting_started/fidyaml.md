---
title: fidyaml
description: fidyaml
---

# Overview
The following sections in the RadiantOne FID yaml file can be customized.

<mark>Note – Do not use “TABS” for spacing in the .yaml file.  Use the space bar to indent as needed.</mark>

# Ports 
If you don’t want to use the default ports, customize the following sections in the .yaml file:
```
spec:
  ports:
  - port: 9100
    name: admin-http
  - port: 2389
    name: ldap
  - port: 2636
    name: ldap2
   
  ports:
  - containerPort: 2181
    name: zk-client
  - containerPort: 7070
    name: cp-http
   - containerPort: 7171
     name: cp-https
   - containerPort: 9100
     name: admin-http
   - containerPort: 9101
     name: admin-https
   - containerPort: 2389
     name: ldap
   - containerPort: 2636
     name: ldaps
   - containerPort: 8089
     name: http
   - containerPort: 8090
     name: https
```
# ZooKeeper Client Credentials
To configure the credentials that RadiantOne uses to connect to ZooKeeper, set the ZK_PASSWORD property.
```
- name: ZK_PASSWORD
     valueFrom:
            secretKeyRef:
              name: 
              key: 
```
You can leverage [Kubernetes secrets](https://kubernetes.io/docs/concepts/configuration/secret/#creating-a-secret-manually) instead of using clear text passwords for the ZooKeeper client credentials and the Directory Super User credentials in the .yaml file.  

# RadiantOne FID Super User Credentials
To configure the credentials used for the Radiantone Super User (e.g. cn=directory manager), set the FID_PASSWORD property.
```
- name: FID_PASSWORD
     valueFrom:
            secretKeyRef:
              name: 
              key: 
```
