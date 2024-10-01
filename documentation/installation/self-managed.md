---
title: Self-managed Deployment
description: Learn how to deploy RadiantOne Identity Data Management in your own Kubernetes cluster using Helm.
---

## Overview

This document provides instructions for deploying RadiantOne Identity Data Management on your Kubernetes cluster using Helm charts. It covers prerequisites, lists the microservices involved, and explains how to access the Identity Data Management control panel on your local machine via port-forwarding.

Self-managed Identity Data Management can be deployed on supported Kubernetes cluster (cloud or on-premise). Amazon EKS and Azure AKS are currently supported and support for additional Kubernetes vendors like Google and RedHat OpenShift are planned. The installation process exclusively utilizes Helm, meaning you will use `helm install` or `helm upgrade` commands.

## Prerequisites

- [Kubernetes cluster](https://kubernetes.io/docs/setup/) of version 1.27 or higher. Refer to the [Sizing a Kubernetes cluster](https://developer.radiantlogic.com/idm/v7.4/getting_started/kubernetes/#sizing-a-kubernetes-cluster) document for additional details.
- Install [Helm](https://helm.sh/docs/intro/install/) version 3.0 or higher.
- Install [`kubectl`](https://kubernetes.io/docs/reference/kubectl/) version 1.27 or higher and configure it to access your Kubernetes cluster.
- An Identity Data Management license key, which will be provided to you during onboarding.
- Ensure that you have received Container Registry Access and image pull credentials named **(regred)** from RadiantLogic during onboarding.
- Ensure that you have necessary storage provisioners and storage classes configured for the Kubernetes cluster. Some examples of supported storage classes are `gp2`/`gp3`, [Azure disk](https://learn.microsoft.com/en-us/azure/aks/concepts-storage#persistent-volumes), etc.
- Estimate sufficient resources (CPU, memory, storage) for the deployment. Your Radiant Logic solutions engineer may guide you with this depending on your use case. 

## Steps for Deployment


1. **Set up values.yaml file for Helm deployment**

    Create a file named `values.yaml`. In your `values.yaml`, ensure that you have the following properties at minimum. Note that the values of the properties such as `storageClass`, `resources`, etc., will differ depending on your use case, cloud provider, and storage requirements. Work with your Radiant Logic Solution Engineer to customize your Helm configuration.

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
     # Set the appropriate value for storageClass based on your cloud provider.
     storageClass: "gp3"
     # Set the appropriate value for size based on your requirements.
     size: 10Gi 
     annotations: {}
   zookeeper:
     persistence:
       enabled: true
       # Set the appropriate value for this based on your cloud provider.
       storageClass: "gp3"
   resources: 
     # Set appropriate values for these fields based on your requirements. Ensure that you monitor usage over time 
     # and change the value accordingly when necessary.
     # Note that these values should be less than the sizing defined for your worker nodes. 
     limits:
       cpu: 2
       memory: 4Gi
     requests:
       cpu: 2
       memory: 4Gi
   env:
     INSTALL_SAMPLES: false
     FID_SERVER_JOPTS: '-Xms2g -Xmx4g' #To avoid memory swapping, -Xmx should never exceed the memory size defined in resources.
   ```
   

   **Definitions of the properties:**
   - `replicaCount`: Specifies the number of RadiantOne nodes that will be deployed. Set the value to a minimum of 2 in production           environments for high availability.
   - `image.repository`: Specifies the Docker repository for the Identity Data Management image. Set to `radiantone/fid`.
   - `image.tag`: Specifies the version of the Identity Data Management image to install or upgrade to.
   - `fid.rootUser`: Denotes the root user for RadiantOne. Set to `cn=Directory Manager`.
   - `fid.rootPassword`: Denotes the password for the root user. Set to `Welcome1234`.
   - `fid.license`: Set your Identity Data Management license key.
   - `persistence.enabled`: Indicates whether data persistence is enabled. Set to `true` or `false`.
   - `persistence.storageClass`: Defines the storage class for provisioning persistent volumes.
   - `persistence.size`: Specifies the size of the persistent volume for Identity Data Management. Ensure that you monitor usage over time and change the value as needed.
   - `dependencies.zookeeper.enabled`: Specifies if Zookeeper should be deployed as a dependency. Always set to `true`.
   - `zookeeper.persistence.enabled`: Indicates if data persistence is enabled for Zookeeper.
   - `resources`: Indicates the compute resources allocated to the Identity Data Management containers. Identity Data Management is deployed as a StatefulSet, which has implications for resource management. Changing resources requires careful planning as it affects all pods. Monitor your usage and change the values if needed over time. 
   

   Note that there are additional fields such as `metrics` that you can use to enable [metrics and logging](./metrics-and-logging/). 
   &nbsp;

2. **Create a namespace for your IDDM cluster**
   ```bash
   kubectl create namespace self-managed
   ```

3. **Deploy the credentials file provided to you in the same namespace**
   ```bash
   kubectl apply -n self-managed -f regcred.yaml
     ```
 

4. **Optional - dry run your deployment**

   ```bash
   helm -n self-managed upgrade --install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.0 --values values.yaml --set env.INSTALL_SAMPLES=true --debug --dry-run
   ```

   This command will process your YAML config files without deploying anything. If everything looks good, re-run the command without the `--dry-run` parameter. Setting `INSTALL_SAMPLES=true` is optional for testing purposes and not recommended for production deployment.


5. **Deploy self-managed Identity Data Management**

   Ensure that you provide the appropriate path for your values.yaml file before running this command:

   ```bash
   helm -n self-managed install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.0 --values </path/to/your/values.yaml> --debug
   ```

6. **Verify deployment**

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
kubectl port-forward svc/fid-app -n self-managed 2389 2636 8089 8090
```

- Access the LDAP service at: `ldap://localhost:2389` from your LDAP browser.
- Access the ADAP service at: `http://localhost:8089`.
- Access the LDAPS service at: `ldaps://localhost:2636` from your LDAP browser.
- Access the ADAP (secure) service at: `https://localhost:8090`.

## Updating a Deployment

To update any resources or settings, change the values in `values.yaml` and run the following command:

```bash
   helm -n self-managed upgrade --install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.0 --values </path/to/your/values.yaml> --debug
```

## Troubleshooting your Kubernetes environment

The steps listed here are meant to help you identify and troubleshoot issues related to pod deployments in your Kubernetes environment.

1. **Check events for deployment issues**

   This command lists events in the specified namespace, helping to identify any issues related to pod deployment.
     
     ```bash
     kubectl get events -n <namespace>
      ```
   

3. **Describe a specific pod**

   This command provides detailed information about the pod, including its status, conditions, and any errors that might be affecting its deployment.

     ```bash
     kubectl describe pods/fid-0 -n <namespace>
     ```

4. **Check Zookeeper status**

   Check if Zookeeper is running or not by executing:

     ```bash
     kubectl exec -it zookeeper-0 -n <namespace> -- bash -c "export JAVA_HOME=/opt/radiantone/rli-zookeeper-external/jdk/jre/;/opt/radiantone/rli-zookeeper-external/zookeeper/bin/zkServer.sh status"
     ```

5. **Access Zookeeper or FID container**

   Shell into the Zookeeper container. This will open an interactive shell session inside the zookeeper-0 pod, allowing you to execute commands directly within that container:

     ```bash
     kubectl exec -it zookeeper-0 -n <namespace> -- /bin/bash
     ```
    Shell into the FID container:

     ```bash
     kubectl exec -it fid-0 -n <namespace> -- /bin/bash
     ```

6. **Next, run cluster command**

   This command lists the cluster configuration, which can help identify any existing issues. Inside the FID container, run:
     
     ```bash
     kubectl exec -it fid-0 -n <namespace> -- cluster.sh list
     ```

7. **List Java processes**

   To see what Java processes are running in the FID container, execute:
     
     ```bash
     kubectl exec -it fid-0 -n <namespace> -- /opt/radiantone/vds/jdk/bin/jps -lv
     ```

8. **Get Kubernetes context**

    Ensure you're interacting with the correct cluster by running:
     
     ```bash
     kubectl config get-contexts
     ```
## Deleting Identity Data Management

1. **Uninstall the Identity Data Management deployment**

    To uninstall the Identity Data Management deployment from your namespace, run:
     
     ```bash
     helm uninstall --namespace=<namespace> fid
     ```

2. **Verify uninstallation**

    To confirm that the deployment has been successfully removed, execute:
     
     ```bash
     kubectl get all -n <namespace>
     ```

     You should see that all Identity Data Management related pods have been removed. If everything looks good, proceed to the next step.

3. **Delete PVCs**

    Delete all existing PVCs from your namespace.

      ```bash
      kubectl get pvc -n <namespace>
      kubectl delete pvc <pvc-name> -n <namespace>
      ```

3. **Delete the namespace**

    To delete the namespace you created, run:
     
     ```bash
     kubectl delete namespace <namespace>
     ```

4. **Verify namespace deletion**

    To check if the namespace has been deleted, execute:
     
     ```bash
     kubectl get namespace
     ```

     You should see that the previously deleted namespace is not listed. 
