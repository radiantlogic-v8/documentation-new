---
title: Updating to v9 self-managed deployment
description: Learn how to update an existing v8 self-managed RadiantOne Identity Data Management to v9.0.0.
---

# Overview

This guide explains how to update an existing self-managed RadiantOne Identity Data Management v8 deployment to v9.0.0. It describes the update process, expected duration, recovery steps for failed updates, and how to revert to v8 if necessary.

To install Identity Data Management 9.0.0 on a new cluster, see [Installing RadiantOne Identity Data Management v9](../installation/self-managed-v9.md).

## Before you start

This is not an image-only update. Version 9 moves the platform from Java 8 to Java 25 and the storage engine from Lucene 6 to Lucene 10. Because the v8 engine cannot read Lucene 10 indexes, each RadiantOne Directory store must be exported from the v8 deployment and rebuilt for v9. All nodes are unavailable during the update.

Consider the following before you begin:

### Prerequisites

Confirm prerequisites. The source deployment must run Identity Data Management 8.5.0 or later.

### Backup

Back up the deployment. There is no in-place downgrade. The Step 2 backup is required to restore v8. Keep it until you accept the v9 deployment.

### Storage

During the update, the volume holds the v8 stores, exported data, and rebuilt v9 stores. Ensure that free space is at least 3.5 times the current store size. The rebuilt v9 stores are approximately twice the size of the v8 stores.

### Maintenance window

Schedule a maintenance window to plan for downtime. The directory is unavailable throughout the update, and additional nodes do not reduce the rebuild time. A configuration-only deployment takes approximately 5 minutes. For deployments with directory data, allow approximately 10 minutes per million entries for a three-node cluster. For example, a 10-million-entry deployment can require approximately 1 hour and 40 minutes. This estimate includes rebuild time, node restarts, store replication, and the readiness check. See [Update duration](#update-duration).


> [!warning] After the rebuild step begins, the `fid-0` volume contains v9 data. Do not scale the `fid` StatefulSet manually or restart its pods. See [Recover safely after a rebuild failure](#recover-safely-after-a-rebuild-failure). To revert to v8, deploy a new v8 instance and restore the pre-upgrade backup.

## Update steps

Follow these steps to update your self-managed Identity Data Management to version 9. Rerun the same command if you encounter a failure. See [Troubleshooting](#troubleshooting) for more details.

### 1. Confirm the current version

The existing deployment must run Identity Data Management 8.5.0 or later.

Check the current Helm release and container image:

```
helm -n self-managed list

kubectl get statefulset fid -n self-managed \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

The deployment is eligible for the update if the `fid` image tag is 8.5.0 or later, for example `radiantone/fid:8.5.3`. If the tag is earlier than 8.5.0, do not continue.

> [!note] Deployments running versions earlier than 8.5.0 must first update to version 8.5.0 or later within the v8 stream, using the v8 chart mapping. For example, use chart `--version 1.5.3` for Identity Data Management 8.5.3.

The update refuses to start from a source version earlier than 8.5.0. Confirm that the deployment is healthy before continuing.

### 2. Back up configuration and directory store data

> [!warning]
> Do not skip this step. There is no in-place downgrade from v9. This backup is the only way to revert to v8. See [Reverting to v8](#reverting-to-v8).

Run the export script on the `fid-0` pod. The `rli.migration.hdap.all` argument includes the RadiantOne Directory stores. Without it, the backup contains configuration only.

```
kubectl exec -it -n self-managed fid-0 -- \
  /opt/radiantone/migrate.sh export pre-v9-backup.zip rli.migration.hdap.all
```

The file is created at `/opt/radiantone/vds/work/pre-v9-backup.zip`. Copy it from the cluster, check that it is a valid zip file, and store it until you have accepted the v9 deployment:

```
kubectl cp -n self-managed \
  fid-0:/opt/radiantone/vds/work/pre-v9-backup.zip \
  ./pre-v9-backup.zip

unzip -l ./pre-v9-backup.zip | tail -3
```

### 3. Check available space on the fid-0 volume

During the update, the volume temporarily contains the existing v8 stores, the export archive, the extracted LDIF files, and the rebuilt v9 stores. Because v9 stores are larger than v8 stores, this requires additional free space. For example, in a 5-million-entry deployment, 3.2 GB of v8 store data can produce a 0.2 GB export archive and 2.0 GB of extracted LDIF files, and then rebuild as 6.0 GB of v9 store data.

Check the current data directory size and available volume capacity:

```
kubectl exec -n self-managed fid-0 -- sh -c \
  'du -sh /opt/radiantone/vds/vds_server/data; df -h /opt/radiantone/vds'
```

Ensure that the volume has free space equal to at least 3.5 times the current data directory size. If the volume is more than approximately one third full, expand it before the update. Expanding the volume requires a storage class with `allowVolumeExpansion: true`. See [Volume capacity](#volume-capacity).

> [!note] Rebuilt v9 stores are approximately twice the size of v8 stores and remain at that size after the update. Size the volume for ongoing use, not only for the update.

### 4. Update the values file

Make the following changes in your `values.yaml` file:

- Remove `image.tag`. In v9, the image version is set through `--version`. If `image.tag` remains set to a v8 image, such as `8.5.x`, the chart renders the old image and the update does not proceed.
- If you have settings under `directorySchema`, rename the key to `globalSync`. The component is now named `sync`. Settings under the old `directorySchema` key are silently ignored.
- Continue to pass your values file with `--values <path>`. Do not use `--reuse-values`, because it carries v8 values across and breaks the update.
- Do not set `hdapMigration.rolloutTimeout`. This setting has no effect in this chart.

> [!note] Do not change startup probe settings for a standard update. The rebuild runs in dedicated worker pods, not in `fid-0`, so it does not consume the `fid-0` startup-probe allowance. See [Startup probe settings](#startup-probe-settings).

#### Tune migration timeouts for large stores

The default values work for small and medium stores. For large stores, increase the following values before you start. A timeout that expires mid-step marks the update as failed, even though the work may still be running. For guidance by size, see [Recommended timeout settings](#recommended-timeout-settings).

| Setting | Default | When to change it |
|---|---|---|
| `hdapMigration.scaleDownTimeout` | `300 s` | Pods stop one at a time, and each pod uses its full `terminationGracePeriodSeconds`. If you increased `fid.terminationGracePeriodSeconds`, set this to at least `(replicas × terminationGracePeriodSeconds) + 60`. |
| `hdapMigration.exportTimeout` | `1800 s` | Time allowed for the export, which takes approximately 2 minutes per million entries. Increase it above approximately 10 million entries. |
| `hdapMigration.import.maxTimeout` | `14400 s` | Upper limit for one import attempt. The actual timeout is sized from the export. |
| `hdapMigration.import.maxAttempts` | `3` | Number of import attempts. Each attempt uses more memory than the previous one. |
| `hdapMigration.postUpgradeWait` | `true` | Optional readiness check after the update, enabled by default. Set to `false` to let the update finish as soon as the manifests are applied. See [Optional post-update readiness check](#optional-post-update-readiness-check). |
| `hdapMigration.postUpgradeWaitTimeout` | `1800 s` | How long the readiness check waits for FID to roll out and open every store after the update. Follower nodes re-synchronize within this time, at approximately 1 minute per million entries. Increase it above approximately 10 million entries. |

Example migration configuration:

```
fid:
  # Time Kubernetes allows each node to shut down before it is killed.
  # The shutdown hook closes the stores, and that work shares this budget:
  # a node killed before it finishes leaves its stores closed uncleanly.
  # 0 (the default) omits the field, and Kubernetes applies its own 30s.
  # Raise it for large stores or slow storage - 180 is a reasonable start.
  # Note it is spent in full on every shutdown, and nodes stop one at a
  # time, so scale-down costs roughly replicas x this value.
  terminationGracePeriodSeconds: 180

hdapMigration:
  scaleDownTimeout: 900
  exportTimeout: 7200
  import:
    maxTimeout: 28800
```

### 5. Protect ZooKeeper when using a cluster autoscaler

While RadiantOne is stopped, the Kubernetes nodes appear underutilized, and a cluster autoscaler may remove one, taking a ZooKeeper pod with it. The export requires ZooKeeper connectivity and stops if ZooKeeper is unreachable.

Before you start, either pause autoscaler scale-down for the maintenance window, or mark the ZooKeeper pods as not evictable and confirm that they are spread across nodes:

```
kubectl annotate pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  cluster-autoscaler.kubernetes.io/safe-to-evict=false \
  --overwrite

kubectl get pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  -o wide
```

### 6. Special cases

#### If you use follower-only nodes

If you use follower-only nodes through `fid.followerOnly`, the update automatically removes their data volumes.

After `fid-0` is back on v9, follower nodes rebuild their data from `fid-0`. Include this re-synchronization time in the maintenance window. The update is complete when the follower nodes are ready again.

#### If you deploy with Argo CD

The update Jobs are Helm hooks, which Argo CD runs as `PreSync` and `PostSync` hooks in the same order. Argo CD has no sync timeout, so the sync runs for as long as the update takes.

When deploying through Argo CD, do not use Argo CD sync status to determine whether the update is complete. Instead, check the `fid-hdap-post-upgrade-wait` Job status and the `phase` value in the `fid-hdap-migration-state` ConfigMap.

Argo CD runs the pre-upgrade hook during every sync. After the update completes, the migration Jobs detect that FID is already running v9 and exit without making changes.

The application remains `OutOfSync` until Argo CD prunes obsolete resources. In v9, `sync` replaces `directory-schema`. Helm removes the old component during the update, but Argo CD removes resources no longer defined by the chart only during a pruned sync. Until then, the `directory-schema` pod can continue running its v8.5 image alongside `sync`.

Run another sync with Prune enabled, or remove the obsolete resources manually:

```
NS=self-managed

kubectl -n $NS delete deployment/directory-schema \
  service/directory-schema-service \
  --ignore-not-found

# Only needed if directory-schema ran more than one replica, which adds a disruption budget
kubectl -n $NS delete pdb/fid-directory-schema-pdb \
  --ignore-not-found
```

### 7. Record the pre-upgrade state

Run this once before the update and save the output. Run the same command again after the update to make a direct comparison.

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
   df -h /opt/radiantone/vds | tail -1 | awk "{print \$4\" free\"}"' \
  | tr '\n' ' ')"

echo "version : $(kubectl -n $NS exec fid-0 -c fid -- \
  /opt/radiantone/vds/bin/show_version.sh \
  | grep -E '^RadiantOne [0-9]|Build-Id' \
  | tr -s ' ' \
  | tr '\n' ' ')"

echo "pvcs    : $(kubectl -n $NS get pvc --no-headers \
  | awk '{printf "%s=%s ", $1, $4}')"
```

Example output before an update:

```
release : iddm-helm-1.5.3 (deployed)
fid     : image=radiantone/fid:8.5.3 ready=1/1
zk      : 3/3 ready
pods    : 14/14 Running
stores  : 14 659.8M 7.9G free
version : RadiantOne 8.5.3 Build-Id : ...
pvcs    : r1-pvc-fid-0=10Gi zk-pvc-zookeeper-0=10Gi zk-pvc-zookeeper-1=10Gi zk-pvc-zookeeper-2=10Gi
```

### 8. Apply the update

A single Helm command runs the entire update through automated Kubernetes Jobs. The Jobs stop the nodes, export the data, rebuild the stores, bring the nodes back online, and validate them. See [How the update works](#how-the-update-works).

Run the Helm upgrade command:

```
helm -n self-managed upgrade --install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml> \
  --timeout 4h \
  --wait
```

> [!note]
> Always set `--timeout` to a value at least as long as you expect the whole update to take (see [Update duration](#update-duration)). The default timeout of 5 minutes is far shorter than the export and rebuild.

> [!warning]
> Do not use `--atomic` or `--rollback-on-failure`. Helm 4 renamed `--atomic` to `--rollback-on-failure` and still accepts the old name. Either option reverts the release when the update fails or the timeout expires, while the migration Jobs are still running against the volume. Let the Jobs finish and rerun the command instead. See [Step failure](#step-failure).

If Helm times out, it reports the release as failed, but the migration Jobs continue running in Kubernetes. Do not scale the `fid` StatefulSet manually, and do not start over. Let the Jobs finish, then rerun the same Helm command. See [Troubleshooting](#troubleshooting) for more details.

### 9. Monitor update progress

In a separate terminal, monitor the migration phase and Job logs. For a description of each Job, see [How the update works](#how-the-update-works).

`fid-0` does not exist while the export and rebuild run, so `kubectl logs fid-0` works only before and after those steps.

```
NS=self-managed

kubectl get jobs -n $NS -w

kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'

kubectl logs -f job/fid-hdap-export -n $NS

kubectl logs -f job/fid-hdap-import -n $NS

kubectl get pods -n $NS -w
```

A healthy update, sampled every few seconds (1 million entries, one node), may look like this:

```
+13s   phase=ready-for-export  fid=1/0  scale-down=Running
+59s   phase=ready-for-export  fid=0/0  scale-down=Complete  export=Running
+116s  phase=importing         fid=0/0  export=Complete      import=Running
+299s  phase=completed         fid=0/0  import=Complete      pvc-cleanup=Running
+322s  phase=completed         fid=0/1  pvc-cleanup=Complete  post-upgrade-wait=Running  <- fid-0 is starting
+427s  phase=completed         fid=1/1  post-upgrade-wait=Running
+437s  helm returns: Release "fid" has been upgraded. STATUS: deployed, REVISION: 2
```

After the rebuild, the ZooKeeper pods restart one at a time as their image is updated, and the other services are replaced. A few minutes of pod restarts at this point is normal. To follow the nodes as they come back, see [Restarting the nodes](#restarting-the-nodes).

> [!warning]
> Do not delete pods, scale the StatefulSet, or change values while the update is in progress.

> [!note]
> If a step fails, rerun the same Helm command from Step 8. Completed steps are skipped automatically. See [Step failure](#step-failure).

### 10. Validate the updated deployment

After Helm reports `STATUS: deployed`, verify the deployment:

```
NS=self-managed   # replace with your namespace

# All Running; sync present, directory-schema gone (Argo CD: see Step 6)
kubectl get pods -n $NS

# fid-hdap-post-upgrade-wait must be Complete (Jobs are removed 24 hours after they finish)
kubectl get jobs -n $NS

# completed
kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'

kubectl get statefulset fid -n $NS \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'

kubectl exec fid-0 -n $NS -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list
```

Run the baseline script from Step 7 again and compare the results:

- The number of stores must match.
- The version line must show `9.0.0`.
- The data directory will be larger.

Test access for:

- LDAP
- REST/ADAP
- SCIM
- Control Panel

If you applied the ZooKeeper autoscaler annotation, remove it after validation:

```
kubectl annotate pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  cluster-autoscaler.kubernetes.io/safe-to-evict-
```

Update any monitoring that references `directory-schema` so that it monitors `sync`.

#### Review step durations

Kubernetes retains each Job’s start and completion times for 24 hours after it finishes, then removes the Job. To view the start and completion times:

```
kubectl get jobs -n self-managed -o custom-columns='JOB:.metadata.name,STARTED:.status.startTime,COMPLETED:.status.completionTime,OK:.status.succeeded' | grep -E 'JOB|hdap'
```

If `jq` is installed, you can see the durations in seconds:

```
kubectl get jobs -n self-managed -o json | jq -r \
  '.items[]
   | select(.metadata.name|startswith("fid-hdap"))
   | "\(.metadata.name)\t\(((.status.completionTime|fromdate) - (.status.startTime|fromdate)))s"'
```

To view update summary including the export size, import memory, number of attempts, and verification result, run:

```
kubectl get configmap fid-hdap-migration-state -n self-managed \
  -o jsonpath='{range $k,$v := .data}{$k}={$v}{"\n"}{end}'
```

## Values file reference

This `values.yaml` file contains every setting worth tuning, with the reasoning in the comments. Copy it, replace the placeholders, and adjust the default numbers using the tables in [Sizing and storage recommendations](#sizing-and-storage-recommendations).

```
# Minimal values.yaml with the settings most likely to require tuning.
# Replace the placeholders, then adjust the marked values for your deployment.

replicaCount: 2                      # Number of directory nodes; use 1 for evaluation

fid:
  license: >-
    <YourLicense>

  rootPassword: "<EnterYourRootPw>"

  # --- Shutdown -----------------------------------------------------------
  # Each node closes its stores during shutdown, and this grace period covers
  # that work. Nodes stop one at a time, so a scale-down can take roughly
  # replicaCount x this value. Setting this to 0 omits the field and lets
  # Kubernetes use its default of 30 seconds.
  terminationGracePeriodSeconds: 180

  # --- Start-up allowance -------------------------------------------------
  # The startup budget is periodSeconds x failureThreshold. The default
  # values (20 x 15) allow 5 minutes, which is sufficient for a normal start.
  # Increase failureThreshold only while restoring from a backup below, then
  # restore the normal value because the same budget applies to later restarts.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 15             # 15 = 5 min; 540 = 3 h during restore

  # --- Seed from a backup (initial deployment only) ------------------------
  # Uncomment this to restore from a backup of an existing deployment.
  # Increase failureThreshold above to allow enough time for the restore.
  # Leave this commented out when updating an existing deployment.
  # migration:
  #   url: "https://<host>/<path>/export.zip"

imagePullSecrets:
  - name: regcred

# --- Compute ---------------------------------------------------------------
# Choose values from the sizing table. In production, keep requests equal
# to limits so the pod is less likely to be evicted under node pressure.
resources:
  requests:
    cpu: 4
    memory: 16Gi
  limits:
    cpu: 4
    memory: 16Gi

env:
  INSTALL_SAMPLES: "false"

  # Keep the heap at roughly half the memory limit. The Control Panel, task
  # scheduler, and sync agent run in separate JVMs and share the same limit.
  # The directory stores also depend on the OS page cache for read performance.
  FID_SERVER_JOPTS: "-Xms4g -Xmx8g"

# --- Storage ---------------------------------------------------------------
# storageClass must name a class available on the cluster. Check with
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
# These settings control the Jobs that stop the nodes, export the stores, and
# rebuild them when updating a v8 deployment to v9. They are ignored on a
# fresh install, so this block can safely remain in place. Each value is an
# upper bound: the step completes as soon as it finishes, so a generous value
# does not add to the actual update time.
hdapMigration:
  # Must exceed replicaCount x terminationGracePeriodSeconds above because
  # nodes stop one at a time and may use their full grace period. With the
  # values above, that is 2 x 180 = 360s, so the 300s default would time out.
  scaleDownTimeout: 900

  # Upper bound for the export. Allow roughly two minutes per million entries.
  exportTimeout: 3600

  import:
    # Upper bound for the rebuild, which is typically the longest step.
    # Allow roughly six minutes per million entries. 14400 = 4 hours.
    maxTimeout: 14400

    # Maximum memory and CPU available to the rebuild worker. The worker sizes
    # itself based on the data it finds; increase these values for very large
    # stores.
    maxMemory: 16Gi
    maxCpu: 8

  # Optional readiness check after the rebuild; enabled by default. See
  # "Optional post-update readiness check". The update remains open until every
  # exported store is being served again. Set to false to skip this check.
  postUpgradeWait: true

  # Maximum time to wait for the nodes to restart and report ready. Nodes
  # started after the first must replicate the stores before becoming ready,
  # so the required time increases with both data size and node count.
  postUpgradeWaitTimeout: 1800
```


Confirm that the cluster received the settings you intended:

```
kubectl -n self-managed get statefulset fid \
  -o jsonpath='grace={.spec.template.spec.terminationGracePeriodSeconds}{"\n"}probe={.spec.template.spec.containers[0].startupProbe.periodSeconds}x{.spec.template.spec.containers[0].startupProbe.failureThreshold}{"\n"}resources={.spec.template.spec.containers[0].resources}{"\n"}'
```

Multiply the two probe numbers to get the startup allowance in seconds.

## How the update works

When you run `helm upgrade` to 9.0.0, the chart creates a series of Kubernetes Jobs that run before the new version is applied.

The helper pods that perform the export and the rebuild, and the record the migration keeps of its progress, are tied to the life of the deployment. When the deployment is deleted, Kubernetes removes them with it. Because the record belongs to the deployment, a record left behind by a deployment that no longer exists is ignored rather than trusted, so it cannot prevent a later update from running. The Jobs themselves are removed 24 hours after they finish. See [Removing upgrade artifacts](#removing-upgrade-artifacts).

```
1. fid-hdap-scale-down          Stop the nodes
2. fid-hdap-export              Export the stores (v8 image)
3. fid-hdap-import              Rebuild and verify the stores (v9 image)
4. fid-hdap-pvc-cleanup         Delete follower volumes
   (Helm applies 9.0.0)         Start the nodes on v9
5. fid-hdap-post-upgrade-wait   Check that every store is served (optional)
```

| Step | Job name | Action | Observed behavior |
|---|---|---|---|
| 1 | `fid-hdap-scale-down` | Stops every RadiantOne node, including main and follower-only nodes, and records the replica counts so they can be restored if a later step fails. Pods stop one at a time. | FID pods terminate, and `fid-0` disappears. |
| 2 | `fid-hdap-export` | Starts a worker pod, `fid-hdap-export-worker`, on the current v8 image with the `fid-0` volume mounted. The worker exports every store to LDIF inside a zip file on that volume and records the list of exported stores. | The `fid-hdap-export-worker` pod runs and is then removed. Its output is kept in the Job's log. |
| 3 | `fid-hdap-import` | Starts a worker pod, `fid-hdap-import-worker`, on the v9 image with the same volume mounted. It runs the product updater, which upgrades the installation on the volume and rebuilds every store from the export, and then verifies that each store was converted. This is the longest step. The worker's memory is sized from the export. If the worker runs out of memory, the step retries with more memory, up to `hdapMigration.import.maxAttempts` (default `3`). | The `fid-hdap-import-worker` pod runs for minutes to hours and is then removed. Its output is kept in the Job's log. |
| 4 | `fid-hdap-pvc-cleanup` | Removes the follower-only nodes' volumes so that they re-synchronize from `fid-0` on v9. Nearly instant. | Follower PVCs are deleted. |
| — | Helm applies the new version | The StatefulSet is switched to the `9.0.0` image, and the FID pods start on the rebuilt data. The other services are updated at the same time. | FID pods reappear on the new image. |
| 5 | `fid-hdap-post-upgrade-wait` | Optional readiness check, enabled by default. Fails the update unless the FID pods are running the expected image, are fully rolled out, and are serving every store the export recorded. Runs after the new version is applied. Set `hdapMigration.postUpgradeWait=false` to skip it. It also copies the migration Job logs to the first node's volume under `hdapMigration.logDirectory`. | Completes when FID is serving. |

Progress is recorded in the `fid-hdap-migration-state` ConfigMap. Its `phase` key moves through the following values:

```
ready-for-export → exported → importing → completed
```

The ConfigMap also records the export size, the memory given to the import, the number of import attempts, and the verification result. It is the best place to check where an update is.

Helm waits for all of these Jobs, so `helm upgrade` does not return until the update has finished or failed. This is why the `--timeout` option matters. See [Helm timeout and wait options](#helm-timeout-and-wait-options).

### Optional recovery settings

Two recovery settings are available that a standard update does not require. Both are disabled by default.

- `hdapMigration.postDeleteCleanup` runs a cleanup Job when the deployment is deleted, to remove leftovers from charts earlier than 9.0.0.
- `hdapMigration.import.directImportFallback.enabled` allows the rebuild to run the migration tool directly if the updater leaves stores unconverted.

> [!warning]
> Enable these settings only when Radiant Logic Support instructs you to. A delete-time Job that cannot run prevents Argo CD from deleting the application, and the fallback clears the updater's record of which stores it has already converted.

### Update duration

Downtime runs from the moment the scale-down Job starts until the first node is serving again or, with the optional readiness check enabled, until that check completes. Downtime depends mainly on the number of entries. Adding nodes does not make the export or rebuild faster.

#### Estimated downtime for a three-node cluster

The following planning figures are for a three-node deployment (`fid-0` and two followers) at the default grace period:

| Dataset size | Scale-down | Export | Rebuild / Import | Gate | Total estimated downtime |
|---|---|---|---|---|---|
| Configuration only (fresh install, 13 system stores, less than 1 MB) | 1m 49s | 29s | 2m 09s | 12s | Approximately 5 min |
| 1 million entries | Approximately 3 min | Approximately 3 min | Approximately 8 min | Approximately 3 min | Approximately 17 min |
| 5 million entries | Approximately 3 min | Approximately 11 min | Approximately 32 min | Approximately 8 min | Approximately 55 min |
| 10 million entries | Approximately 3 min | Approximately 21 min | More than 1 hour | Approximately 13 min | Approximately 1h 40m or more |
| 20 million entries | Approximately 3 min | Approximately 41 min | Approximately 2 hours | Approximately 24 min | Approximately 3h 10m |
| 50 million entries | Approximately 3 min | Approximately 1h 40m | Approximately 5 hours | Approximately 1 hour | Approximately 7h 45m |

Scale-down time does not depend on data size. Pods stop one at a time, so scale-down takes roughly `replicas × terminationGracePeriodSeconds`. With one node, scale-down takes less than a minute and the gate approximately two minutes because there are no followers to stop or re-synchronize. The other steps are unchanged.

The **Gate** column is the optional post-update readiness check, enabled by default. It passes when all nodes are ready; with followers, this includes their re-synchronization. The **Total estimated downtime** column includes the full gate.

**Rule of thumb:** Per million entries, allow approximately 2 minutes for export, 6 minutes for rebuild, and 1 minute for follower re-synchronization, plus a few minutes of fixed overhead.

Actual times vary with storage, node size, and store layout. For planning, round up to the next row and set `--timeout` longer than the estimated total. A longer timeout costs nothing; a short timeout can report failure while the work continues.

For more than 10 million entries, measure an update in a lower environment with comparable data before scheduling the production window.


#### Recommended timeout settings

| Entry count | Recommended settings override | Recommended Helm `--timeout` |
|---|---|---|
| Up to 5 million | Defaults | 1h 30m |
| 5–10 million | Defaults | 2h 30m |
| 10–20 million | `exportTimeout: 3600`, `postUpgradeWaitTimeout: 3600` | 4h |
| 20–50 million | `exportTimeout: 10800`, `import.maxTimeout: 28800`, `postUpgradeWaitTimeout: 7200` | 10h |
| Above 50 million | Contact Radiant Logic Support to plan the maintenance window | Not applicable |

### Restarting the nodes

The update is not finished when the rebuild finishes. The nodes come back one at a time, and the followers have work of their own to do:

1. The first node starts and opens every rebuilt store. Until it is ready, nothing is serving.
2. Each remaining node starts in turn. A node joining the cluster replicates the stores from the first node and initializes them locally before it reports ready.

The second step is proportional to the data and runs once per node, so on a deployment with several nodes and large stores it can add substantially to the window. Helm waits for it when the readiness check is enabled (the default) or when you pass `--wait`. With both off, it happens after Helm has already reported the release as updated. Include it when you size the maintenance window, and monitor it:

```
NS=self-managed   # replace with your namespace

# Nodes become ready one at a time; the last one to report ready ends the update
kubectl get pods -n $NS -l app.kubernetes.io/component=fid -w

# What a joining node is doing
kubectl logs fid-1 -n $NS -c fid --tail=50 | grep -Ei "replicat|initializ|Opening index|Loaded with"
```

### Large individual stores

The update sizes the memory it gives the rebuild from the largest single export file it finds. That size comes from the export archive, where a file of 4 GB or more is recorded as a fixed placeholder value rather than its true size. As a result, once any single store's export reaches approximately 4 GB, the rebuild is given the same amount of memory whether that store is 4 GB or much larger.

The rebuild reads its input as a stream and does not need memory proportional to the data, so this is not normally a problem. For example, a 10-million-entry store can rebuild successfully with the memory chosen this way. However, if you are migrating unusually large individual stores and the rebuild fails for memory reasons, set `hdapMigration.import.maxMemory` explicitly rather than relying on the automatic sizing:

```
hdapMigration:
  import:
    maxMemory: 32Gi
```

## Helm timeout and wait options

Helm always waits for the Jobs it runs as hooks, so the update is governed by `--timeout` whether or not you pass anything else. `--wait` is a separate control that decides what happens after the Jobs finish.

| Option | What it does on an update |
|---|---|
| `--timeout` (default `5m0s`) | How long Helm waits for any single operation, including each migration Job. This is the most important option here, because the default is far shorter than the export and rebuild. It limits Helm, not the cluster: when it expires, Helm reports the release as failed while the Jobs continue running. |
| `--wait` | Decides what Helm waits for after the migration Jobs are done. With it, Helm also waits until the server and every microservice report ready before it reports success. Without it, Helm still waits for the readiness check (enabled by default), which holds until every FID node is ready and serving its stores, but the other services may still be starting when the command returns. With the readiness check also turned off, Helm returns while the pods are still starting. |
| `--wait-for-jobs` | Used with `--wait`. The migration Jobs are hooks and are already waited for, so this option changes nothing for this chart. |

> [!note]
> In Helm 4, `--wait` accepts a strategy. Using `--wait` without a value means `watcher`, which waits for every resource. Omitting it means `hookOnly`, which is the hook waiting described above. In Helm 3, `--wait` is a simple on/off flag with the same effect.

### Using the options together

- Pass both options every time: `--timeout`, with the value from [Recommended timeout settings](#recommended-timeout-settings), and `--wait`.
- `--timeout` is a limit per step, not for the whole command. Each migration Job, and the final wait, gets the full value on its own, so the value must outlast the longest step, the rebuild. The values in the table are longer than the whole update, which is the simple, safe choice; a longer value costs nothing. The `4h` value in the examples covers up to approximately 20 million entries.
- `--timeout` only decides how long Helm watches. When it expires, Helm reports the release as failed, but the Jobs keep running. Wait for them to finish and rerun the same command. The timeout never stops or shortens the update.
- `--wait` changes when the command returns and what it checks, not the work the update does. With it, a service that never becomes ready makes Helm report the release as failed once `--timeout` expires. Without it, you may get your prompt back while services are still starting.
- With Argo CD, neither option applies. Argo CD runs the same Jobs as sync hooks and has no sync timeout. See [Step 6](#if-you-deploy-with-argo-cd).

```
helm -n self-managed upgrade --install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml> \
  --timeout 4h \
  --wait
```

## Startup probe settings

For a standard update, no startup probe changes are required. The export and rebuild run in dedicated worker pods that Kubernetes does not health-check. The server pod starts only after the data volume has been converted and normally becomes ready within the default 5-minute startup allowance.

This differs from a new installation restored from a backup. In that scenario, data loading occurs in the server pod and requires a longer startup allowance. For more information, see [Installing RadiantOne Identity Data Management v9](../installation/self-managed-v9.md).

### When to change the default settings

One update scenario requires additional configuration. If you disable the rebuild worker by setting `hdapMigration.import.enabled: false`, the rebuild runs in the server pod during its first startup. The startup allowance must be long enough to accommodate the rebuild. The chart automatically increases the minimum allowance, and you can set a longer allowance explicitly.

| Setting | Startup allowance |
|---|---|
| Default configuration, where the rebuild runs in a worker pod | 5 minutes. No change is required. |
| `hdapMigration.import.enabled: false` | Automatically increased to 1 hour |
| `hdapMigration.firstBootImportBudget: 7200` | Explicitly set to 2 hours |

The automatic minimum is a floor, not a limit. If you configure a larger `fid.startupProbe.failureThreshold`, the chart retains that value. If you configure a smaller value, the chart increases it to the applicable minimum.

The rebuild requires approximately 6 minutes per million entries. The 1-hour minimum therefore supports fewer than 10 million entries. For larger datasets, set `hdapMigration.firstBootImportBudget` to approximately 6 minutes per million entries, plus an additional margin.

Both settings are under their own top-level keys:

```
# Only needed if you turn the rebuild worker off.
# Leave this section out entirely for a normal update.
hdapMigration:
  import:
    enabled: false          # rebuild runs inside the server pod instead
  firstBootImportBudget: 7200   # seconds; 2 hours. Omit to accept the 1-hour floor

fid:
  # Optional. Raises the allowance further; a value below the floor above is ignored.
  startupProbe:
    periodSeconds: 20
    failureThreshold: 540   # 20 x 540 = 10800s = 3 hours

  # Shutdown budget per node. Spent in full every time, and nodes stop one
  # at a time, so scale-down costs roughly replicas x this value.
  terminationGracePeriodSeconds: 180
```

Verify the startup probe applied to the StatefulSet:

```
kubectl -n self-managed get statefulset fid \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe}{"\n"}'
```

To calculate the allowance in seconds, multiply `periodSeconds` by `failureThreshold`. Remove any override after the update is complete, because the same allowance applies to every later restart of that pod.

## Optional post-update readiness check

After the rebuild, the chart runs one more Job, `fid-hdap-post-upgrade-wait`. It holds the update open until the server pods are running the expected image, are fully rolled out, and are serving every store that was exported. Without it, Helm and Argo CD report success as soon as the manifests are applied, while the server may still be reopening stores for several minutes.

The check is enabled by default. The store check runs once, right after the rebuild that recorded the store list, and the list is then cleared from the migration record. Later updates from v9 to v9 therefore wait only for the rollout and do not re-check stores you may have removed since.

Two settings control the check:

```
hdapMigration:
  postUpgradeWait: true          # set false to skip the check
  postUpgradeWaitTimeout: 1800   # seconds to wait for the rollout; the Job's own deadline is this plus 300
```

Increase `postUpgradeWaitTimeout` for large deployments. The wait covers every node, and nodes after the first replicate the stores before they report ready, so the wait grows with the data as well as the node count. If the Job times out, the update itself has still been applied. See [Troubleshooting](#troubleshooting).

Set `postUpgradeWait: false` when you do not want the update command to block on the rollout, for example when something else already monitors readiness. In that case, the Job is not created, and the update ends when the manifests are applied.

When the check is enabled, the Job appears in `kubectl get jobs` and must reach `Complete`. Its log names any store it could not find. It also copies the migration Jobs' logs to the first node's volume under `hdapMigration.logDirectory`.

## Sizing and storage recommendations

An update does not change the resources required for normal day-to-day operation. However, the `fid-0` volume requires additional free space during the update.

### Volume capacity

During the update, the volume contains the existing v8 stores, the exported data, and the rebuilt v9 stores. For example, in a 10-million-entry deployment, 7.5 GB of v8 stores can produce 4.3 GB of exported data and 14.3 GB of v9 stores, so peak usage is approximately 26 GB, or roughly 3.5 times the original size. The rebuilt stores are approximately twice the size of the v8 stores and remain that size.

Check the free space before you start (see [Step 3](#3-check-available-space-on-the-fid-0-volume)). If the volume is more than approximately one third full, expand it first. Expanding the volume requires a storage class with `allowVolumeExpansion: true`.

The following tables repeat the guidance from the installation guide, so that you can confirm the deployment is sized correctly before committing to the update. The [Values file reference](#values-file-reference) already includes these settings; use the tables to choose the numbers that go in it.

### Pod resources

The following figures are starting points rather than fixed limits. Work with your Radiant Logic solutions engineer to confirm them against your own data before production.

| Deployment profile | CPU | Memory | `FID_SERVER_JOPTS` | Volume size |
|---|---|---|---|---|
| Evaluation or development, sample data | 2 | 8Gi | `-Xms2g -Xmx4g` | 10Gi |
| Small production, fewer than approximately 1 million entries | 4 | 16Gi | `-Xms4g -Xmx8g` | 50Gi |
| Medium production, 1–10 million entries | 8 | 32Gi | `-Xms8g -Xmx16g` | 100Gi |
| Large production, more than 10 million entries, or many stores with large groups | 8–16 | 64Gi | `-Xms16g -Xmx32g` | 250Gi or more |

The server is not the only JVM in the pod. The Control Panel, the task scheduler, and the sync agent each have their own heap, and they all draw on the same container memory limit. Set `FID_SERVER_JOPTS` to roughly half the limit, leaving room for the other processes and for the operating system page cache, which the directory stores rely on heavily for read performance. A heap set close to the limit is the most common cause of a pod that restarts repeatedly under load.

Set requests equal to limits for production. Equal values give the pod a guaranteed quality of service, which keeps it from being evicted first when a node comes under pressure.

### Storage classes by platform

The chart requires a storage class that provisions ReadWriteOnce block storage. Class names are site specific, because they are created by whoever built the cluster. The names below are the usual ones, not a guarantee. List the classes your cluster offers:

```
kubectl get storageclass
```

| Cloud platform | Commonly used in production | Used in Radiant Logic compatibility testing |
|---|---|---|
| Amazon EKS | `gp3`, usually created by the cluster administrator; preferred over `gp2` for throughput | `gp2` |
| Azure AKS | `managed-csi` for Standard SSD, or `managed-csi-premium` for Premium SSD | `default` |
| Google GKE | `standard-rwo` for Balanced PD, or `premium-rwo` for SSD | `standard` |
| Oracle OKE | `oci-bv` | `oci-bv` |
| Red Hat OpenShift | Depends on the underlying platform: `gp3-csi` on AWS, `thin-csi` on vSphere, or `ocs-storagecluster-ceph-rbd` with OpenShift Data Foundation | `csi-hostpath-provisioner` (test clusters only) |
| Rancher / RKE2 | `longhorn`, or `local-path` for non-production. RKE2 provides no default storage class, so you must install one and name it explicitly. | — |

Check two properties on the class you choose:

- `allowVolumeExpansion: true`, if you want to grow the volume later without rebuilding. Most managed classes have it; some do not.
- A `volumeBindingMode` of `WaitForFirstConsumer` on multi-zone clusters, so that the volume is created in the same zone as the pod that uses it.

```
kubectl get storageclass <name> -o jsonpath='{.allowVolumeExpansion}{"  "}{.volumeBindingMode}{"\n"}'
```

If `persistence.storageClass` names a class that does not exist, the volume claims stay `Pending` and the pods never start.

## Known limitations

- There is no in-place downgrade.
- Helm's `--timeout` does not stop the update. It only stops Helm from waiting for it.

## Troubleshooting

### Step failure

First, find where the update stopped. The phase value and the Job states tell you which case applies:

```
NS=self-managed

kubectl get jobs -n $NS

kubectl get configmap fid-hdap-migration-state -n $NS -o yaml

kubectl logs job/<job-name> -n $NS | tail -40
```

Replace `<job-name>` with the Job that is not `Complete`.

| Failing step | Typical cause | What happens | What to do |
|---|---|---|---|
| `fid-hdap-scale-down` | Pods did not stop within `scaleDownTimeout`: the grace period multiplied by the number of replicas is longer than the timeout, a pod is stuck on an unreachable node, or a volume will not detach. | Helm fails quickly. RadiantOne is restored on its current version automatically and stays available. Nothing on the volume was changed. | Increase `scaleDownTimeout` to at least `(replicas × grace period) + 60`, and run the same `helm upgrade` again. |
| `fid-hdap-export` | ZooKeeper is unreachable; the worker pod could not start (no node with enough resources, or the volume is still attached elsewhere); there is no free space; or `exportTimeout` expired. | The Job log ends with `ERROR: Worker did not emit EXPORT_OK marker`. RadiantOne is scaled back up on its current version automatically, in approximately five minutes from the failure to the server being ready again. Nothing on the volume was changed, and a partial export is never trusted. | Resolve the cause (see [Common issues](#common-issues)), and run the same `helm upgrade` again. A completed export is kept and reused. |
| `fid-hdap-import` | The rebuild ran out of memory or time on every attempt, or the verification found unconverted stores. | The Job log names the reason, for example `ERROR: import exceeded its ... budget and is still running; stopping it`. RadiantOne is intentionally not restored: the volume now contains the v9 installation, and the chart refuses to start the old image on it. The StatefulSet stays at 0 replicas, and the Job log explains why. | Run the same `helm upgrade` again. This is the supported recovery: the completed export is skipped, the rebuild resumes, and every store is verified before the deployment starts on v9. Attempts are counted across reruns. If the rebuild keeps failing for the same reason, the count eventually reaches `hdapMigration.import.maxAttempts`, and a further rerun stops immediately and reports it. Increase that value and run again, or contact Radiant Logic Support. |
| `fid-hdap-pvc-cleanup` | A follower volume could not be deleted. | The rebuild has succeeded. Only the follower cleanup is outstanding. | Run the same `helm upgrade` again. |
| `fid-hdap-post-upgrade-wait` | RadiantOne did not become ready within `postUpgradeWaitTimeout`, or a store the export recorded was never opened. | The update itself has been applied. If the server was still starting, it finishes coming up a minute or two later and is healthy; the check stopped waiting too early. The Job log states which case applies. | Check the Job's log. If the server is up and serving, run the same `helm upgrade` again. The migration steps are skipped, and only the check runs again. If stores were never opened, do not put the deployment into service, and contact Radiant Logic Support with that log. |
| Helm timeout expired | The `--timeout` value was shorter than the update takes. | The Jobs keep running to completion. The release is reported as failed while the update is actually finishing. If the rebuild had started, the volume is on v9. | Wait for the Jobs to finish (`kubectl get jobs -n self-managed -w`), and then run the same `helm upgrade` with a longer `--timeout`. Everything already completed is skipped. |

#### Recover safely after a rebuild failure

> [!warning]
> Never scale the StatefulSet manually after a failure. If the update fails after the rebuild begins, the StatefulSet can still reference the v8 image. Do not use `kubectl scale` or restart the pods to try to restore v8. The volume has already been converted to v9. Starting the previous StatefulSet can result in a v9 server running with v8 services and Control Panel, even though Kubernetes, Helm, and the pod images still report version 8.5. Rerun the Helm upgrade command instead.

The recovery behavior depends on the point at which the update fails:

* If the failure occurs before the rebuild begins, the chart automatically restores RadiantOne on the current version. The volume remains unchanged. Resolve the issue, then rerun the upgrade.

* If the failure occurs during or after the rebuild, the server remains stopped intentionally because the volume contains v9 data. Starting the previous version against that volume can corrupt the deployment. Resolve the issue, then rerun the same Helm upgrade command.

The readiness check is enabled by default. Keep it enabled for standard updates because it verifies that the server starts and serves all migrated stores. If the check repeatedly fails after you have independently confirmed that the deployment is healthy, disable it by setting `hdapMigration.postUpgradeWait=false`.

### Example of a successful recovery

The following example shows recovery from a failed rebuild. The first rerun of the same Helm command resumed and completed the rebuild. The second rerun completed the remaining migration steps.

```
$ helm -n self-managed upgrade --install fid ... --version 9.0.0 --values values.yaml --timeout 4h
   Release "fid" has been upgraded.            <- returned after 5m37s

$ kubectl logs job/fid-hdap-import -n self-managed | tail
   === updater exit code: 0
   installed after updater: version=9.0.0 build=... migration.version=9.0.0_1
   VERIFY stores=14 converted=14 expected=14 pending=[] missing=[]
   IMPORT_OK
   HDAP import complete and verified.

$ helm -n self-managed upgrade --install fid ... (same command again)
   Release "fid" has been upgraded.            <- returned after 44s

$ kubectl get jobs -n self-managed
   export=Complete import=Complete pvc-cleanup=Complete post-upgrade-wait=Complete
$ kubectl get configmap fid-hdap-migration-state -n self-managed -o jsonpath='{.data.phase}'
   completed
```

After the rebuild succeeds, it is not repeated. The second run completes only the steps that were still outstanding.

### Common issues

| Issue | Cause | Resolution |
|---|---|---|
| `fid-hdap-scale-down` times out with pods still present | Scale-down is sequential, and each pod takes its full grace period; or a pod is stuck in `Terminating` on a `NotReady` node. | If the node is healthy, increase `scaleDownTimeout`. If the node is `NotReady`, resolve the node first. Do not force-delete a RadiantOne pod while its node is only unreachable: if the node returns, two servers would share one volume. See [Diagnostic commands](#diagnostic-commands). |
| Export fails immediately with `Cannot reach ZooKeeper` | A ZooKeeper pod was evicted, often by the cluster autoscaler after RadiantOne stopped. | Wait for ZooKeeper to be `3/3` ready, apply the `safe-to-evict` annotation from [Step 5](#5-protect-zookeeper-when-using-a-cluster-autoscaler), and rerun `helm upgrade`. See [Diagnostic commands](#diagnostic-commands). |
| Worker pod remains `Pending` (`Worker pod stuck in phase`) | No node has the CPU or memory the worker requested, or the volume is still attached to another node (`Multi-Attach`). | A stale attachment clears by itself a few minutes after the old node is gone. Do not delete it manually. See [Diagnostic commands](#diagnostic-commands). |
| Import fails with an out-of-memory message | The largest store in the export needed more memory than the worker was given. | The chart already retries with more memory. If all attempts failed, increase `hdapMigration.import.maxMemory` (and `maxAttempts`), and rerun `helm upgrade`. |
| Rerun reports that the attempt limit has been reached | Attempts are recorded in `fid-hdap-migration-state` and persist across runs. | Increase `hdapMigration.import.maxAttempts` in your values file, and rerun `helm upgrade`. |
| Gate fails with `fid is at 0 replicas after the migration` | The new StatefulSet was not applied, for example because Helm was interrupted between the Jobs and the apply. | Run the same `helm upgrade` again. Do not scale the StatefulSet manually. See [Diagnostic commands](#diagnostic-commands). |
| Gate fails with `exported stores were never opened` | FID started but is not serving some of the migrated data. | Contact Radiant Logic Support with both logs before serving traffic. See [Diagnostic commands](#diagnostic-commands). |
| All components report 8.5, but the server reports 9.0 | The volume was rebuilt, and the previous image was then started on it manually. | Run `helm upgrade` to 9.0.0 to complete the update. The services and image then match the installation. |
| Control Panel or services return `401` after the update | Usually an incorrectly entered password. The update does not change credentials. | Read the password from the secret (see [Installing RadiantOne Identity Data Management v9](../installation/self-managed-v9.md)) and retry. |
| After reverting to v8, every pod is running except the RadiantOne server, which is missing entirely | A volume claim was still being deleted when the chart was reinstalled, because a leftover migration worker pod was still mounting it. | Delete the leftover pod. The claim is then released within seconds. Uninstall and reinstall the chart so that the StatefulSet creates the pod with a new claim. See [Diagnostic commands](#diagnostic-commands). |
| Monitoring alerts that `directory-schema` is missing | The component was renamed to `sync` in v9. | Update the check. See [Step 4](#4-update-the-values-file). |

#### Diagnostic commands

Set the namespace before running these commands:

```
NS=self-managed
```

**`fid-hdap-scale-down` times out with pods still present**

Inspect the remaining pod and the node it runs on:

```
kubectl get pod fid-N -n $NS -o jsonpath='{.metadata.deletionTimestamp} {.spec.nodeName}{"\n"}'
kubectl get node <node>
kubectl describe pod fid-N -n $NS | tail -20
```

**Export fails with `Cannot reach ZooKeeper`**

Check where the ZooKeeper pods are running and review recent events in the namespace:

```
kubectl get pods -n $NS -l app.kubernetes.io/name=zookeeper -o wide
kubectl get events -n $NS --sort-by=.lastTimestamp | tail -20
```

**Worker pod remains `Pending`**

Inspect the worker pod and check for a stale volume attachment:

```
kubectl describe pod fid-hdap-export-worker -n $NS | tail -20
kubectl get volumeattachment | grep <pvc-name>
```

**Gate fails with `fid is at 0 replicas`**

Check the image and replica count on the StatefulSet:

```
kubectl get statefulset fid -n $NS -o jsonpath='{.spec.template.spec.containers[0].image} {.spec.replicas}'
```

**Gate fails with `exported stores were never opened`**

Collect both logs to send to Radiant Logic Support:

```
kubectl logs job/fid-hdap-post-upgrade-wait -n $NS
kubectl logs fid-0 -n $NS -c fid | grep -i -E 'error|exception' | tail -20
```

**RadiantOne server is missing after reverting to v8**

```
kubectl -n $NS describe statefulset fid | tail -5     # "pvc ... is being deleted"
kubectl -n $NS get pvc                               # a claim stuck in Terminating
kubectl -n $NS delete pod --field-selector=status.phase==Succeeded
```

After the leftover pod is removed, the claim is released within seconds. Then uninstall and reinstall the chart so that the StatefulSet creates the pod with a new claim.

### Log locations

- **Rebuild worker logs:** The helper pod that performs the rebuild is removed as soon as the rebuild succeeds, so nothing is left holding the RadiantOne volume claim. Before it is removed, its full log is written to the volume under `/opt/radiantone/vds/work/hdap-migration/`, and the logging sidecar ships it after RadiantOne is back up. If you see a pod named `fid-hdap-import-worker` or `fid-hdap-export-worker` after an update has finished, that step did not complete. Treat it as a failure and read its log rather than deleting it.
- **Job output:** View using `kubectl logs job/<name> -n self-managed`. The export and import Jobs also stream their worker pod's output into their own log, so you do not need to catch the worker pod before it is removed.
- **Job retention:** Kubernetes keeps the Jobs and their logs for 24 hours after each Job finishes (`hdapMigration.job.ttlSecondsAfterFinished`, default `86400`), and then removes them. Collect the log of a failed Job within that window. A value of `0` or `null` keeps the Jobs instead. Values below 300 seconds are rejected, because a shorter time can remove a Job before Helm or Argo CD has read its result.
- **Update summary:** The sizes, memory, attempts, and verification result are in the `fid-hdap-migration-state` ConfigMap.
- **Server runtime logs:** View with `kubectl logs fid-0 -n self-managed -c fid`, or inspect the files under `/opt/radiantone/vds/vds_server/logs/` in the pod (`vds_server.log`, `vds_events.log`).

## Removing upgrade artifacts

Deleting a v9 deployment through `helm uninstall` or by deleting its Argo CD application can leave migration-related hook objects in the namespace. Helm and Argo CD do not remove these objects because they are created by hooks rather than managed as regular deployment resources.

The remaining objects can include:

- The migration ServiceAccount, Role, and RoleBinding: `fid-hdap-migration-sa`, `fid-hdap-migration-role`, and `fid-hdap-migration-rb`. They are also delete-time hooks, so the deletion itself creates them again at the end.
- The finished Jobs `fid-hdap-scale-down`, `fid-hdap-export`, `fid-hdap-pvc-cleanup`, `fid-hdap-import`, and `fid-hdap-post-upgrade-wait`. Kubernetes removes these by itself 24 hours after they finish.
- Only when the generic lifecycle hooks are enabled (`hooks.hooks_sa.enabled`): their ServiceAccount `fid-hook-account` and the Role and RoleBinding `fid-manage-pods`, which are hooks in the same way.

The migration record (`fid-hdap-migration-state`) and any export or import helper pod belong to the deployment and are deleted with it. A record written by a chart earlier than 9.0.0 may not be deleted; if it is still present, delete it by name.

To remove the leftovers immediately, run the following after the deletion has finished:

```
NS=self-managed   # replace with your namespace

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

# Only if hooks.hooks_sa.enabled was set
kubectl -n $NS delete --ignore-not-found \
  serviceaccount/fid-hook-account \
  role/fid-manage-pods \
  rolebinding/fid-manage-pods

# Nothing of the release should be listed
kubectl -n $NS get serviceaccount,role,rolebinding,job,configmap,pod \
  -l app.kubernetes.io/instance=fid
```

> [!warning]
> Do not run these commands while the deployment is still installed. The next update creates the objects again anyway, and deleting a migration Job that is still running stops the update.

None of these commands removes the volume claims. To empty the namespace completely, see [Clear the namespace](#1-clear-the-namespace).

## Reverting to v8

A v9 deployment cannot be converted back, and a 9.x backup cannot be restored into an 8.x deployment. To revert to v8, create a new v8 deployment and restore the backup taken before the update. Do not delete that backup until you have accepted the v9 deployment.

Confirm what the backup contains before relying on it. A backup taken without `rli.migration.hdap.all` contains configuration only. Persistent caches must be re-initialized in any case, and configuration or data changes made after the backup are not included.

### 1. Clear the namespace

Both routes below start from an empty namespace, and one step is easy to miss. Any pod that still mounts the RadiantOne volume keeps its claim alive: `kubectl delete pvc` appears to hang, and the claim stays in `Terminating` indefinitely. Nothing warns you about this, and the consequence is subtle. The reinstall brings up every microservice and ZooKeeper normally, but the RadiantOne server pod is never created, because Kubernetes refuses to create a pod whose claim is being deleted. A successful update no longer leaves such a pod behind, but an update that failed partway can leave its export or import helper pod running, so check before deleting the claims.

```
NS=self-managed

# 1. Remove the release.
helm -n $NS uninstall fid

# 2. Remove what the update leaves behind, and any helper pod still holding the volume.
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

kubectl -n $NS get pods            # nothing should remain

# 3. Delete the claims.
kubectl -n $NS delete pvc --all

kubectl -n $NS get pvc             # must return "No resources found" before you continue
```

> [!warning]
> Do not reinstall until the claims are fully deleted. If `kubectl get pvc` still lists a claim in `Terminating`, find the pod that is still holding it and remove that pod first:

```
kubectl -n $NS get pods -o json | jq -r \
  '.items[]
   | select(.spec.volumes[]?.persistentVolumeClaim.claimName=="r1-pvc-fid-0")
   | .metadata.name'
```

If you reinstall while the PVC is still being deleted, supporting services can start normally but the RadiantOne server pod is not created. The StatefulSet reports that the PVC is still deleting:

```
kubectl -n $NS describe statefulset fid | tail -5
#   Warning  FailedCreate  Create Pod fid-0 in StatefulSet fid failed error: pvc r1-pvc-fid-0 is being deleted
```

### 2. Reinstall v8 and restore the backup

Host `pre-v9-backup.zip` at an HTTP or HTTPS URL that the cluster can access, such as an internal web server or object storage location.

The URL must not contain an `&` character. The v8 chart passes the URL to a shell command without quotation marks, so an `&`, such as one in a pre-signed S3 URL, interrupts the download.

Install the v8 chart version that matches the version used to create the backup. Install it in either a new namespace or the namespace cleared in the previous step, and set `fid.migration.url` to the backup archive URL:

```
fid:
  migration:
    url: "https://files.example.com/pre-v9-backup.zip"
```

```
kubectl create namespace self-managed-v8

kubectl apply -n self-managed-v8 -f regcred.yaml

helm -n self-managed-v8 install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 1.5.3 \
  --values </path/to/your/v8-values.yaml>
```

Verify that the backup archive was downloaded successfully before using the deployment. The restore process does not report a download failure. If the downloaded file is not a valid ZIP archive, the deployment can start without restored data and without reporting an error:

```
kubectl exec -n self-managed-v8 fid-0 -- \
  unzip -l /migrations/export.zip | tail -3
```

Confirm that the RadiantOne server pod was created. This step catches the problem described in [Clear the namespace](#1-clear-the-namespace):

```
NS=self-managed-v8   # the namespace you installed v8 into

kubectl -n $NS get pods | grep fid-
kubectl -n $NS get pvc
```

Then complete the following tasks:

1. Wait until all pods are running and ready.
2. Reinitialize persistent caches, restore any data not included in the backup archive, and reapply configuration changes made after the backup was created.
3. Verify entry counts and spot-check known DNs in each store. Test Control Panel access and LDAP, REST/ADAP, and SCIM endpoints.
4. Redirect clients to the restored v8 deployment and update any OIDC callback URLs.
5. Retain the v9 namespace until you have validated and accepted the v8 deployment.

## Release notes and support

For v9 improvements and fixes, see the [v9.0 release notes](../maintenance/v9release-notes/v9.0-release-notes-temp/).

For known issues reported after release, see the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues).

To report problems or provide feedback, use [Radiant Logic Support](https://support.radiantlogic.com). If you do not have a Support login, contact [support@radiantlogic.com](mailto:support@radiantlogic.com).
