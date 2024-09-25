---
title: Self-managed Deployment
description: Learn how to deploy RadiantOne Identity Data Management in your own Kubernetes cluster using Helm.
---

## Overview

This document provides instructions for deploying RadiantOne Identity Data Management on your Kubernetes cluster using Helm charts. It covers prerequisites, lists the microservices involved, and explains how to access the Identity Data Management control panel on your local machine via port-forwarding.

Self-managed Identity Data Management can be deployed on any Certified Kubernetes cluster (cloud or on-premise). We officially support a variety of providers such as Amazon EKS and Azure AKS. The installation process exclusively utilizes Helm, meaning you will use `helm install` or `helm upgrade` commands.

## Prerequisites

- Install [Kubernetes cluster](https://kubernetes.io/docs/setup/) of version 1.27 or higher. Refer to the [Sizing a Kubernetes cluster](https://developer.radiantlogic.com/idm/v7.4/getting_started/kubernetes/#sizing-a-kubernetes-cluster) document for additional details.
- Install [Helm](https://helm.sh/docs/intro/install/) version 3.0 or higher.
- Install [`kubectl`](https://kubernetes.io/docs/reference/kubectl/) version 1.27 or higher and configure it to access your Kubernetes cluster.
- An Identity Data Management license key, which will be provided to you during onboarding.
- Ensure that you have received Container Registry Access and image pull credentials named **(regred)** from RadiantLogic during onboarding.
- Ensure that you have necessary storage provisioners and storage classes configured for the Kubernetes cluster. Some examples of supported storage classes are `gp2`, [Azure disk](https://learn.microsoft.com/en-us/azure/aks/concepts-storage#persistent-volumes), etc.
- Estimate sufficient resources (CPU, memory, storage) for the deployment. Your Radiant Logic solutions engineer may guide you with this depending on your use case. 

## Steps for Deployment


1.  Create a file named `values.yaml` and open it in a text editor or IDE. Add `imagePullSecrets` field as shown below to the file to specify the secret credential that was provided to you by Radiant Logic.
     ```yaml
     imagePullSecrets:
       - name: regcred
     ```


2. **Update Helm configurations based on your requirements**

   In your `values.yaml`, ensure that you have the following properties at minimum. Note that the values of the properties such as `storageClass`, `resources`, etc., will differ depending on your use case, cloud provider, and storage requirements. Work with your Radiant Logic Solution Engineer to customize your Helm configuration.

   **Example `values.yaml` file:**
   ```yaml
   replicaCount: 1 # Use 1 for testing, use 2 or more for production if needed. 
   image:
     tag: 8.1.1
   fid:
     license: >-
       YourLicense
     rootPassword: "Enteryourrootpw"
   imagePullSecrets:
     - name: regcred
   persistence:
     enabled: true
     storageClass: "gp3" #Set the appropriate value for this based on your cloud provider.
     size: 30Gi
     annotations: {}
   zookeeper:
     persistence:
       enabled: true
       storageClass: "gp3" #Set the appropriate value for this based on your cloud provider.
   resources: # Set appropriate values for these fields based on your requirements.
     limits:
       cpu: 2
       memory: 4Gi
     requests:
       cpu: 2
       memory: 4Gi
   ```
   

   **Definitions of the properties:**
   - `replicaCount`: Specifies the number of RadiantOne nodes that will be deployed. Set the value to a minimum of 2 in production environments for high availability.
   - `image.repository`: Specifies the Docker repository for the Identity Data Management image. Set to `radiantone/fid`.
   - `image.tag`: Specifies the version of the Identity Data Management image to install or upgrade to.
   - `fid.rootUser`: Denotes the root user for RadiantOne. Set to `cn=Directory Manager`.
   - `fid.rootPassword`: Denotes the password for the root user. Set to `Welcome1234`.
   - `fid.license`: Set your Identity Data Management license key.
   - `persistence.enabled`: Indicates whether data persistence is enabled. Set to `true` or `false`.
   - `persistence.storageClass`: Defines the storage class for provisioning persistent volumes.
   - `persistence.size`: Specifies the size of the persistent volume for Identity Data Management.
   - `dependencies.zookeeper.enabled`: Specifies if Zookeeper should be deployed as a dependency. Always set to `true`.
   - `zookeeper.persistence.enabled`: Indicates if data persistence is enabled for Zookeeper.
   

Note that there are additional fields such as `metrics` that you can use to enable [metrics and logging](https://developer.radiantlogic.com/idm/v8.1/installation/metrics-and-logging/). 

5. **Create a namespace for your cluster and apply the credentials to that namespace.**
   ```bash
   kubectl create namespace self-managed
   kubectl apply -n self-managed -f regcred.yaml
   ```

6. **Dry run your deployment**
   ```bash
   helm -n self-managed upgrade --install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.0 --values values.yaml --set env.INSTALL_SAMPLES=true --debug --dry-run
   ```

   This command will process your YAML config files without deploying anything. If everything looks good, re-run the command without the `--dry-run` parameter. Setting `INSTALL_SAMPLES=true` is optional for testing purposes and not recommended for production deployment.

7. **Deploy self-managed Identity Data Management**

Ensure that you provide the appropriate path for your values.yaml file before running this command:

   ```bash
   helm -n self-managed upgrade --install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.0 --values values.yaml --debug
   ```

8. **Verify deployment**

   ```bash
   kubectl get pod -n self-managed
   ```

   You should see the following pods listed in the output, confirming that the deployment was successful:
   - api-gateway
   - authentication
   - data-catalog
   - directory-browser
   - directory-namespace
   - directory-schema
   - fid-0
   - iddm-proxy
   - iddm-ui
   - settings
   - system-administration
   - zipkin
   - zookeeper-0
   - zookeeper-1
   - zookeeper-2

## Accessing the Control Panel

To access the Identity Data Management control panel, first set up port forwarding for the `iddm-proxy-service` on port 8443:
```bash
kubectl port-forward svc/iddm-proxy-service -n self-managed 8443:443
```

After setting up port forwarding, you can reach the control panel at [https://localhost:8443/login](https://localhost:8443/login).

### Classic Control Panel

If needed, access the classic control panel via [https://localhost:8443/classic](https://localhost:8443/classic) after port-forwarding the `iddm-proxy-service`.

### Accessing the API Service

You can access the API service at [https://localhost:8443/api](https://localhost:8443/api).


### Accessing LDAP/ADAP Service

To access the LDAP/ADAP service, run the following command to port-forward (open another terminal):

> **Note:** Ensure that ports 2389, 2636, 8089, and 8090 are not already in use on your local machine.

```bash
kubectl port-forward svc/fid-app -n iddm-lab 2389 2636 8089 8090
```

- Access the LDAP service at: `ldap://localhost:2389` from your LDAP browser.
- Access the ADAP service at: `http://localhost:8089`.
- Access the LDAPS service at: `ldaps://localhost:2636` from your LDAP browser.
- Access the ADAP (secure) service at: `https://localhost:8090`.

## Updating a Deployment

To update any resources or settings, change the values in `values.yaml` and run the following command:

```bash
helm upgrade --install --namespace=iddm-lab fid oci://ghcr.io/radiantlogic-devops/h
```
