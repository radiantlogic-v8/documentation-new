---
title: Self-managed Deployment
description: Learn how to install RadiantOne Identity Data Management 9.0.0 in your own Kubernetes cluster using Helm.
---

## Overview

This document provides instructions for installing RadiantOne Identity Data Management 9.0.0 on your Kubernetes cluster using Helm charts. It covers prerequisites, sizing and storage guidance, the deployment steps, and how to access the Identity Data Management control panel on your local machine via port-forwarding.

Self-managed Identity Data Management can be installed on any supported Kubernetes cluster that provides a storage class for ReadWriteOnce block storage. The installation process exclusively utilizes Helm, meaning you will use `helm install` or `helm upgrade` commands.

To update an existing v8 deployment to v9 instead, refer to [Updating RadiantOne Identity Data Management](../upgrade-guides/updating-to-sm-v9/).

### Chart version

In v9, the Helm chart version matches the product version. The chart is published as `iddm-helm` at `oci://registry-1.docker.io/radiantone/iddm-helm`.

Passing `--version 9.0.0` selects both the chart and the product version. The container image version is derived from this value, so there is no separate chart version to look up and no need to set `image.tag`.

This replaces the v8 mapping, in which an 8.X.Y application version corresponded to a 1.X.Y chart version. That mapping still applies when installing or patching a v8 deployment.

## Prerequisites

- [Kubernetes cluster](https://kubernetes.io/docs/setup/) of version 1.27 or higher. Refer to the [Sizing a Kubernetes cluster](../sizing-kubernetes/) document for additional details.
- Install [Helm](https://helm.sh/docs/intro/install/) version 3.8 or higher. Version 3.8 is required for OCI registries.
- Install [kubectl](https://kubernetes.io/docs/reference/kubectl/) version 1.27 or higher and configure it to access your Kubernetes cluster.
- For new customers, an Identity Data Management license key will be provided to you during onboarding. For existing customers, your existing license key should work with v9. If you have issues, create a Radiant Logic Customer Support ticket at https://support.radiantlogic.com/.
- For new customers, ensure that you have received Container Registry Access and image pull credentials named **(regcred.yaml)** from Radiant Logic during onboarding. For existing customers, create a Radiant Logic Customer Support ticket at https://support.radiantlogic.com/ to request registry credentials.
- Ensure that you have a storage class with dynamic provisioning configured for the Kubernetes cluster. Identity Data Management stores the complete installation on a persistent volume, not only its data. Refer to [Storage Classes by Platform](#storage-classes-by-platform).
- Estimate sufficient resources (CPU, memory, storage) for the deployment. <b> The default amount indicated in the helm chart MAY NOT BE SUFFICIENT FOR YOUR USE CASES. Update them accordingly. </b> Refer to [Sizing the Deployment](#sizing-the-deployment). Your Radiant Logic solutions engineer can guide you here based on your use cases.

## Sizing the Deployment

Size the deployment before you install it. The chart defaults are intentionally small. Choose a row from the table below, then set `resources`, the heap in `FID_SERVER_JOPTS`, and the volume size accordingly.

The following figures are starting points, not limits. Work with your Radiant Logic solutions engineer to confirm them against your own data before production.

| Deployment | CPU | Memory | FID_SERVER_JOPTS | Volume |
|---|---|---|---|---|
| Evaluation or development with sample data | 2 | 8Gi | `-Xms2g -Xmx4g` | 10Gi |
| Small production, under approximately 1 million entries | 4 | 16Gi | `-Xms4g -Xmx8g` | 50Gi |
| Medium, 1 to 10 million entries | 8 | 32Gi | `-Xms8g -Xmx16g` | 100Gi |
| Large, more than 10 million entries or many stores with large groups | 8–16 | 64Gi | `-Xms16g -Xmx32g` | 250Gi and higher |

> **Keep the heap below the container limit.** The server is not the only JVM in the pod. The control panel, task scheduler, and sync agent each have their own heap, and all use the same container memory limit.

Set `FID_SERVER_JOPTS` to approximately half of the memory limit. This leaves memory for the other processes and for the operating-system page cache, which directory stores use heavily for read performance. A heap set close to the container limit is the most common cause of pods that restart repeatedly under load.

For production, set resource requests equal to limits. Equal values give the pod a guaranteed quality of service and prevent it from being the first pod evicted when a node is under pressure.

## Storage Classes by Platform

The chart requires a storage class that provisions ReadWriteOnce block storage. Storage class names are site-specific because they are created by the cluster administrator. The names below are common examples, not guarantees.

List the storage classes available in your cluster:

```
kubectl get storageclass
```

| Platform | Used in Radiant Logic compatibility testing | Commonly used in production |
|---|---|---|
| Amazon EKS | `gp2` | `gp3`, usually created by the cluster administrator and preferred over `gp2` for throughput |
| Azure AKS | `default` | `managed-csi` for standard SSD, or `managed-csi-premium` for premium SSD |
| Google GKE | `standard` | `standard-rwo` for balanced persistent disk, or `premium-rwo` for SSD |
| Oracle OKE | `oci-bv` | `oci-bv` |
| Red Hat OpenShift | `csi-hostpath-provisioner` for test clusters only | Depends on the underlying platform: `gp3-csi` on AWS, `thin-csi` on vSphere, or `ocs-storagecluster-ceph-rbd` with OpenShift Data Foundation |
| Rancher and RKE2 | — | `longhorn`, or `local-path` for non-production. RKE2 includes no default storage class, so one must be installed and named explicitly. |

For the storage class you select, check the following properties:

- `allowVolumeExpansion: true`, if you want to grow the volume later without rebuilding it. Most managed classes have this setting, but some do not.
- `volumeBindingMode: WaitForFirstConsumer` on multi-zone clusters, so the volume is created in the same zone as the pod that uses it.

```
kubectl get storageclass <name> \
  -o jsonpath='{.allowVolumeExpansion}{"  "}{.volumeBindingMode}{"\n"}'
```

> Ensure that `persistence.storageClass` names a class that exists on the cluster. If the specified class does not exist, the persistent volume claims remain `Pending` and the pods do not start.

## Steps for Deployment

1. **Set up values.yaml file for Helm deployment**

   Create a file named `values.yaml`. In your `values.yaml`, ensure that you have the following properties at minimum. Note that the values of the properties such as `storageClass`, `resources`, etc., will differ depending on your use case, cloud provider, and storage requirements. Replace the resource, heap, and volume values below with the row you selected in [Sizing the Deployment](#sizing-the-deployment). Work with your Radiant Logic Solution Engineer to customize your Helm configuration.

   **Example `values.yaml` file:**

   ```
   replicaCount: 1                 # 1 for testing; 2 or more for production

   fid:
     license: >-
       YourLicense
     rootPassword: "Enteryourrootpw"

   imagePullSecrets:
     - name: regcred

   persistence:
     enabled: true
     storageClass: "gp3"
     size: 10Gi

   zookeeper:
     persistence:
       enabled: true
       storageClass: "gp3"

   resources:
     requests:
       cpu: 4
       memory: 8Gi
     limits:
       cpu: 4
       memory: 8Gi

   env:
     INSTALL_SAMPLES: "false"
     FID_SERVER_JOPTS: "-Xms2g -Xmx4g"
   ```

   A complete reference file containing every tunable setting discussed in this document is provided in [Complete values.yaml Reference](#complete-valuesyaml-reference).

   If you are restoring this deployment from a backup of an existing deployment, refer to [Restoring from a Backup](#restoring-from-a-backup) before you continue. That procedure requires two additional properties in `values.yaml`.

   **Definitions of the properties:**

   - **replicaCount**: Specifies the number of RadiantOne nodes that will be deployed. Set the value to a minimum of **2** in production environments for high availability.
   - **image.tag**: Optional. Leave this unset. The image version comes from `--version`. Set this only if Radiant Logic Support instructs you to use a specific image. A pinned tag is not updated by a later `--version` value and can leave the server on an older version while the other services update.
   - **fid.rootUser**: Denotes the root user for RadiantOne. Defaults to **cn=Directory Manager**.
   - **fid.rootPassword**: Denotes the password for the root user. Set to a strong password value that meets your corporate security policy. You can update this password after install if needed.
   - **fid.license**: Set your Identity Data Management license key.
   - **persistence.enabled**: Indicates whether data persistence is enabled. Set to **true** or **false**.
   - **persistence.storageClass**: Defines the storage class for provisioning persistent volumes.
   - **persistence.size**: Specifies the size of the persistent volume. The volume stores the complete installation, not only the data. Ensure that you monitor usage over time and expand the volume before it fills.
   - **zookeeper.persistence.enabled**: Indicates if data persistence is enabled for Zookeeper.
   - **resources**: Indicates the compute resources allocated to the Identity Data Management containers. Identity Data Management is deployed as a StatefulSet, which has implications for resource management. Changing resources requires careful planning as it affects all pods. Monitor your usage and change the values as needed over time.
   - **env**: Under `env`, you can define environment variables used to configure Identity Data Management at runtime. Values that you set are merged with the chart defaults. The "INSTALL_SAMPLES" property controls whether sample data sets are deployed. The "FID_SERVER_JOPTS" property specifies JVM heap settings for the Identity Data Management server. Keep `-Xmx` at no more than about half of `resources.limits.memory`, because the storage engine also uses memory outside the Java heap. A heap equal to the container limit can cause the container to be stopped for exceeding its memory limit.

   **About JAVA_TOOL_OPTIONS:**

   The chart sets `JAVA_TOOL_OPTIONS="-Djdk.lang.Process.launchMechanism=FORK"` by default and adds it automatically when your values do not define it, so you do not need to include it.

   If you set `env.JAVA_TOOL_OPTIONS` yourself, ensure that you keep `-Djdk.lang.Process.launchMechanism=FORK` in the value. Without it, the server can fail when it starts helper processes, including the export and import steps of an update.

   > Always pass your values file with `--values`. Do not use `helm upgrade --reuse-values` with this chart.

   **Optional properties:**

   - **logging**: Optional property. Use this to enable the log-shipping sidecar and its destinations. Refer to the [Logging](../metrics-and-logging/) guide.
   - **fid.migration.url**: Optional property. Use this field only during the initial deployment to restore the configuration from a backup file of an existing deployment. Refer to [Restoring from a Backup](#restoring-from-a-backup) to learn more. A v9 deployment can be seeded from any 8.x backup, and directly from 7.3 or 7.4 backups.

   > The migration property must be **fid.migration.url**. A value placed at `migration.url` is ignored without an error, and the deployment starts empty.

2. **Create a namespace for your IDDM cluster**

   ```
   kubectl create namespace self-managed
   ```

3. **Deploy the credentials file provided to you in the same namespace**

   ```
   kubectl apply -n self-managed -f regcred.yaml
   ```

4. **Optional - dry run your deployment**

   ```
   helm -n self-managed upgrade --install fid \
     oci://registry-1.docker.io/radiantone/iddm-helm \
     --version 9.0.0 \
     --values </path/to/your/values.yaml> \
     --dry-run
   ```

   This command will render your YAML config files without deploying anything, and reports template or value errors. If everything looks good, re-run the command without the `--dry-run` parameter.

5. **Deploy self-managed Identity Data Management**

   Ensure that you provide the appropriate path for your values.yaml file before running this command:

   ```
   helm -n self-managed install fid \
     oci://registry-1.docker.io/radiantone/iddm-helm \
     --version 9.0.0 \
     --values </path/to/your/values.yaml> \
     --wait
   ```

   Helm prints `STATUS: deployed` and displays notes containing the port-forward command and the commands for retrieving the root credentials.

   With `--wait`, Helm returns when the pods report ready. On a cluster that must add nodes first, allow approximately five minutes. Without `--wait`, Helm returns after applying the manifests, while the pods continue starting in the background.

   Helm's `--timeout` value (default `5m0s`) limits how long Helm waits for an individual operation. It does not stop work in the cluster: when it expires, Helm returns an error, but work that has already started continues. A timed-out installation is not a cancelled installation. For automation, use `--wait` together with a `--timeout` value that comfortably exceeds your expected startup time.

   > Do not use `--atomic` when restoring from a backup. If the timeout expires, `--atomic` rolls back the release, which deletes a deployment that is partway through a restore.

6. **Verify deployment**

   ```
   kubectl get pod -n self-managed
   ```

   You should see the following pods listed in the output, all **Running** and ready, confirming that the deployment was successful:

   - **api-gateway**: API Gateway (request routing) for the configuration REST API.
   - **authentication**: Microservice for the configuration REST API endpoints concerning authentication.
   - **data-catalog**: Microservice for the configuration REST API endpoints concerning the data catalog.
   - **directory-browser**: Microservice for the configuration REST API endpoints concerning the directory browser.
   - **directory-namespace**: Microservice for the configuration REST API endpoints concerning the directory namespace.
   - **fid-X**: The core server/engine for Identity Data Management. Note that the number of deployed fid services is determined by the `replicaCount` property in your values.yaml file. For example, if `replicaCount` is set to 1, you'll see only fid-0. If it's set to 2, you'll see both fid-0 and fid-1, and so on.
   - **iddm-proxy**: Load balancer and reverse proxy service.
   - **iddm-ui**: Front-end for the control panel.
   - **settings**: Microservice for the configuration REST API endpoints concerning a variety of Identity Data Management server settings (security, ACIs, etc.).
   - **sync**: Synchronization service. New in v9; replaces directory-schema.
   - **system-administration**: Microservice for the configuration REST API endpoints concerning Identity Data Management administration (users, roles, permissions, etc.).
   - **zookeeper-X**: Distributed configuration service used by the Identity Data Management backend. You may see zookeeper-0, zookeeper-1, zookeeper-2, etc.

   You will also see four or five Jobs named `fid-hdap-…` with a **Completed** status, and their pods in **Completed** state. These Jobs belong to the v8-to-v9 update procedure. On a fresh install they run, find no update work, and finish immediately. This is expected.

   The following pods appear only when the corresponding feature is enabled:

   - **fid-follower-X** when `fid.followerOnly.enabled` is enabled.
   - **zipkin** when `zipkin.enabled` is enabled. This feature is disabled by default.
   - The logging and metrics services when their corresponding features are enabled.

   > **Renamed component.** In v9, the `sync` pod replaces the `directory-schema` pod. Update any monitoring, alerting, or readiness checks that look for `directory-schema`, or they will report a false failure. The related Helm values section is now `globalSync` instead of `directorySchema`. Move any settings under `directorySchema`, such as replicas, resources, or pod labels, to `globalSync`. The chart ignores settings that remain under `directorySchema` without any warning.

## Restoring from a Backup

The Identity Data Management Helm chart includes a restore feature that enables you to import existing configurations and data from a backup file into a new installation of the Identity Data Management application.

This functionality is particularly beneficial for setting up a new Identity Data Management instance with pre-existing configurations, or for migrating data from a previous installation to a new installation. A v9 deployment can be seeded from any 8.x backup, and directly from 7.3 or 7.4 backups.

> Note that you cannot use this feature for updates or patches. Refer to [Updating RadiantOne Identity Data Management](../upgrade-guides/updating-to-sm-v9/) instead.

To create the backup file that this procedure uses, refer to [Creating backups](../creating-backups/).

Follow the steps outlined below to restore your self-managed Identity Data Management application.

### 1. Configure your values.yaml file

To configure the restore feature, include the `migration` object in your `values.yaml` file prior to installation of the application, as shown below:

```
fid:

  migration:
    # Migration file URL to be imported during the first installation (e.g., export.zip)
    url: <URL_TO_YOUR_BACKUP_FILE>

  startupProbe:
    periodSeconds: 20
    failureThreshold: 540
```

In the `url` property, enter a URL pointing to the backup export file (export.zip). Ensure the URL directs to an HTTP server accessible from the Kubernetes cluster without requiring authentication.

In the `startupProbe` property, increase `failureThreshold` so that Kubernetes allows enough time for the backup to load. Refer to step 2 to choose a value.

> Ensure that both properties are placed under `fid`. Values placed at the top level are ignored without any warning, and the deployment then starts either empty or with the default five-minute startup allowance.

### 2. Size the startup allowance

When `fid.migration.url` is set, the backup is downloaded and loaded during the first startup of the server pod, before the server starts responding. During this process, Kubernetes checks the pod using a startup probe. The default startup allowance is five minutes, which is not sufficient for a backup of any significant size.

The startup allowance is `periodSeconds` multiplied by `failureThreshold`. The defaults are 20 × 15 = 300 seconds, or 5 minutes. Increase `failureThreshold` and leave `periodSeconds` at 20. Only the startup probe requires adjustment: while it runs, the liveness and readiness probes do not run and cannot interrupt the restore.

Backup loading time depends on the uncompressed backup size, the number of entries, and group membership. When backlink optimization is enabled, calculating `ismemberof` can take longer than loading the entries.

| Backup, uncompressed | Approximate entries | Load time | failureThreshold (with periodSeconds: 20) |
|---|---|---|---|
| Under 100 MB | Tens of thousands | Approximately 1 minute, measured | 15; the default is sufficient |
| 1–2 GB | Around 1 million | 15–30 minutes, estimated | 120, or 40 minutes |
| Around 10 GB | Several million, with large groups and backlink optimization enabled | Approximately 2 hours, reported from an equivalent initialization | 540, or 3 hours |

As a general guideline, allow at least one minute per gigabyte of uncompressed backup, then add time for group calculation and round up generously. If you have initialized the same data set before, use the observed duration as the best estimate. An allowance that is too large only delays restarting a genuinely unhealthy server during this first boot.

Ensure that you also size the persistent volume for the restored data, not for the backup file. The stores on disk are significantly larger than the compressed archive.

### 3. Run the installation command

Once you have made the necessary changes to your `values.yaml` file, run the install command to deploy the chart:

```
helm -n self-managed install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml>
```

After installation, you can confirm that the migration URL was correctly set by checking the pod's environment variables or init container configuration:

```
kubectl describe pod fid-0 -n self-managed
```

During the installation of the Identity Data Management application, the Helm chart will use the provided URL to download the migration export file. This file will be used to perform a migration import during the installation process.

> Do not use `--atomic` when restoring from a backup. If the timeout expires, `--atomic` rolls back the release, which deletes a deployment that is partway through a restore.

### 4. Verify that the backup was loaded

A failed download, such as one caused by an expired link, is not detected. Before the server starts, the backup file is downloaded to `/migrations/export.zip` in the pod. After the pod is running, verify the file:

```
kubectl exec -n self-managed fid-0 -- \
  unzip -l /migrations/export.zip | tail -3
```

To confirm whether real stores were loaded, check the data directory. Stores that are only a few tens of kilobytes indicate that no data was loaded:

```
kubectl -n self-managed exec fid-0 -c fid -- \
  du -sh /opt/radiantone/vds/vds_server/data/*
```

> If the startup allowance is too short, the deployment can appear healthy but contain no data. Kubernetes stops the container while it is loading the backup, and on the next startup the software is already installed, so the restore is not attempted again and the server starts with empty stores. Restarting does not recover the restore. To recover, delete the deployment and its volumes, then install again with a larger startup allowance. Refer to [Removing a Deployment](#removing-a-deployment).

### 5. Restore the default startup allowance

The startup allowance applies to every subsequent pod restart, not only to the restore. For example, if you configure a three-hour allowance for the restore, Kubernetes can wait up to three hours before restarting a pod that is unable to start successfully.

After you verify that the deployment is running correctly, remove the startupProbe override and run the update command. This restores the default five-minute startup allowance.

### Implementation details

**Init container:** An init container named `migration` is included in the FID pod when a migration URL is provided. The init container employs curl to download the export file from the specified URL, saving it to `/migrations/export.zip` within the container.

**Volume mounting:** A volume named `migrations` is created and mounted to both the init container and the main FID container. This setup allows the downloaded migration file to be accessible to the Identity Data Management application during startup.

**Conditional execution:** The init container and its associated logic will only execute if a migration URL is specified in the values.yaml file.

### Limitations and considerations

- This feature is intended solely for new installations of the Identity Data Management application. Using it during an update will not trigger a new migration.
- The migration property must be **fid.migration.url**. A value placed at `migration.url` is ignored without an error, and the deployment starts empty.
- Ensure that the migration URL provided is accessible from the Kubernetes cluster where Identity Data Management is being installed. This should point to an HTTP server that doesn't have any authentication wall.
- Ensure that your migration file is a valid export file in ZIP format. A failed download is not detected, and the deployment starts empty.
- Ensure sensitive data in the migration file is adequately secured, and the URL is accessed over a secure connection (HTTPS) when necessary.
- Persistent caches must be re-initialized after the restore.

## Accessing RadiantOne Services

### Accessing the Control Panel

To access the Identity Data Management control panel, first set up port forwarding for the `iddm-proxy-service` on port 8443:

```
kubectl port-forward svc/iddm-proxy-service -n self-managed 8443:443
```

After setting up port forwarding, you can reach the control panel at [https://localhost:8443/login](https://localhost:8443/login). Your browser displays a warning for the self-signed certificate. This is expected when you use port-forwarding.

In a production environment, you may want to expose the iddm-proxy-service securely using a method appropriate for your infrastructure, such as an ingress controller or a Kubernetes LoadBalancer service (e.g., on AWS, GCP, or other cloud platforms).

> Ensure that all Identity Data Management URLs are accessed using HTTPS rather than HTTP for security purposes.

To retrieve the root credentials:

```
kubectl get secret rootcreds-fid -n self-managed \
  -o jsonpath="{.data.fid-root-username}" | base64 -d; echo
kubectl get secret rootcreds-fid -n self-managed \
  -o jsonpath="{.data.fid-root-password}" | base64 -d; echo
```

### Accessing the Configuration API

To access the Configuration API, open a new terminal and run the following command to port-forward:

> Ensure that port 8443 is not already in use on your local machine. If you are already port-forwarding the control panel on 8443, stop that forward first or map the Configuration API to a different local port.

```
kubectl port-forward svc/fid-app -n self-managed 8443
```

- Access the Configuration API at [https://localhost:8443/api](https://localhost:8443/api).

### Accessing the Data Management SCIM and REST/ADAP APIs

To access the Data Management [SCIM API](https://developer.radiantlogic.com/idm/v8.1/web-services-api-guide/scim/) and [REST/ADAP API](https://developer.radiantlogic.com/idm/v8.1/web-services-api-guide/rest/), open a new terminal and run the following command to port-forward:

> Ensure that ports 8089 and 8090 are not already in use on your local machine.

```
kubectl port-forward svc/fid-app -n self-managed 8089 8090
```

- Access the ADAP REST API at [https://localhost:8089/adap](https://localhost:8089/adap).
- Access the ADAPS REST API at [https://localhost:8090/adap](https://localhost:8090/adap).
- Access the SCIM API at [https://localhost:8090/scim2](https://localhost:8090/scim2).

### Accessing LDAP/LDAPs Service

To access the [LDAP/LDAPs](https://developer.radiantlogic.com/idm/v8.1/configuration/global-settings/client-protocols/#ldap) service, open a new terminal and run the following command to port-forward:

> Ensure that ports 2389 and 2636 are not already in use on your local machine.

```
kubectl port-forward svc/fid-app -n self-managed 2389 2636
```

- Access the LDAP service at: `ldap://localhost:2389` from your LDAP browser.
- Access the LDAPs service at: `ldaps://localhost:2636` from your LDAP browser.

### Restarting LDAP and REST services

To perform a rolling restart of the LDAP and REST endpoints on all Identity Data Management pods, run this command:

```
kubectl rollout restart statefulset/fid -n self-managed
```

Note that this will restart all `fid-<x>` pods, beginning with the pod that has the highest number. For example, in a 3-node cluster (fid-0, fid-1, fid-2), the restart order will be: fid-2 first, followed by fid-1, and finally fid-0.

Optionally, to monitor the progress of the restart, run the following command:

```
kubectl rollout status statefulset/fid -n self-managed
```

## Troubleshooting your Installation

The steps listed here are meant to help you identify and troubleshoot issues related to pod deployments in your Kubernetes environment.

### fid-0 or zookeeper-N remains Pending

No node can satisfy the pod's resource requirements, node selector, or storage class.

```
kubectl describe pod fid-0 -n self-managed | tail -20
kubectl get pvc -n self-managed
```

A PVC that remains `Pending` with a provisioning error indicates that the storage class specified in your values file does not exist on the cluster.

### A pod shows ImagePullBackOff

Registry credentials are missing or are in the wrong namespace.

```
kubectl get secret regcred -n self-managed
kubectl describe pod <pod> -n self-managed | grep -A3 Events
```

### Microservices remain in Init: for several minutes

The services wait for ZooKeeper and then for fid-0 to become ready. This is normal during initial startup.

```
kubectl get pods -n self-managed -w
```

If fid-0 is not ready, check its log.

### fid-0 restarts repeatedly

This is usually a memory issue: `-Xmx` is too close to the container limit, or the limit is too small.

```
kubectl get pod fid-0 -n self-managed -o jsonpath='{.status.containerStatuses[0].lastState}'
kubectl logs fid-0 -n self-managed -c fid --previous | tail -50
```

### Control panel login fails with "Invalid username or password"

The password in the values file was mistyped, or contains characters that were changed by the shell when it was entered.

Retrieve the stored password using the secret command in [Accessing the Control Panel](#accessing-the-control-panel), then use that value.

### Restoring from a backup creates an empty deployment

The `fid.migration.url` download failed silently, or the property was set as `migration.url`.

```
kubectl exec -n self-managed fid-0 -- unzip -l /migrations/export.zip | tail -3
```

Refer to [Restoring from a Backup](#restoring-from-a-backup).

## Removing a Deployment

1. **Uninstall the Identity Data Management deployment**

   `helm uninstall` removes the workloads but, by design, keeps the persistent volume claims and their data.

   ```
   helm -n self-managed uninstall fid
   ```

2. **View the persistent volume claims**

   ```
   kubectl get pvc -n self-managed
   ```

3. **Delete the PVCs**

   Delete all existing PVCs from your namespace only if you want a clean deployment.

   > Deleting the persistent volume claims permanently deletes your Identity Data Management configuration and data. Ensure that you have a backup if you intend to restore this deployment later.

   ```
   kubectl delete pvc -n self-managed --all
   ```

## Complete values.yaml Reference

The following file includes all tunable settings discussed in this document. Copy it, replace the placeholders, and adjust the marked values using the [sizing](#sizing-the-deployment) and [storage](#storage-classes-by-platform) tables.

Two sections of this file apply only when you bring existing data into the deployment. An ordinary new installation does not use either one, and you can leave both unchanged:

- **fid.migration** — Applies only when you seed the initial deployment from a backup. This section is commented out by default. Refer to [Restoring from a Backup](#restoring-from-a-backup).
- **hdapMigration** — Applies only when you update an existing version 8 deployment to version 9. On a new installation, the migration jobs run, find no data to convert, and complete immediately. Refer to [Updating RadiantOne Identity Data Management](../upgrade-guides/updating-to-sm-v9/).

```
# This file contains the configurable settings described in this document.
# Replace the placeholder values, then adjust the marked values for your
# deployment.

# Number of RadiantOne nodes to deploy. Use 2 or more in production for high
# availability.
replicaCount: 2

fid:
  license: >-
    <YourLicense>
  rootPassword: "<EnterYourRootPw>"

  # --- Shutdown -----------------------------------------------------------
  # Maximum time Kubernetes allows each node to shut down gracefully.
  # Nodes close their data stores during shutdown and are stopped one at a
  # time. Scaling down can take approximately:
  # replicaCount × terminationGracePeriodSeconds.
  #
  # Set this value to 0 only if you want Kubernetes to use Kubernetes'
  # default termination grace period of 30 seconds.
  terminationGracePeriodSeconds: 180

  # --- Startup allowance --------------------------------------------------
  # The startup time limit is calculated as:
  # periodSeconds × failureThreshold.
  #
  # The default values allow 5 minutes for a normal startup (20 × 15).
  # Before restoring from a backup, increase failureThreshold to allow enough
  # time for the data to load. Return it to its normal value after the
  # restore, because this time limit also applies to subsequent pod restarts.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 15             # 15 = 5 minutes; 540 = 3 hours for a restore

  # --- Restore from backup: MIGRATION ONLY --------------------------------
  # This section applies only when you seed the initial deployment from a
  # backup of an existing deployment. A new installation does not use it.
  #
  # To restore from a backup, uncomment this section. You must also increase
  # startupProbe.failureThreshold before starting the restore. Leave this
  # section commented out when updating an existing deployment.
  # migration:
  #   url: "https://<host>/<path>/export.zip"

imagePullSecrets:
  - name: regcred

# --- Compute resources ----------------------------------------------------
# Select CPU and memory values that match the applicable sizing guidance.
# In production, set requests and limits to the same values. This reduces the
# likelihood that Kubernetes evicts the pod when the node is under pressure.
resources:
  requests:
    cpu: 4
    memory: 16Gi
  limits:
    cpu: 4
    memory: 16Gi

env:
  INSTALL_SAMPLES: "false"

  # Allocate approximately half of the container memory limit to the main JVM
  # heap. The Control Panel, task scheduler, and Sync Agent run in separate
  # JVMs and share the same container memory limit. Directory stores also use
  # operating-system page cache to improve read performance.
  FID_SERVER_JOPTS: "-Xms4g -Xmx8g"

# --- Storage --------------------------------------------------------------
# Specify a storage class that exists in the Kubernetes cluster. To list
# available storage classes, run:
# kubectl get storageclass
#
# The deployment requires ReadWriteOnce block storage.
persistence:
  enabled: true
  storageClass: "gp3"
  size: 100Gi

zookeeper:
  persistence:
    enabled: true
    storageClass: "gp3"

# --- Update from version 8: MIGRATION ONLY --------------------------------
# Every setting in this section applies only when you update a version 8
# deployment to version 9. A new installation does not use any of them: the
# migration jobs run, find no data to convert, and complete immediately.
#
# You can leave this block in the values file for a new installation. Set
# these values before you update to version 9.
#
# The jobs stop the nodes, export every data store, and rebuild the data in
# the new format. Each timeout is a maximum duration; the step completes as
# soon as it finishes.
hdapMigration:
  # This value must be greater than:
  # replicaCount × terminationGracePeriodSeconds
  #
  # Nodes stop one at a time, and each node can use its full termination
  # grace period. For example, with two replicas and a 180-second grace
  # period, this value must be greater than 360 seconds. The default value of
  # 300 seconds is not sufficient for that configuration.
  scaleDownTimeout: 900

  # Maximum time allowed to export the data stores.
  # Allow approximately 1 minute per 1 million entries in the largest
  # individual store.
  exportTimeout: 3600

  import:
    # Maximum time allowed to rebuild the data stores.
    #
    # This is usually the longest migration step. Allow approximately
    # 1 minute per 1 million entries when data is stored in a few stores, or
    # approximately 6 minutes per 1 million entries when data is distributed
    # across many stores. For example, 14400 seconds equals 4 hours.
    maxTimeout: 14400

    # Maximum resources available to the rebuild worker.
    # The worker determines its runtime requirements from the data it finds.
    # Increase these values if the deployment contains very large data stores.
    maxMemory: 16Gi
    maxCpu: 8

  # Maximum time to wait for nodes to restart and become ready after the
  # migration. After the first node starts, each additional node replicates
  # the data stores before reporting readiness. Increase this value as data
  # volume or replica count increases.
  postUpgradeWaitTimeout: 1800
```

To confirm that the cluster received the values you intended:

```
kubectl -n self-managed get statefulset fid \
  -o jsonpath='grace={.spec.template.spec.terminationGracePeriodSeconds}{"\n"}probe={.spec.template.spec.containers[0].startupProbe.periodSeconds}x{.spec.template.spec.containers[0].startupProbe.failureThreshold}{"\n"}resources={.spec.template.spec.containers[0].resources}{"\n"}'
```

Multiply the two startup-probe values to calculate the startup allowance in seconds.
