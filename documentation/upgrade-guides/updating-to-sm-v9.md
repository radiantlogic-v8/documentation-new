---
title: Updating to v9 Self-managed Deployment
description: Learn how to update an existing v8 self-managed RadiantOne Identity Data Management to v9.0.0.
---

# Overview 

This guide explains how to update an existing self-managed RadiantOne Identity Data Management v8 deployment to v9.0.0. It describes the update process, expected duration, recovery steps for failed updates, and how to return to v8 if necessary.

To install Identity Data Management 9.0.0 on a new cluster, see [Installing RadiantOne Identity Data Management v9](../installation/self-managed-v9.md).

## Before You Start

This update is not a simple image replacement. Version 9 upgrades the platform from Java 8 to Java 25 and the storage engine from Lucene 6 to Lucene 10. Because the v8 engine cannot read a Lucene 10 index, every RadiantOne Directory store must be exported from the existing version and rebuilt on the new version.

Confirm the following:

- **Plan for downtime.** All nodes are stopped and the directory is unavailable for the entire update. Configuration-only deployments take approximately 5 minutes. For directory stores, plan approximately 10 minutes per million entries on a three-node cluster. For example, 10 million entries require approximately 1 hour and 40 minutes. See [Update Duration](#update-duration).
- **Back up before you start.** There is no in-place rollback. The backup in Step 2 is required and is the only way to return to v8. Retain it until you have validated and accepted the v9 deployment.
- **Check the prerequisites.** The source deployment must be Identity Data Management 8.5.0 or later, and the `fid-0` volume must have free space equal to at least 3.5 times the current data store size.

> **Warning:** After the import/rebuild step begins, the `fid-0` volume contains v9 data. Do not scale the `fid` StatefulSet manually or attempt to run a v8 image against this volume. To return to v8, deploy a new v8 instance and restore the pre-upgrade backup.

## Update Steps

Follow these steps to update your self-managed Identity Data Management to version 9:

### 1. Confirm the Current Version

The existing deployment must run Identity Data Management 8.5.0 or later.

Check the current Helm release and container image:

```
helm -n self-managed list

kubectl get statefulset fid -n self-managed \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

The deployment is eligible for the update if the `fid` image tag is 8.5.0 or later, for example `radiantone/fid:8.5.3`. If the tag is earlier than 8.5.0, do not continue.

> Deployments running versions earlier than 8.5.0 must first update to version 8.5.0 or later within the v8 stream. For example, use chart `--version 1.5.3` for Identity Data Management 8.5.3.

You cannot update directly to v9 from a version earlier than 8.5.0. Confirm that the cluster is healthy before continuing.

### 2. Back Up Configuration and Directory Store Data

> **Warning:** Do not skip this step. There is no in-place downgrade from v9. This backup is the only way to return to v8. See [Returning to v8](#returning-to-v8).

Run the export script on the `fid-0` pod. Include `rli.migration.hdap.all` to back up directory store data together with the configuration.

```
kubectl exec -it -n self-managed fid-0 -- \
  /opt/radiantone/migrate.sh export pre-v9-backup.zip rli.migration.hdap.all
```

Copy the archive from the cluster, verify it, and store it securely:

```
kubectl cp -n self-managed \
  fid-0:/opt/radiantone/vds/work/pre-v9-backup.zip \
  ./pre-v9-backup.zip

unzip -l ./pre-v9-backup.zip | tail -3
```

### 3. Check Available Space on the fid-0 Volume

During the update, the volume contains the existing v8 stores, export archive, extracted LDIF files, and new v9 stores at the same time.

Check the current data directory size and available volume capacity:

```
kubectl exec -n self-managed fid-0 -- sh -c \
  'du -sh /opt/radiantone/vds/vds_server/data; df -h /opt/radiantone/vds'
```

Ensure that the volume has free space equal to at least 3.5 times the current data directory size. Expand the PersistentVolumeClaim before updating if necessary.

> **Note:** Rebuilt v9 stores are approximately twice the size of v8 stores and remain at that size after the update. Size the volume for ongoing use, not only for the update.

### 4. Update the values file

Make the following changes in your `values.yaml` file:

- Remove `image.tag`. In v9, the image version is set through `--version`. If `image.tag` remains set to a v8 image, such as `8.5.x`, Helm deploys the v8 image and the update cannot continue.
- Rename `directorySchema` to `globalSync`. The component is now named `sync`. Settings under the deprecated `directorySchema` key are silently ignored.
- Pass values explicitly with `--values <path>`. Do not use `--reuse-values`, because it retains incompatible v8 values.
- Omit `hdapMigration.rolloutTimeout`. This setting has no effect in v9.

> **Note:** Do not change startup probe settings for a standard update. The rebuild runs in dedicated worker pods, not in `fid-0`; therefore, it does not consume the `fid-0` startup-probe allowance. See [Startup Probe Settings](#startup-probe-settings).

#### Tune Migration Timeouts for Large Stores

If the dataset exceeds the default limits, adjust the following settings in `values.yaml`.

| Setting | Default | When to change it |
|---|---|---|
| `hdapMigration.scaleDownTimeout` | `300 s` | Pods stop sequentially, and each pod uses its full `terminationGracePeriodSeconds`. If you increased that value, set this to at least `(replicas × terminationGracePeriodSeconds) + 60`. |
| `hdapMigration.exportTimeout` | `1800 s` | Time allowed for export, approximately 2 minutes per million entries. Increase for datasets above 10 million entries. |
| `hdapMigration.import.maxTimeout` | `14400 s` | Upper limit for one import attempt, approximately 6 minutes per million entries. |
| `hdapMigration.import.maxAttempts` | `3` | Maximum rebuild attempts. Each retry allocates more memory if a previous attempt ran out of memory. |
| `hdapMigration.postUpgradeWait` | `true` | Post-update readiness gate. Keep this set to `true` to verify that all stores are serving before the update completes. |
| `hdapMigration.postUpgradeWaitTimeout` | `1800 s` | Maximum wait time for all nodes to restart and re-synchronize stores, approximately 1 minute per million entries. Increase for large datasets. |

Example migration configuration:

```
fid:
  terminationGracePeriodSeconds: 180

hdapMigration:
  scaleDownTimeout: 900
  exportTimeout: 7200
  import:
    maxTimeout: 28800
```

### 5. Protect ZooKeeper When Using a Cluster Autoscaler

When RadiantOne nodes stop during the rebuild, underutilized Kubernetes nodes can trigger a cluster autoscaler scale-down event that terminates ZooKeeper pods. The export process requires ZooKeeper connectivity.

Prevent autoscaler eviction by annotating ZooKeeper pods:

```
kubectl annotate pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  cluster-autoscaler.kubernetes.io/safe-to-evict=false \
  --overwrite

kubectl get pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  -o wide
```

### 6. If You Use Follower-Only Nodes

If you use follower-only nodes through `fid.followerOnly`, the update automatically removes their data volumes.

After `fid-0` starts on v9, follower nodes rebuild and re-synchronize data directly from `fid-0`. Include this synchronization time in the maintenance window.

### 7. If You Deploy with Argo CD

The update Jobs run as Helm hooks using `PreSync` and `PostSync`.

When deploying through Argo CD:

- Do not use Argo CD sync status as the only completion indicator. Check the `fid-hdap-post-upgrade-wait` Job status and the ConfigMap phase value.
- Pre-upgrade hooks run on every sync. When syncing an already updated deployment, the migration Jobs detect that FID is running v9 and exit without modifying data.
- Prune deprecated components. Because v9 replaces `directory-schema` with `sync`, Argo CD reports the application as `OutOfSync` until the old resources are removed.

Sync with Prune enabled, or remove the old resources manually:

```
NS=self-managed

kubectl -n $NS delete deployment/directory-schema \
  service/directory-schema-service \
  --ignore-not-found

kubectl -n $NS delete pdb/fid-directory-schema-pdb \
  --ignore-not-found
```

### 8. Record the Pre-Upgrade State

Capture baseline cluster metrics before running the update:

```
NS=self-managed

echo "release : $(helm -n $NS list | awk '$1=="fid"{print $9" ("$8")"}')"

echo "fid     : $(kubectl -n $NS get sts fid \
  -o jsonpath='image={.spec.template.spec.containers[0].image} ready={.status.readyReplicas}/{.spec.replicas}')"

echo "zk      : $(kubectl -n $NS get pods \
  -l app.kubernetes.io/name=zookeeper \
  --no-headers | awk '{r+=($2=="1/1")} END{print r"/"NR" ready"}')"

echo "pods    : $(kubectl -n $NS get pods --no-headers \
  | grep -v Completed \
  | awk '{t++; if($3=="Running") r++} END{print r"/"t" Running"}')"

echo "stores  : $(kubectl -n $NS exec fid-0 -c fid -- sh -c \
  'ls -1 /opt/radiantone/vds/vds_server/data | wc -l; \
   du -sh /opt/radiantone/vds/vds_server/data | cut -f1; \
   df -h /opt/radiantone/vds | tail -1 | awk "{print \$4" free"}"' \
  | tr '\n' ' ')"

echo "version : $(kubectl -n $NS exec fid-0 -c fid -- \
  /opt/radiantone/vds/bin/show_version.sh \
  | grep -E '^RadiantOne [0-9]|Build-Id' \
  | tr -s ' ' \
  | tr '\n' ' ')"

echo "pvcs    : $(kubectl -n $NS get pvc --no-headers \
  | awk '{printf "%s=%s ", $1, $4}')"
```

Example output:

```
release : iddm-helm-1.5.3 (deployed)
fid     : image=radiantone/fid:8.5.3 ready=1/1
zk      : 3/3 ready
pods    : 14/14 Running
stores  : 14 659.8M 7.9G free
version : RadiantOne 8.5.3 Build-Id : ...
pvcs    : r1-pvc-fid-0=10Gi zk-pvc-zookeeper-0=10Gi zk-pvc-zookeeper-1=10Gi zk-pvc-zookeeper-2=10Gi
```

### 9. Apply the Update

A single Helm command runs the entire update through automated Kubernetes Jobs. The Jobs stop nodes, export data, rebuild stores, bring nodes online, and validate cluster readiness. See [What Happens During the Update](#what-happens-during-the-update).

Run the Helm upgrade command:

```
helm -n self-managed upgrade --install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml> \
  --timeout 4h \
  --wait
```

> **Warning:** Always set `--timeout` to a value that covers the full update window. The default timeout of 5 minutes expires during store export and rebuild. Do not use `--atomic` or `--rollback-on-failure` (Helm 4). If Helm times out, these options force a rollback while migration Jobs are converting data, which corrupts the volume.

If Helm times out, it reports the release as failed, but the migration Jobs continue running in Kubernetes. Do not scale the `fid` StatefulSet manually. Monitor the Jobs until they finish, then rerun the Helm command. See [Helm Timeout and Wait Options](#helm-timeout-and-wait-options).

### 10. Monitor Update Progress

In a separate terminal, monitor the migration phase and Job logs. For a description of each Job, see [What Happens During the Update](#what-happens-during-the-update).

```
NS=self-managed

kubectl get jobs -n $NS -w

kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'

kubectl logs -f job/fid-hdap-export -n $NS

kubectl logs -f job/fid-hdap-import -n $NS

kubectl get pods -n $NS -w
```

A healthy update can follow this timeline:

```
+13s   phase=ready-for-export  fid=1/0  scale-down=Running
+59s   phase=ready-for-export  fid=0/0  scale-down=Complete  export=Running
+116s  phase=importing         fid=0/0  export=Complete      import=Running
+299s  phase=completed         fid=0/0  import=Complete      pvc-cleanup=Running
+322s  phase=completed         fid=0/1  pvc-cleanup=Complete  post-upgrade-wait=Running  <- fid-0 starting
+427s  phase=completed         fid=1/1  post-upgrade-wait=Running
+437s  helm returns: Release "fid" has been upgraded. STATUS: deployed, REVISION: 2
```

During this stage, ZooKeeper and other microservice pods restart as their images update. Pod restarts for several minutes are expected.

> If a step fails, rerun the same Helm command from Step 9. Completed steps are skipped automatically. See [If a Step Fails](#if-a-step-fails).

### 11. Validate the Updated Deployment

After Helm reports `STATUS: deployed`, verify the deployment:

```
NS=self-managed

kubectl get pods -n $NS

kubectl get jobs -n $NS

kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'

kubectl get statefulset fid -n $NS \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'

kubectl exec fid-0 -n $NS -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list
```

Run the baseline script from Step 8 again and compare the results:

- Store counts must match.
- The version must show `9.0.0`.
- The data volume size will be larger.

Perform smoke tests for:

- LDAP queries
- REST/ADAP
- SCIM endpoints
- Control Panel logins

If you applied the ZooKeeper autoscaler annotation, remove it after validation:

```
kubectl annotate pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  cluster-autoscaler.kubernetes.io/safe-to-evict-
```

Update monitoring rules that reference `directory-schema` so that they monitor `sync`.

#### Review Step Durations

Migration Jobs are retained for 24 hours. Check the duration of each Job:

```
kubectl get jobs -n self-managed -o json | jq -r \
  '.items[]
   | select(.metadata.name|startswith("fid-hdap"))
   | "\(.metadata.name)\t\(((.status.completionTime|fromdate) - (.status.startTime|fromdate)))s"'
```

View the detailed migration summary:

```
kubectl get configmap fid-hdap-migration-state -n self-managed \
  -o jsonpath='{range $k,$v := .data}{$k}={$v}{"\n"}{end}'
```

## Values file reference

Use this `values.yaml` template as a starting point. Adjust placeholders and sizing parameters for your environment.

```
# Minimal values.yaml covering standard tuning parameters.
# Replace placeholders and adjust resource numbers for your deployment.

replicaCount: 2  # Directory nodes (use 1 for evaluation)

fid:
  license: >-

  rootPassword: ""

  # --- Shutdown Budget ----------------------------------------------------
  # Time allocated for clean store shutdown. Pods stop sequentially, so
  # scale-down time = replicaCount x terminationGracePeriodSeconds.
  terminationGracePeriodSeconds: 180

  # --- Startup Allowance --------------------------------------------------
  # Budget = periodSeconds x failureThreshold (Default: 20 x 15 = 5 minutes).
  # Keep defaults for standard upgrades.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 15  # 15 = 5 min (use 540 = 3h only when restoring backups)

imagePullSecrets:
  - name: regcred

# --- Compute Resources ----------------------------------------------------
# Set requests equal to limits in production for Guaranteed QoS.
resources:
  requests:
    cpu: 4
    memory: 16Gi
  limits:
    cpu: 4
    memory: 16Gi

env:
  INSTALL_SAMPLES: "false"

  # Maintain heap size at roughly 50% of the container memory limit.
  # Leaves room for auxiliary JVMs (Control Panel, Sync) and OS page cache.
  FID_SERVER_JOPTS: "-Xms4g -Xmx8g"

# --- Storage Configuration ------------------------------------------------
# Requires ReadWriteOnce block storage.
persistence:
  enabled: true
  storageClass: "gp3"
  size: 100Gi

zookeeper:
  persistence:
    enabled: true
    storageClass: "gp3"

# --- v8 to v9 Migration Parameters ----------------------------------------
hdapMigration:
  # Must exceed: (replicaCount x terminationGracePeriodSeconds) + 60
  scaleDownTimeout: 900

  # Upper bound for export (~2 minutes per million entries)
  exportTimeout: 3600

  import:
    # Upper bound for rebuild (~6 minutes per million entries; 14400s = 4h)
    maxTimeout: 14400
    maxMemory: 16Gi
    maxCpu: 8
    maxAttempts: 3

  # Post-upgrade verification gate
  postUpgradeWait: true
  postUpgradeWaitTimeout: 1800
```

Verify the applied StatefulSet settings:

```
kubectl -n self-managed get statefulset fid \
  -o jsonpath='grace={.spec.template.spec.terminationGracePeriodSeconds}{"\n"}probe={.spec.template.spec.containers[0].startupProbe.periodSeconds}x{.spec.template.spec.containers[0].startupProbe.failureThreshold}{"\n"}resources={.spec.template.spec.containers[0].resources}{"\n"}'
```


## What Happens During the Update

When you run `helm upgrade`, the chart starts Kubernetes hook Jobs before applying the new version.

```
+---------------------------------------------------------------------------------------------------------+
|                                  v9 Migration Lifecycle                                                 |
|                                                                                                         |
|  1. Scale-Down      2. Export Worker      3. Import Worker      4. Follower PVC    5. Post-Upgrade    |
|      (Job)             (v8 Image)            (v9 Image)            Cleanup         Readiness Check    |
|                                                                                                         |
|  [ Stop Nodes ] ---> [ Export Stores ] ---> [ Rebuild & Verify ] -> [ Delete PVCs ] -> [ Verify Stores ]|
|  fid-hdap-scale-down  fid-hdap-export       fid-hdap-import        fid-hdap-pvc-clean  fid-hdap-post-wait|
+---------------------------------------------------------------------------------------------------------+
```

| Step | Job name | Action | Observed behavior |
|---|---|---|---|
| 1 | `fid-hdap-scale-down` | Sequentially stops all RadiantOne nodes, including main and follower nodes, and saves replica counts to the migration state ConfigMap. | FID pods terminate sequentially and `fid-0` disappears. |
| 2 | `fid-hdap-export` | Starts a temporary `fid-hdap-export-worker` pod using the current v8 image and the `fid-0` volume. The worker exports all stores to LDIF in an archive and records store names. | `fid-hdap-export-worker` runs and completes. Job logs are retained. |
| 3 | `fid-hdap-import` | Starts a temporary `fid-hdap-import-worker` pod using the v9 image and the `fid-0` volume. It runs the product updater, upgrades binaries, rebuilds all store indexes from LDIF, and verifies store integrity. If necessary, it retries with increased memory up to `import.maxAttempts`. | `fid-hdap-import-worker` runs for minutes or hours and then completes. |
| 4 | `fid-hdap-pvc-cleanup` | Deletes follower PersistentVolumeClaims so that follower nodes synchronize clean v9 stores from `fid-0` when they start. | Follower PVCs are deleted. |
| After 4 | Helm apply | Helm updates the StatefulSet to the `9.0.0` image. `fid-0` starts with the converted volume, follower pods start and re-synchronize, and supporting services update concurrently. | FID pods restart on v9.0.0. |
| 5 | `fid-hdap-post-upgrade-wait` | Optional readiness gate, enabled by default. Verifies that FID pods are fully rolled out, healthy, and serving every store recorded during export. | Completes after all stores are online and serving. |

The `fid-hdap-migration-state` ConfigMap tracks progress through these phases:

```
ready-for-export → exported → importing → completed
```

### Update Duration

Downtime starts when `fid-hdap-scale-down` begins and ends when the first node serves traffic, or when the readiness gate completes.

Downtime depends on total entry count rather than node count.

#### Estimated Downtime for a Three-Node Cluster

| Dataset size | Scale-down | Export | Rebuild / Import | Gate and replication | Total estimated downtime | Basis |
|---|---|---|---|---|---|---|
| Config only, less than 1 MB | 1m 49s | 29s | 2m 09s | 12s | Approximately 5 min | Measured |
| 1 million entries | Approximately 3 min | Approximately 3 min | Approximately 8 min | Approximately 3 min | Approximately 17 min | Estimated |
| 5 million entries | Approximately 3 min | Approximately 11 min | Approximately 32 min | Approximately 8 min | Approximately 55 min | Estimated |
| 10 million entries | Approximately 3 min | Approximately 21 min | More than 1 hour | Approximately 13 min | Approximately 1h 40m or more | Measured rebuild |
| 20 million entries | Approximately 3 min | Approximately 41 min | Approximately 2 hours | Approximately 24 min | Approximately 3h 10m | Estimated |
| 50 million entries | Approximately 3 min | Approximately 1h 40m | Approximately 5 hours | Approximately 1 hour | Approximately 7h 45m | Estimated |

**Rule of thumb:** Plan for approximately 2 minutes per million entries for export, 6 minutes per million entries for rebuild, and 1 minute per million entries for follower re-synchronization, plus fixed operational overhead.

#### Recommended Timeout Settings

| Entry count | Recommended settings override | Recommended Helm `--timeout` |
|---|---|---|
| Up to 5 million | Defaults | 1h 30m |
| 5–10 million | Defaults | 2h 30m |
| 10–20 million | `exportTimeout: 3600`, `postUpgradeWaitTimeout: 3600` | 4h |
| 20–50 million | `exportTimeout: 10800`, `import.maxTimeout: 28800`, `postUpgradeWaitTimeout: 7200` | 10h |
| Above 50 million | Contact Radiant Logic Support to plan the maintenance window | Not applicable |

### Large Individual Stores

The migration tool determines worker memory from the largest export file. If a single store export exceeds 4 GB, ZIP archive headers limit the reported size to a 4 GB placeholder.

The rebuild engine streams data and typically does not require proportional heap increases. A 10-million-entry store rebuilds successfully with the default settings. However, if an exceptionally large store encounters memory limits, set:

```
hdapMigration:
  import:
    maxMemory: 32Gi
```

## Helm Timeout and Wait Options

Helm always waits for hook Jobs. The `--timeout` and `--wait` options control Helm client behavior during and after the update.

| Option | Function | Recommendation |
|---|---|---|
| `--timeout` | Limits how long Helm waits for an individual step or Job. If it expires, Helm reports a failure, but Jobs continue running in the cluster. | Always set an explicit value longer than the complete maintenance window, such as `4h`. |
| `--wait` | Instructs Helm to wait until all StatefulSets, Deployments, and microservices report Ready before returning success. | Always use with `--timeout` to confirm full cluster health before Helm returns. |
| `--wait-for-jobs` | Tells Helm to wait for standard Jobs. | Not required. Migration Jobs are hooks, and Helm waits for them automatically. |

> **Warning:** Do not use `--atomic` or `--rollback-on-failure`. These options can force Helm to roll back after a timeout. Rolling back while migration Jobs are converting data corrupts the volume.

## Startup Probe Settings

For standard updates, no startup probe changes are required.

The rebuild runs in worker pods outside Kubernetes health probes. `fid-0` starts only after data conversion finishes and starts within the default 5-minute allowance.

If the worker is disabled by setting `hdapMigration.import.enabled: false`, the rebuild runs inside `fid-0` during first startup. In that case, the chart automatically increases the minimum startup allowance to 1 hour.

For migrations larger than 10 million entries, set `hdapMigration.firstBootImportBudget: 7200` or higher.

## Sizing and Storage Recommendations

### Volume Capacity

Before the update, confirm that the `fid-0` volume has free space equal to at least 3.5 times the current store data size.

Rebuilt v9 stores are approximately twice the size of v8 stores and remain at that size after the update.

### Pod Resources

| Deployment profile | CPU | Memory | `FID_SERVER_JOPTS` | Volume size |
|---|---|---|---|---|
| Dev / Evaluation | 2 | 8Gi | `-Xms2g -Xmx4g` | 10Gi |
| Small production, fewer than 1 million entries | 4 | 16Gi | `-Xms4g -Xmx8g` | 50Gi |
| Medium production, 1–10 million entries | 8 | 32Gi | `-Xms8g -Xmx16g` | 100Gi |
| Large production, more than 10 million entries | 8–16 | 64Gi | `-Xms16g -Xmx32g` | 250Gi or more |

Keep the JVM heap specified by `FID_SERVER_JOPTS` at approximately 50% of the container memory limit. This preserves capacity for auxiliary processes, including Sync and Control Panel, and for the operating system page cache.

### Storage Classes by Platform

The storage class must support ReadWriteOnce block storage, dynamic volume expansion through `allowVolumeExpansion: true`, and `volumeBindingMode: WaitForFirstConsumer`.

| Cloud platform | Production storage class |
|---|---|
| Amazon EKS | `gp3`, preferred over `gp2` for dedicated IOPS and throughput |
| Azure AKS | `managed-csi` for Standard SSD, or `managed-csi-premium` for Premium SSD |
| Google GKE | `standard-rwo` for Balanced PD, or `premium-rwo` for SSD |
| Oracle OKE | `oci-bv` |
| Red Hat OpenShift | `gp3-csi` on AWS, `thin-csi` on vSphere, or `ocs-storagecluster-ceph-rbd` |
| Rancher / RKE2 | `longhorn`; requires manual installation because RKE2 provides no default class |

## Troubleshooting

### If a Step Fails

To diagnose a failure, check the migration phase and the active Job logs:

```
NS=self-managed

kubectl get jobs -n $NS

kubectl get configmap fid-hdap-migration-state -n $NS -o yaml

kubectl logs job/<job-name> -n $NS | tail -40
```

| Failing step | Root cause | Cluster state | Recovery action |
|---|---|---|---|
| `fid-hdap-scale-down` | Pods did not terminate within `scaleDownTimeout`, or a pod is stuck on an unreachable node. | RadiantOne automatically scales back up on v8. Volume data is unchanged. | Increase `scaleDownTimeout` and rerun `helm upgrade`. |
| `fid-hdap-export` | ZooKeeper was unavailable, the worker ran out of memory, or disk capacity is full. | RadiantOne automatically scales back up on v8. Volume data is unchanged. | Resolve the cause, such as restoring ZooKeeper or expanding the PVC, then rerun `helm upgrade`. |
| `fid-hdap-import` | Rebuild exceeded timeout or memory limits, or store verification failed. | RadiantOne remains stopped intentionally. The volume now contains v9 data, and the chart prevents v8 from running against it. | Do not scale the `fid` StatefulSet manually. Increase `import.maxTimeout` or `import.maxMemory`, then rerun `helm upgrade`. The rebuild resumes safely. |
| `fid-hdap-pvc-cleanup` | Follower PVC deletion failed. | Rebuild is complete, but follower cleanup is pending. | Rerun `helm upgrade`. |
| `fid-hdap-post-upgrade-wait` | Nodes required more than `postUpgradeWaitTimeout` to become ready, or a store did not load. | The deployment is updated. | If pods are still initializing, rerun `helm upgrade` so the gate can verify readiness. If stores did not load, inspect logs and contact Support. |
| Helm timeout expired | Helm `--timeout` expired while migration Jobs were running. | Migration Jobs continue in the background. | Monitor Jobs using `kubectl get jobs -w`. After they complete, rerun `helm upgrade` with a longer `--timeout`. |

> **Warning:** After the import/rebuild step begins, the `fid-0` volume contains v9 data. Do not scale the `fid` StatefulSet manually (for example, with `kubectl scale sts fid --replicas=N`); doing so can start the v8 image against v9 data and corrupt the deployment. To resume the update, rerun the Helm upgrade command.

### Common Symptoms

| Symptom | Cause | Resolution |
|---|---|---|
| `fid-hdap-scale-down` times out | Sequential shutdown exceeded the timeout, or a node is `NotReady`. | Check node health with `kubectl get nodes`. If nodes are healthy, increase `scaleDownTimeout`. Do not force-delete pods on unreachable nodes. |
| Export fails with `Cannot reach ZooKeeper` | A cluster autoscaler evicted a ZooKeeper pod. | Confirm ZooKeeper is `3/3` ready, apply the `safe-to-evict=false` annotation, and rerun `helm upgrade`. |
| Worker pod remains `Pending` | Insufficient node CPU or memory, or the PersistentVolume is in a `Multi-Attach` state. | Run `kubectl describe pod fid-hdap-export-worker`. Stale volume attachments normally clear within several minutes. |
| Import fails with out-of-memory errors | A store requires more memory than the worker limit. | Increase `hdapMigration.import.maxMemory`, for example to `32Gi`, and increase `hdapMigration.import.maxAttempts`. Then rerun `helm upgrade`. |
| Rerun fails with `Attempt limit reached` | Previous failed attempts exhausted the ConfigMap attempt counter. | Increase `hdapMigration.import.maxAttempts` in `values.yaml`, then rerun `helm upgrade`. |
| Gate fails with `fid is at 0 replicas` | Helm was interrupted before applying the v9 StatefulSet manifest. | Rerun `helm upgrade` to apply the updated StatefulSet. |
| Gate fails with `exported stores were never opened` | The server started but could not load one or more migrated stores. | Collect `kubectl logs fid-0 -c fid` and `kubectl logs job/fid-hdap-post-upgrade-wait`, then contact Radiant Logic Support before serving traffic. |
| Monitoring reports a missing `directory-schema` component | The component was renamed to `sync` in v9. | Update monitoring configuration to monitor `sync`. |

### Log Locations

- **Rebuild worker logs:** Stored on the persistent volume at `/opt/radiantone/vds/work/hdap-migration/`. The logging sidecar streams them after `fid-0` starts.
- **Job output:** View using `kubectl logs job/<job-name> -n self-managed`.
- **Job retention:** Kubernetes retains migration Jobs and logs for 24 hours through `hdapMigration.job.ttlSecondsAfterFinished: 86400`.
- **Server runtime logs:** View live logs with `kubectl logs fid-0 -n self-managed -c fid`, or inspect `/opt/radiantone/vds/vds_server/logs/` in the pod.

## Removing Upgrade Artifacts

Uninstalling a release with `helm uninstall fid` leaves hook-created RBAC objects and completed Jobs in the namespace.

To remove remaining artifacts:

```
NS=self-managed

# Delete migration RBAC and completed Jobs.
kubectl -n $NS delete serviceaccount,role,rolebinding \
  -l app.kubernetes.io/component=hdap-migration,app.kubernetes.io/instance=fid

kubectl -n $NS delete job --ignore-not-found \
  fid-hdap-scale-down \
  fid-hdap-export \
  fid-hdap-pvc-cleanup \
  fid-hdap-import \
  fid-hdap-post-upgrade-wait

kubectl -n $NS delete configmap fid-hdap-migration-state \
  --ignore-not-found

kubectl -n $NS delete --ignore-not-found \
  serviceaccount/fid-hook-account \
  role/fid-manage-pods \
  rolebinding/fid-manage-pods

# Verify namespace cleanup.
kubectl -n $NS get serviceaccount,role,rolebinding,job,configmap,pod \
  -l app.kubernetes.io/instance=fid
```

## Returning to v8

Because v9 directory stores cannot be converted back to v8, returning to v8 requires a new v8 deployment restored from the pre-v9 backup.

### 1. Clear the Namespace

Terminate helper pods and release volume claims before reinstalling.

```
NS=self-managed

# 1. Uninstall the Helm release.
helm -n $NS uninstall fid

# 2. Delete migration hooks, Jobs, and remaining helper pods.
kubectl -n $NS delete serviceaccount,role,rolebinding \
  -l app.kubernetes.io/component=hdap-migration,app.kubernetes.io/instance=fid

kubectl -n $NS delete job --ignore-not-found \
  fid-hdap-scale-down \
  fid-hdap-export \
  fid-hdap-pvc-cleanup \
  fid-hdap-import \
  fid-hdap-post-upgrade-wait

kubectl -n $NS delete configmap fid-hdap-migration-state \
  --ignore-not-found

kubectl -n $NS delete pod \
  fid-hdap-export-worker \
  fid-hdap-import-worker \
  --ignore-not-found

# 3. Delete all PersistentVolumeClaims.
kubectl -n $NS delete pvc --all

# 4. Confirm that no PVCs remain in Terminating status.
kubectl -n $NS get pvc
```

> Confirm that PVCs are fully deleted. If a claim remains in `Terminating`, identify the pod holding it:

```
kubectl -n $NS get pods -o json | jq -r \
  '.items[]
   | select(.spec.volumes[]?.persistentVolumeClaim.claimName=="r1-pvc-fid-0")
   | .metadata.name'
```

Delete the pod so that the PVC can release. Reinstalling while a PVC is terminating prevents the `fid-0` pod from being created.

### 2. Reinstall v8 and Restore the Backup

Host the `pre-v9-backup.zip` file at an HTTP or HTTPS endpoint accessible from the cluster.

Ensure the URL does not contain `&` characters. Pre-signed query strings containing `&` break the v8 shell download script.

Configure the v8 `values.yaml` file with the backup URL:

```
fid:
  migration:
    url: "https://files.internal.example.com/pre-v9-backup.zip"

  startupProbe:
    failureThreshold: 540  # 540 x 20s = 3 hours
```

Install the v8 Helm chart that matches the previous v8 version. For example, use chart `1.5.3` for Identity Data Management 8.5.3:

```
helm -n self-managed install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 1.5.3 \
  --values /path/to/v8-values.yaml
```

Confirm that `fid-0` downloaded and extracted the archive:

```
kubectl exec -n self-managed fid-0 -- \
  unzip -l /migrations/export.zip | tail -3
```

Verify that `fid-0` and all supporting pods are running and ready:

```
kubectl -n self-managed get pods
```

Then:

- Re-initialize persistent caches.
- Verify entry counts and spot-check DNs.
- Validate LDAP, SCIM, REST/ADAP, and Control Panel access.
- Redirect client traffic to the restored v8 deployment.

## Release notes and support

For v9 improvements and fixes, see the [v9.0 release notes](../maintenance/v9release-notes/v9.0-release-notes-temp/).

For known issues reported after release, see the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues).

To report problems or provide feedback, use [Radiant Logic Support](https://support.radiantlogic.com). If you do not have a Support login, contact [support@radiantlogic.com](mailto:support@radiantlogic.com).
