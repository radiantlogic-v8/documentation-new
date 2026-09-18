---
title: Self-managed Deployment
description: Learn how to deploy RadiantOne Identity Data Management in your own Kubernetes cluster using Helm.
---

# Overview

This guide explains how to install RadiantOne Identity Data Management 9.0.0 on a supported Kubernetes cluster.

To update an existing v8 deployment, see [Updating RadiantOne Identity Data Management](../upgrade-guides/updating-to-sm-v9.md).

Before you begin, ensure that you have:

- A Kubernetes cluster with a storage class that provisions `ReadWriteOnce` block storage.
- Registry credentials for Radiant Logic images.
- An Identity Data Management license.

Size the deployment before installing it. The chart defaults are intentionally small. Choose a row from [Sizing by deployment type](#sizing-by-deployment-type), then set `resources`, the heap in `FID_SERVER_JOPTS`, and the volume size accordingly. Keep the heap close to half of the memory limit because the pod runs several JVMs that share the same memory limit.

The storage class name is site-specific. Common examples include `gp3` on many EKS clusters, `managed-csi` on AKS, `standard-rwo` on GKE, and `oci-bv` on OKE. RKE2 does not include a storage class by default. Run the following command and use a storage class that exists in your cluster. If the specified class does not exist, the volume claims remain `Pending` and the pods do not start.

```bash
kubectl get storageclass
```

After you create `values.yaml`, deploy with one command:

```bash
helm -n self-managed upgrade --install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml> \
  --wait
```

A complete `values.yaml` file is included at the end of this page. Copy it, replace the placeholders, and adjust the values using the sizing and storage guidance in this guide.

If you seed the deployment from a backup, make one additional change. When `fid.migration.url` is set, the backup is loaded during the first startup of the server pod. The default five-minute startup allowance is not sufficient for a backup of any significant size. Increase `fid.startupProbe.failureThreshold` to allow enough time for the backup to load, then remove the override after the deployment is verified.

If the startup allowance is too short, the deployment can appear healthy but contain no data. Restarting does not restore the data.

Both properties must be placed under `fid`. Values placed at the top level are ignored without an error.

Allow approximately five minutes for pods to become ready if the cluster must add nodes first. Loading a backup can take longer.

After installation, verify that pods are ready, port-forward the Control Panel, and sign in with the credentials printed in the installation notes. See [Verifying the deployment](#verifying-the-deployment).

## Chart version

In v9, the Helm chart version matches the product version. The chart is published as `iddm-helm` at:

```text
oci://registry-1.docker.io/radiantone/iddm-helm
```

Passing `--version 9.0.0` selects both the chart and product version. The container image version is derived from this value, so there is no separate chart version to look up and no need to set `image.tag`.

This replaces the v8 mapping, where an `8.X.Y` application version corresponded to a `1.X.Y` chart version. That mapping still applies when installing or patching a v8 deployment.

## Prerequisites

Before installing, ensure that you have:

- A Kubernetes cluster running version 1.27 or later. See *Sizing a Kubernetes cluster* for guidance.
- Helm 3.8 or later, which is required for OCI registries.
- `kubectl` 1.27 or later, configured to access the cluster.
- An Identity Data Management license key.
  - New customers receive a license key during onboarding.
  - Existing license keys should work with v9.
  - If you encounter license issues, open a support ticket at [Radiant Logic Support](https://support.radiantlogic.com/).
- Container registry access and image pull credentials in a `regcred.yaml` file from Radiant Logic.
  - Existing customers can request registry credentials through a support ticket.
- A storage class with dynamic provisioning, such as AWS `gp3` or Azure Disk.
  - Identity Data Management stores the complete installation on a persistent volume, not only its data.
- Sufficient CPU, memory, and storage.
  - The Helm chart defaults may not be sufficient for your use case.
  - Your Radiant Logic solutions engineer can help determine suitable values.

## Set up values.yaml

Create a file named `values.yaml`. At minimum, include the following properties.

Storage-class and resource values vary by cloud provider and use case. Work with your Radiant Logic solutions engineer to customize them.

```yaml
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

### Property definitions

| Property | Description |
|---|---|
| `replicaCount` | Number of RadiantOne nodes. Use at least `2` in production for high availability. |
| `image.tag` | Optional. Leave this unset. The image version comes from `--version`. Set this only if Radiant Logic Support instructs you to use a specific image. A pinned tag is not updated by a later `--version` value and can leave the server on an older version while other services update. |
| `fid.rootUser` | The RadiantOne root user. Defaults to `cn=Directory Manager`. |
| `fid.rootPassword` | Password for the root user. Use a strong password that meets your security policy. You can change it after installation. |
| `fid.license` | Your Identity Data Management license key. |
| `persistence.enabled`, `persistence.storageClass`, `persistence.size` | Persistent storage for the RadiantOne installation and data. The volume stores the complete installation. Monitor usage over time and expand the volume before it fills. |
| `zookeeper.persistence.enabled` | Enables persistent storage for ZooKeeper. |
| `resources` | Compute resources for RadiantOne containers. Identity Data Management runs as a StatefulSet, so a change affects every node and requires planning. |
| `env` | Runtime environment variables. Values that you set are merged with chart defaults. `INSTALL_SAMPLES` controls sample data. `FID_SERVER_JOPTS` sets the JVM heap. Keep `-Xmx` at no more than about half of `resources.limits.memory`, because the storage engine also uses memory outside the Java heap. A heap equal to the container limit can cause the container to stop for exceeding its memory limit. |

### About JAVA_TOOL_OPTIONS

The chart sets the following value by default:

```text
JAVA_TOOL_OPTIONS="-Djdk.lang.Process.launchMechanism=FORK"
```

If your values do not define `JAVA_TOOL_OPTIONS`, the chart adds this setting automatically. You do not need to include it.

If you set `env.JAVA_TOOL_OPTIONS`, keep `-Djdk.lang.Process.launchMechanism=FORK` in the value. Without it, the server can fail when it starts helper processes, including the export and import steps of an update.

Always pass your values file with `--values`. Do not use `helm upgrade --reuse-values` with this chart.

### Optional properties

| Property | Description |
|---|---|
| `logging` | Enables the log-shipping sidecar and its destinations. See the *Logging* guide. |
| `fid.migration.url` | Use only for an initial deployment to restore configuration from a backup of an existing deployment. See *Restore using a backup*. |

The migration property must be `fid.migration.url`. A value placed at `migration.url` is ignored, and the deployment starts empty.

A v9 deployment can be seeded from any 8.x backup and directly from 7.3 or 7.4 backups.

Before the server starts, the backup file is downloaded to the following path in the pod:

```text
/migrations/export.zip
```

A failed download, such as one caused by an expired link, is not detected. The deployment also starts empty in that case. After the pod is running, verify the backup file:

```bash
kubectl exec -n self-managed fid-0 -- \
  unzip -l /migrations/export.zip | tail -3
```

The complete values file at the end of this page includes the settings described in this guide. Use the following sizing and storage tables to select the appropriate values.

## Sizing by deployment type

The following figures are starting points, not limits. Work with your Radiant Logic solutions engineer to confirm them against your own data before production.

| Deployment | CPU | Memory | `FID_SERVER_JOPTS` | Volume |
|---|---:|---:|---|---:|
| Evaluation or development with sample data | 2 | 8Gi | `-Xms2g -Xmx4g` | 10Gi |
| Small production, under approximately 1 million entries | 4 | 16Gi | `-Xms4g -Xmx8g` | 50Gi |
| Medium, 1 to 10 million entries | 8 | 32Gi | `-Xms8g -Xmx16g` | 100Gi |
| Large, more than 10 million entries or many stores with large groups | 8–16 | 64Gi | `-Xms16g -Xmx32g` | 250Gi and higher |

### Keep the heap below the container limit

The server is not the only JVM in the pod. The Control Panel, task scheduler, and sync agent each have their own heap, and all use the same container memory limit.

Set `FID_SERVER_JOPTS` to approximately half of the limit. This leaves memory for the other processes and for the operating-system page cache, which directory stores use heavily for read performance.

A heap set close to the container limit is the most common cause of pods that restart repeatedly under load.

For production, set resource requests equal to limits. Equal values give the pod a guaranteed quality of service and prevent it from being the first pod evicted when a node is under pressure.

## Storage classes by platform

The chart requires a storage class that provisions `ReadWriteOnce` block storage. Storage-class names are site-specific because they are created by the cluster administrator. The names in the following table are common examples, not guarantees.

List the storage classes available in your cluster:

```bash
kubectl get storageclass
```

| Platform | Used in Radiant Logic compatibility testing | Commonly used in production |
|---|---|---|
| Amazon EKS | `gp2` | `gp3`, usually created by the cluster administrator and preferred over `gp2` for throughput |
| Azure AKS | `default` | `managed-csi` for standard SSD or `managed-csi-premium` for premium SSD |
| Google GKE | `standard` | `standard-rwo` for balanced persistent disk or `premium-rwo` for SSD |
| Oracle OKE | `oci-bv` | `oci-bv` |
| Red Hat OpenShift | `csi-hostpath-provisioner` for test clusters only | Depends on the underlying platform: `gp3-csi` on AWS, `thin-csi` on vSphere, or `ocs-storagecluster-ceph-rbd` with OpenShift Data Foundation |
| Rancher and RKE2 | — | `longhorn`, or `local-path` for non-production. RKE2 includes no default storage class, so one must be installed and named explicitly. |

For the storage class you select, check the following properties:

- `allowVolumeExpansion: true`, if you want to grow the volume later without rebuilding it. Most managed classes have this setting, but some do not.
- `volumeBindingMode: WaitForFirstConsumer` on multi-zone clusters, so the volume is created in the same zone as the pod that uses it.

```bash
kubectl get storageclass <name> \
  -o jsonpath='{.allowVolumeExpansion}{"  "}{.volumeBindingMode}{"\n"}'
```

If `persistence.storageClass` specifies a class that does not exist, the persistent volume claims remain `Pending` and pods do not start.

## Deploying

1. Create a namespace for the deployment:

   ```bash
   kubectl create namespace self-managed
   ```

2. Deploy the registry credentials in the same namespace:

   ```bash
   kubectl apply -n self-managed -f regcred.yaml
   ```

3. Optionally perform a dry run. This renders the configuration without deploying it and reports template or value errors:

   ```bash
   helm -n self-managed upgrade --install fid \
     oci://registry-1.docker.io/radiantone/iddm-helm \
     --version 9.0.0 \
     --values </path/to/your/values.yaml> \
     --dry-run
   ```

4. Deploy Identity Data Management:

   ```bash
   helm -n self-managed install fid \
     oci://registry-1.docker.io/radiantone/iddm-helm \
     --version 9.0.0 \
     --values </path/to/your/values.yaml> \
     --wait
   ```

Helm prints `STATUS: deployed` and displays notes containing the port-forward command and commands for retrieving the root credentials.

With `--wait`, Helm returns when pods report ready. On a cluster that must add nodes first, this can take approximately five minutes. Without `--wait`, Helm returns after applying the manifests, while pods continue starting in the background.

### Choosing how Helm waits

The following flags control different aspects of how Helm waits. You typically use them together rather than choosing one instead of another.

| Flag | What it does |
|---|---|
| `--timeout`<br>(default: `5m0s`) | Sets the maximum time Helm waits for an individual Kubernetes operation, including a Job run as a hook. It limits how long Helm waits; it does not stop work in the cluster. When it expires, Helm returns an error, but work that has already started continues. A timed-out installation is not a cancelled installation. |
| `--wait` | Makes Helm wait until release resources report ready before reporting success, up to the `--timeout` value. Without this flag, Helm waits only for hooks and returns while pods are still starting. In Helm 4, this flag accepts a strategy: `--wait` means `watcher`, which waits for every resource; omitting the flag means `hookOnly`. In Helm 3, it is an on/off flag with the same effect. |
| `--wait-for-jobs` | When used with `--wait`, also makes Helm wait for Jobs in the release to finish before reporting success. |

Use the following guidance:

- For interactive installations, use `--wait` so that the command reports when the deployment is usable rather than only when Kubernetes accepts it.
- For automation and CI, use `--wait` with a `--timeout` value that comfortably exceeds expected startup time, so that one command succeeds or fails.
- When restoring a large backup, either omit `--wait` and monitor the pod yourself, or use `--wait` with a `--timeout` that exceeds the restore time. See [Restoring from a backup: sizing the startup probe](#restoring-from-a-backup-sizing-the-startup-probe).

Do not use `--atomic` when restoring from a backup. If the timeout expires, `--atomic` rolls back the release. On a fresh installation, this deletes a deployment that is partway through a restore.

## Restoring from a backup

### Size the startup probe

When `fid.migration.url` is set, the backup is downloaded and loaded during the first startup of the server pod, before the server starts responding.

During this process, Kubernetes checks the pod using a startup probe. The default startup allowance is five minutes. A backup of any significant size takes longer to load, so increase the allowance for the initial deployment.

The startup allowance is calculated as follows:

\[
\text{budget} = \text{periodSeconds} \times \text{failureThreshold}
\]

The default values are:

```text
20 × 15 = 300 seconds = 5 minutes
```

Increase `failureThreshold` and leave `periodSeconds` at `20`. Only the startup probe requires adjustment. While the startup probe runs, the liveness and readiness probes do not run and cannot interrupt the restore.

```yaml
fid:
  startupProbe:
    periodSeconds: 20
    failureThreshold: 540      # 20 × 540 = 10800s = 3 hours
```

### Values for a restore

Start with the complete values file at the end of this page. Make the following changes:

1. Set the backup URL.
2. Increase the startup allowance to cover backup loading.

```yaml
fid:
  # 1. Point to the backup. Use only for the initial deployment.
  migration:
    url: "https://<host>/<path>/export.zip"

  # 2. Increase the default allowance of 15 failures, or 5 minutes.
  #    20 × 540 = 10800s = 3 hours. Restore the default after verification.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 540
```

Both properties must be under `fid`. Values placed at the top level are ignored without warning. The deployment then starts either empty or with the default five-minute startup allowance.

Size the volume for the restored data, not the backup file. The stores on disk are significantly larger than the compressed archive.

### Estimate the startup allowance

Backup loading time depends on the uncompressed backup size, the number of entries, and group membership. When backlink optimization is enabled, calculating `ismemberof` can take longer than loading the entries.

Size the allowance for the backup that you are restoring, and allow a generous margin. An allowance that is too large only delays restarting a genuinely unhealthy server during this first boot.

| Backup, uncompressed | Approximate entries | Load time | `failureThreshold`<br>(with `periodSeconds: 20`) |
|---|---|---|---:|
| Under 100 MB | Tens of thousands | Approximately 1 minute, measured | 15; the default is sufficient |
| 1–2 GB | Around 1 million | 15–30 minutes, estimated | 120, or 40 minutes |
| Around 10 GB | Several million, with large groups and backlink optimization enabled | Approximately 2 hours, reported from an equivalent initialization | 540, or 3 hours |

As a general guideline, allow at least one minute per gigabyte of uncompressed backup, then add time for group calculation and round up generously. If you have initialized the same data set before, use the observed duration as the best estimate.

### Restore the default afterward

The same startup allowance applies to every later restart of the pod. For example, a value sized for a three-hour restore also gives a genuinely unhealthy server three hours before Kubernetes restarts it.

After the deployment is running and verified, remove the override and upgrade the release to restore the default five-minute allowance.

### If the allowance is too short

If the startup allowance is too short, the deployment can appear healthy but contain no data. Kubernetes stops the container while it is loading the backup. During the next startup, the software is already installed, so the restore is not attempted again and the server starts with empty stores.

Restarting does not recover the restore.

To confirm whether real stores were loaded, check the data directory:

```bash
kubectl -n self-managed exec fid-0 -c fid -- \
  du -sh /opt/radiantone/vds/vds_server/data/*
```

Stores that are only a few tens of kilobytes indicate that no data was loaded.

To recover, delete the deployment and its volumes, then install again with a larger startup allowance. See [Removing a deployment](#removing-a-deployment).

## Verifying the deployment

Check the pod status:

```bash
kubectl get pods -n self-managed
```

The following pods should be listed and should all be `Running` and ready:

| Pod | Description |
|---|---|
| `api-gateway` | API gateway that routes requests for the configuration REST API. |
| `authentication` | Configuration REST API endpoints for authentication. |
| `data-catalog` | Configuration REST API endpoints for the data catalog. |
| `directory-browser` | Configuration REST API endpoints for the directory browser. |
| `directory-namespace` | Configuration REST API endpoints for the directory namespace. |
| `fid-X` | Core server. The number of `fid` pods matches `replicaCount`. |
| `iddm-proxy` | Load balancer and reverse proxy. |
| `iddm-ui` | Control Panel front end. |
| `settings` | Configuration REST API endpoints for server settings, including security and ACIs. |
| `sync` | Synchronization service. New in v9; replaces `directory-schema`. |
| `system-administration` | Configuration REST API endpoints for administration, including users, roles, and permissions. |
| `zookeeper-X` | Distributed configuration service used by the backend. |

You also see four or five Jobs named `fid-hdap-…` with a `Completed` status, and their pods are also `Completed`.

These Jobs belong to the v8-to-v9 update procedure. During a fresh installation, they run, find no update work, and finish immediately. This is expected.

The following pods appear only when their corresponding features are enabled:

- `fid-follower-X` when `fid.followerOnly.enabled` is enabled.
- `zipkin` when `zipkin.enabled` is enabled. This feature is disabled by default.
- Logging and metrics services when their corresponding features are enabled.

### Renamed component

In v9, the `sync` pod replaces the `directory-schema` pod. Update any monitoring, alerting, or readiness checks that look for `directory-schema`; otherwise, they report a false failure.

The related Helm values section is now `globalSync` instead of `directorySchema`. Move any settings under `directorySchema`, such as `replicas`, `resources`, or pod labels, to `globalSync`. The chart ignores settings that remain under `directorySchema` without warning.

## Reaching the Control Panel

Port-forward the proxy service:

```bash
kubectl port-forward svc/iddm-proxy-service -n self-managed 8443:443
```

Then open [https://localhost:8443/login](https://localhost:8443/login).

Your browser displays a warning for the self-signed certificate. This is expected when you use port-forwarding.

To retrieve the root credentials:

```bash
kubectl get secret rootcreds-fid -n self-managed \
  -o jsonpath="{.data.fid-root-username}" | base64 -d; echo
```

```bash
kubectl get secret rootcreds-fid -n self-managed \
  -o jsonpath="{.data.fid-root-password}" | base64 -d; echo
```

For port-forwarding the Configuration API, ADAP/SCIM, and LDAP services, or for deleting a deployment, see the *Self-managed Deployment* guide.

## Troubleshooting an installation

| Symptom | Likely cause | Check |
|---|---|---|
| `fid-0` or `zookeeper-N` remains `Pending` | No node can satisfy the pod's resource requirements, node selector, or storage class. | ```bash<br>kubectl describe pod fid-0 -n self-managed \| tail -20<br>kubectl get pvc -n self-managed<br>``` A PVC that remains `Pending` with a provisioning error indicates that the storage class specified in your values file does not exist on the cluster. |
| A pod shows `ImagePullBackOff` | Registry credentials are missing or are in the wrong namespace. | ```bash<br>kubectl get secret regcred -n self-managed<br>kubectl describe pod <pod> -n self-managed \| grep -A3 Events<br>``` |
| Microservices remain in `Init:` for several minutes | The services wait for ZooKeeper and then `fid-0` to become ready. This is normal during initial startup. | ```bash<br>kubectl get pods -n self-managed -w<br>``` If `fid-0` is not ready, check its log. |
| `fid-0` restarts repeatedly | Usually a memory issue: `-Xmx` is too close to the container limit, or the limit is too small. | ```bash<br>kubectl get pod fid-0 -n self-managed -o jsonpath='{.status.containerStatuses[0].lastState}'<br>kubectl logs fid-0 -n self-managed -c fid --previous \| tail -50<br>``` |
| Control Panel login fails with `Invalid username or password` | The password in the values file was mistyped or contains characters changed by the shell when entered. | Retrieve the stored password using the secret command in [Reaching the Control Panel](#reaching-the-control-panel), then use that value. |
| Restore from backup creates an empty deployment | The `fid.migration.url` download failed silently, or the property was set as `migration.url`. | ```bash<br>kubectl exec -n self-managed fid-0 -- unzip -l /migrations/export.zip \| tail -3<br>``` |

## Removing a deployment

`helm uninstall` removes workloads but intentionally keeps persistent volume claims and their data.

Remove the deployment:

```bash
helm -n self-managed uninstall fid
```

View the persistent volume claims:

```bash
kubectl get pvc -n self-managed
```

Delete all persistent volume claims and their data only if you want a clean deployment:

```bash
kubectl delete pvc -n self-managed --all
```

> **Warning:** Deleting persistent volume claims permanently deletes the data.

## Complete values.yaml

The following file includes all tunable settings discussed in this guide. Copy it, replace placeholders, and adjust the marked values using the sizing and storage tables.

```yaml
# Minimal values.yaml covering everything worth tuning.
# Replace the placeholders, then adjust the marked numbers for your deployment.
replicaCount: 2                      # directory nodes; 1 for evaluation

fid:
  license: >-
    <YourLicense>
  rootPassword: "<EnterYourRootPw>"

  # --- Shutdown -----------------------------------------------------------
  # Each node closes its stores on shutdown, and that work shares this budget.
  # It is spent in full every time, and nodes stop one at a time, so a
  # scale-down costs roughly replicaCount x this value. 0 omits the field and
  # Kubernetes applies its own 30 seconds.
  terminationGracePeriodSeconds: 180

  # --- Start-up allowance -------------------------------------------------
  # budget = periodSeconds x failureThreshold. Default 20 x 15 = 5 minutes,
  # which is right for an ordinary start. Raise it ONLY while seeding from a
  # backup (below), and set it back afterwards: the same budget applies to
  # every later restart of the pod.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 15             # 15 = 5 min; 540 = 3 h while restoring

  # --- Seed from a backup (initial deployment only) ------------------------
  # Uncomment to restore from a backup of an existing deployment, and raise
  # failureThreshold above to cover the load first. Leave commented out when
  # updating an existing deployment.
  # migration:
  #   url: "https://<host>/<path>/export.zip"

imagePullSecrets:
  - name: regcred

# --- Compute ---------------------------------------------------------------
# Match a row from the sizing table. Keep requests equal to limits in
# production so the pod is not the first evicted under node pressure.
resources:
  requests:
    cpu: 4
    memory: 16Gi
  limits:
    cpu: 4
    memory: 16Gi

env:
  INSTALL_SAMPLES: "false"
  # Keep the heap near half the memory limit above: the Control Panel, task
  # scheduler and sync agent are separate JVMs drawing on the same limit, and
  # the directory stores rely on the OS page cache for read performance.
  FID_SERVER_JOPTS: "-Xms4g -Xmx8g"

# --- Storage ---------------------------------------------------------------
# storageClass must name a class that exists on the cluster: check with
# kubectl get storageclass. ReadWriteOnce block storage is required.
persistence:
  enabled: true
  storageClass: "gp3"
  size: 100Gi

zookeeper:
  persistence:
    enabled: true
    storageClass: "gp3"

# --- Updating from v8 ------------------------------------------------------
# These govern the Jobs that stop the nodes, export every store and rebuild it
# when updating a v8 deployment to v9. They do nothing on a fresh install, so
# the block is safe to keep in place. Each value is an upper bound: the step
# finishes as soon as it is done, and a generous bound costs nothing.
hdapMigration:
  # Must exceed replicaCount x terminationGracePeriodSeconds above, because
  # nodes stop one at a time and each takes its full grace period. With the
  # values above that is 2 x 180 = 360s, so the 300 default would time out.
  scaleDownTimeout: 900

  # Upper bound for the export. Allow about a minute per million entries,
  # sized from your largest single store.
  exportTimeout: 3600

  import:
    # Upper bound for the rebuild, the longest step. Allow about a minute per
    # million entries when the data sits in a few stores, and about six per
    # million when it is spread across many. 14400 = 4 hours.
    maxTimeout: 14400

    # Ceiling for the rebuild worker, which sizes itself from the data it
    # finds. Raise for very large stores.
    maxMemory: 16Gi
    maxCpu: 8

  # How long to wait for the nodes to come back and report ready afterwards.
  # Nodes after the first replicate the stores before they are ready, so this
  # grows with the data as well as the node count.
  postUpgradeWaitTimeout: 1800
```

Confirm that the cluster received the values you intended:

```bash
kubectl -n self-managed get statefulset fid \
  -o jsonpath='grace={.spec.template.spec.terminationGracePeriodSeconds}{"\n"}probe={.spec.template.spec.containers[0].startupProbe.periodSeconds}x{.spec.template.spec.containers[0].startupProbe.failureThreshold}{"\n"}resources={.spec.template.spec.containers[0].resources}{"\n"}'
```

Multiply the two startup-probe values to calculate the startup allowance in seconds.
