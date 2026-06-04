---
title: Self-managed Deployment
description: Learn how to deploy RadiantOne Identity Data Management in your own Kubernetes cluster using Helm.
---

## Overview

This document provides instructions for deploying RadiantOne Identity Data Management on your Kubernetes cluster using Helm charts. It covers prerequisites, lists the microservices involved, and explains how to access the Identity Data Management control panel on your local machine via port-forwarding.

Self-managed Identity Data Management can be deployed on supported Kubernetes cluster (cloud or on-premise). Amazon Elastic Kubernetes Service (EKS), Azure Kubernetes Service (AKS), Google Kubernetes Engine (GKE) and RedHat OpenShift are currently supported. The installation process exclusively utilizes Helm, meaning you will use `helm install` or `helm upgrade` commands.

The table below shows the mapping between the Identity Data Management application version and the self-managed Helm chart version:

| Identity Data Management application version | Helm chart version |
| -------------------------------------------- | ----------                                                                             
| 8.1.0                                                                                    | 1.1.0                                |
| 8.1.1                                                                                    | 1.1.1                                |
| 8.1.2                                                                                    | 1.1.2                                |
| 8.1.3                                                                                    | 1.1.3                                |
| 8.1.4                                                                                    | 1.1.4                                |
| 8.1.5                                                                                    | 1.1.5                                |
| 8.2.0                                                                                    | 1.2.0                                |
| 8.2.1                                                                                    | 1.2.1                                |
| 8.2.2                                                                                    | 1.2.2                                |
| 8.3.0                                                                                    | 1.3.0                                |
| 8.3.1                                                                                    | 1.3.1                                |
| 8.3.2                                                                                    | 1.3.2                                |
| 8.4.0                                                                                    | 1.4.0                                |
| 8.4.1                                                                                    | 1.4.1                                |
| 8.4.2                                                                                    | 1.4.2                                |




Ensure that you specify your target version when running installation and update commands that are listed in this document.  

## Prerequisites

- [Kubernetes cluster](https://kubernetes.io/docs/setup/) of version 1.27 or higher. Refer to the [Sizing a Kubernetes cluster](./sizing-kubernetes/) document for additional details.
- Install [Helm](https://helm.sh/docs/intro/install/) version 3.8 or higher.
- Install [kubectl](https://kubernetes.io/docs/reference/kubectl/) version 1.27 or higher and configure it to access your Kubernetes cluster.
- For new customers, an Identity Data Management license key will be provided to you during onboarding. For existing customers that want to upgrade to v8.1 self-managed, your existing license key should work. If you have issues, create a Radiant Logic Customer Support ticket at https://support.radiantlogic.com/.
- For new customers, ensure that you have received Container Registry Access and image pull credentials named **(regcred.yaml)** from Radiant Logic during onboarding. For existing customers that want to upgrade to v8.1 self-managed, create a Radiant Logic Customer Support ticket at https://support.radiantlogic.com/ to request registry credentials.
- Ensure that you have necessary storage provisioners and storage classes configured for the Kubernetes cluster. Some examples of supported storage classes are `gp2`/`gp3`, [Azure disk](https://learn.microsoft.com/en-us/azure/aks/concepts-storage#persistent-volumes), etc.
- Estimate sufficient resources (CPU, memory, storage) for the deployment. <b> The default amount indicated in the helm chart MAY NOT BE SUFFICIENT FOR YOUR USE CASES. Update them accordingly. </b> Your Radiant Logic solutions engineer can guide you here based on your use cases.
- Enable Nested Virtualization if you are testing self-managed deployments using Docker Desktop. Nested virtualization allows a virtual machine (VM) to act as a host for other VMs, enabling scenarios like running Docker Desktop inside a VM.

## Steps for Deployment


1. **Set up values.yaml file for Helm deployment**

    Create a file named `values.yaml`. In your `values.yaml`, ensure that you have the following properties at minimum. Note that the values of the properties such as `storageClass`, `resources`, etc., will differ depending on your use case, cloud provider, and storage requirements. Work with your Radiant Logic Solution Engineer to customize your Helm configuration.

   **Example `values.yaml` file:**
   ```yaml
   replicaCount: 1 # Use 1 for testing, use 2 or more for production if needed. 
   image:
     tag: 8.4.2
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

- **replicaCount**: Specifies the number of RadiantOne nodes that will be deployed. Set the value to a minimum of **2** in production environments for high availability.
- **image.repository**: Specifies the Docker repository for the Identity Data Management image. Set to **radiantone/fid**.
- **image.tag**: Specifies the version of the Identity Data Management image to install or upgrade to.
- **fid.rootUser**: Denotes the root user for RadiantOne. Set to **cn=Directory Manager**.
- **fid.rootPassword**: Denotes the password for the root user. Set to a strong password value that meets your corporate security policy. You can update this password after install if needed.
- **fid.license**: Set your Identity Data Management license key.
- **persistence.enabled**: Indicates whether data persistence is enabled. Set to **true** or **false**.
- **persistence.storageClass**: Defines the storage class for provisioning persistent volumes.
- **persistence.size**: Specifies the size of the persistent volume for Identity Data Management. Ensure that you monitor usage over time and change the value as needed.
- **zookeeper.persistence.enabled**: Indicates if data persistence is enabled for Zookeeper.
- **resources**: Indicates the compute resources allocated to the Identity Data Management containers. Identity Data Management is deployed as a StatefulSet, which has implications for resource management. The values shown in the example above are for demonstration purposes. Changing resources requires careful planning as it affects all pods. Monitor your usage and change the values as needed over time.
- **env**: Under `env`, you can define environment variables used to configure Identity Data Management at runtime. The "INSTALL_SAMPLES" property controls whether sample data sets are deployed, allowing you to enable or disable example content as needed. The "FID_SERVER_JOPTS" property specifies JVM heap settings for the Identity Data Management server. The defaults included may be sufficient. However, validate your use cases in a development environment and adjust -Xmx accordingly. To avoid memory swapping and instability, ensure the -Xmx value does not exceed the container memory limit defined in `resource.limits`.

**Optional properties:** 

- **metrics**: Optional property. Use this to enable [metrics and logging](./metrics-and-logging/).
- **migration.url**: Optional property. Use this field only during the initial deployment of self-managed Identity Data Management to restore the configuration from a backup file of an existing deployment. Refer to the [Restore using a backup](./restore) guide to learn more.



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
   helm -n self-managed upgrade --install fid oci://registry-1.docker.io/radiantone/iddm-helm --version 1.4.2 --values </path/to/your/values.yaml> --set env.INSTALL_SAMPLES=true --debug --dry-run
   ```

   This command will process your YAML config files without deploying anything. If everything looks good, re-run the command without the `--dry-run` parameter. Setting `INSTALL_SAMPLES=true` is optional for testing purposes and not recommended for production deployment.


5. **Deploy self-managed Identity Data Management**

   Ensure that you provide the appropriate path for your values.yaml file before running this command:

   ```bash
   helm -n self-managed install fid oci://registry-1.docker.io/radiantone/iddm-helm --version 1.4.2 --values </path/to/your/values.yaml> --debug
   ```

6. **Verify deployment**

   ```bash
   kubectl get pod -n self-managed
   ```

   You should see the following pods listed in the output, confirming that the deployment was successful:
   - **api-gateway**: API Gateway (request routing) for the configuration REST API.
   - **authentication**: Microservice for the configuration REST API endpoints concerning authentication. It provides REST API authentication functionality such as login, JWT token validation, etc.
   - **data-catalog**: Microservice for the configuration REST API endpoints concerning data catalog (data sources, data source schema management)
   - **directory-browser**: Microservice for the configuration REST API endpoints concerning directory browser.
   - **directory-namespace**: Microservice for the configuration REST API endpoints concerning directory namespace.
   - **directory-schema**: Microservice for the configuration REST API endpoints concerning directory server schema.
   - **fid-X**: The core server/engine for Identity Data Management. Note that the number of deployed fid services is determined by the `replicaCount` property         in your values.yaml file. For example, if `replicaCount` is set to 1, you'll see only fid-0. If it's set to 2, you'll see both fid-0 and fid-1, and so on,        depending on the value of `replicaCount`.
   - **iddm-proxy**: Load balancer and reverse proxy service. 
   - **iddm-ui**: Front-end for the new v8.1 control panel.
   - **settings**: Microservice for the configuration REST API endpoints concerning a variety of Identity Data Management server settings (security, ACIs, etc.).
   - **system-administration**:  Microservice for the configuration REST API endpoints concerning Identity Data Management administration (users, roles,         permissions, etc.).
   - **zipkin**: Distributed tracing system used for troubleshooting.
   - **zookeeper-X**:  Distributed configuration service used by Identity Data Management backend. You may see Zookeeper-0, Zookeeper-1, Zookeeper-3 etc.



## Accessing RadiantOne Services 

### Accessing the Control Panel

To access the Identity Data Management control panel, first set up port forwarding for the `iddm-proxy-service` on port 8443:
```bash
kubectl port-forward svc/iddm-proxy-service -n self-managed 8443:443
```

After setting up port forwarding, you can reach the control panel at [https://localhost:8443/login](https://localhost:8443/login).

In a production environment, you may want to expose the iddm-proxy-service securely using a method appropriate for your infrastructure, such as an ingress controller or a Kubernetes LoadBalancer service (e.g., on AWS, GCP, or other cloud platforms).

> Ensure that all Identity Data Management URLs are accessed using HTTPS rather than HTTP for security purposes.

### Accessing the Classic Control Panel

If needed, access the classic control panel via [https://localhost:8443/classic](https://localhost:8443/classic) after port-forwarding the `iddm-proxy-service`.

### Accessing the Configuration API 

To access the Configuration API, open a new terminal and run the following command to port-forward:

> Ensure that port 8443 is not already in use on your local machine.

```bash
kubectl port-forward svc/fid-app -n self-managed 8443
```

- Access the Configuration API at [https://localhost:8443/api](https://localhost:8443/api).

### Accessing the Data Management SCIM and REST/ADAP APIs:

To access the Data Management [SCIM API](https://developer.radiantlogic.com/idm/v8.1/web-services-api-guide/scim/) and [REST/ADAP API](https://developer.radiantlogic.com/idm/v8.1/web-services-api-guide/rest/), open a new terminal and run the following command to port-forward:

> Ensure that ports 8089 and 8090 are not already in use on your local machine.

```bash
kubectl port-forward svc/fid-app -n self-managed 8089 8090
```

- Access the ADAP Rest API at [https://localhost:8089/adap](https://localhost:8089/adap).
- Access the ADAPs Rest API at [https://localhost:8090/adap](https://localhost:8090/adap).
- Access the SCIM API at [https://localhost:8090/scim2](https://localhost:8090/scim2).


### Accessing LDAP/LDAPs Service

To access the [LDAP/LDAPs](https://developer.radiantlogic.com/idm/v8.1/configuration/global-settings/client-protocols/#ldap) service, open a new terminal and run the following command to port-forward:

> Ensure that ports 2389 and 2636 are not already in use on your local machine.

```bash
kubectl port-forward svc/fid-app -n self-managed 2389 2636
```

- Access the LDAP service at: `ldap://localhost:2389` from your LDAP browser.
- Access the LDAPs service at: `ldaps://localhost:2636` from your LDAP browser.

### Restarting LDAP and REST services

To perform a rolling restart of the LDAP and REST endpoints on all Identity Data Management pods, run this command:

```bash
kubectl rollout restart statefulset/fid -n self-managed
```

Note that this will restart all `fid-<x>` pods, beginning with the pod that has the highest number. For example, in a 3-node cluster (fid-0, fid-1, fid-2), the restart order will be: fid-2 first, followed by fid-1, and finally fid-0. 

Optionally, to monitor the progress of the restart, run the following command: 
```bash
kubectl rollout status statefulset/fid -n self-managed
```

## Updating a Deployment

To update any resources or settings, change the values in `values.yaml` and run the following command:

```bash
   helm -n self-managed upgrade --install fid oci://registry-1.docker.io/radiantone/iddm-helm --version 1.4.2 --values </path/to/your/values.yaml> --debug
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







