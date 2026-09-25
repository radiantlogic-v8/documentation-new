---
title: Updating to v9 Self-managed Deployment
description: Learn how to update an existing v8 self-managed RadiantOne Identity Data Management to v9.0.0.
---

# Overview 

This guide explains how to update an existing self-managed RadiantOne Identity Data Management v8 deployment to v9.0.0. It describes the update process, expected duration, recovery steps for failed updates, and how to return to v8 if necessary.

To install Identity Data Management 9.0.0 on a new cluster, see [Installing RadiantOne Identity Data Management v9](../installation/self-managed-v9.md).

## Before you begin

This update is not an image-only update. Version 9 moves the platform from Java 8 to Java 25 and changes the storage engine from Lucene 6 to Lucene 10. Because the v8 engine cannot read Lucene 10 indexes, every RadiantOne Directory store must be exported from v8 and rebuilt in v9.

All RadiantOne nodes are stopped for the full update window. Schedule a maintenance window and create a backup before starting the update. Retain the backup until you accept the v9 deployment.

> **Warning:** After the rebuild starts, the data volume is converted to v9 and cannot be used with v8. To return to v8, create a new v8 deployment and restore the backup created during preparation.


## How the update works

When you run `helm upgrade` to version `9.0.0`, the chart runs Kubernetes Jobs that complete the migration before the v9 rollout completes.

| Step | Job | What it does | What you see |
|---|---|---|---|
| 1 | `fid-hdap-scale-down` | Stops all RadiantOne nodes and records replica counts. | `fid` pods terminate and `fid-0` disappears. |
| 2 | `fid-hdap-export` | Exports every store to LDIF files in a ZIP archive on the `fid-0` volume. | An export worker pod runs and is then removed. |
| 3 | `fid-hdap-import` | Upgrades the installation on the volume and rebuilds every store from the export. | An import worker pod runs for minutes or hours. |
| 4 | `fid-hdap-pvc-cleanup` | Deletes follower-only node volumes. | Follower PVCs are deleted. |
| — | *Helm applies the new version* | *Updates the StatefulSet to the `9.0.0` image and updates the other services.* | *`fid` pods reappear with the new image.* |
| 5 | `fid-hdap-post-upgrade-wait` | Confirms that the pods use the expected image and serve every exported store. | The Job completes when Identity Data Management is serving all stores. |

The following details apply to the migration steps:

- Step 1 stops both main and follower-only nodes. Replica counts are recorded so they can be restored if a later step fails. Pods stop one at a time.
- The export worker in step 2 (`fid-hdap-export-worker`) runs on the current v8 image and mounts the `fid-0` volume. It records the list of exported stores. After the pod is removed, its output remains in the Job log.
- Step 3 is the longest step. The import worker (`fid-hdap-import-worker`) runs on the v9 image with the same volume mounted, runs the product updater, and verifies that each store was converted. Worker memory is sized from the export. If the worker runs out of memory, the step retries with more memory, up to `hdapMigration.import.maxAttempts`, which defaults to `3`. The pod remains in `Completed` state after completion.
- Follower-only volumes are deleted in step 4 so that the followers can re-synchronize from `fid-0` after the v9 deployment starts.
- Step 5 is the readiness gate. It also confirms that the rollout has fully completed.

Use the `fid-hdap-migration-state` ConfigMap to monitor update progress. Its `phase` value progresses through:

```
ready-for-export → exported → importing → completed
```

The ConfigMap records export size, import memory, import attempts, and the verification result. Check it first to determine update progress or investigate a failure.

Helm waits for all update Jobs. The `helm upgrade` command does not return until the update succeeds or fails. Set `--timeout` appropriately, as described in [Applying the update](#applying-the-update).

## Prepare for the update

### 1. Confirm the current version

Confirm that the existing deployment runs version 8.5.0 or later:

```
helm -n self-managed list
```

```
kubectl get statefulset fid -n self-managed \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Deployments earlier than 8.5.0 must first be updated to version 8.5.0 or later within the v8 release line. Use the v8 chart-version mapping. For example, use `--version 1.5.3` for Identity Data Management 8.5.3.

The v9 update does not start from an earlier source version. Confirm that the v8 deployment is healthy before continuing.

### 2. Back up configuration and data

Run an export from the `fid-0` pod. The `rli.migration.hdap.all` argument includes RadiantOne Directory stores. Without this argument, the backup contains configuration only.

```
kubectl exec -it -n self-managed fid-0 -- \
  /opt/radiantone/migrate.sh export pre-v9-backup.zip rli.migration.hdap.all
```

The export file is created at:

```
/opt/radiantone/vds/work/pre-v9-backup.zip
```

Copy the file from the cluster and confirm that it is a valid ZIP archive. Retain it until you accept the v9 deployment.

```
kubectl cp -n self-managed \
  fid-0:/opt/radiantone/vds/work/pre-v9-backup.zip \
  ./pre-v9-backup.zip
```

```
unzip -l ./pre-v9-backup.zip | tail -3
```

### 3. Optionally snapshot volumes

Kubernetes provides a standard, storage-independent snapshot API through the `VolumeSnapshot` resource in `snapshot.storage.k8s.io/v1`. It works with storage drivers that support snapshots, including AWS EBS, Azure Disk, Google Persistent Disk, Ceph, Longhorn, vSphere, and NetApp.

Use the same procedure for each supported storage driver. Set the provider-specific driver name in the `VolumeSnapshotClass`.

A pre-update snapshot of the RadiantOne volumes provides an additional recovery option. It does not replace the backup. Restoring snapshots requires a manual v8 chart installation that uses the restored volumes.

Check whether your cluster supports volume snapshots:

```
kubectl api-resources | grep volumesnapshot
```

```
kubectl get pods -A | grep snapshot-controller
```

```
kubectl get volumesnapshotclass
```

Your cluster requires all of the following:

1. Volume snapshot API custom resource definitions.
2. A snapshot controller.
3. A `VolumeSnapshotClass` for the storage driver.

If `kubectl get volumesnapshotclass` returns no results, snapshot resources can be created but never become ready. Identify the driver that provisions the RadiantOne volume, then ask your cluster administrator to create a `VolumeSnapshotClass` for that driver. Many managed platforms include one already.

```
kubectl get pvc -n self-managed r1-pvc-fid-0 \
  -o jsonpath='{.spec.storageClassName}{"\n"}'
```

```
kubectl get storageclass <that-class> \
  -o jsonpath='{.provisioner}{"\n"}'
```

```
kubectl get csidriver
```

Example `VolumeSnapshotClass`:

```
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: radiantone-snapshots
driver: <driver-name-from-the-previous-command>
deletionPolicy: Delete
```

| Storage | Driver name |
|---|---|
| AWS EBS | `ebs.csi.aws.com` |
| Azure Disk | `disk.csi.azure.com` |
| Google Persistent Disk | `pd.csi.storage.gke.io` |
| Ceph RBD (Rook) | `rook-ceph.rbd.csi.ceph.com` |
| Longhorn | `driver.longhorn.io` |
| vSphere | `csi.vsphere.vmware.com` |

Snapshot the `fid-0` volume and ZooKeeper volumes together. A consistent restore requires both because RadiantOne stores part of its configuration in ZooKeeper. Restoring the `fid-0` volume while retaining post-update ZooKeeper data does not restore a clean v8 state.

Apply the same label to all snapshots so that they are easy to find and remove together:

```
kubectl get pvc -n self-managed
```

Expected claim names include `r1-pvc-fid-0` and `zk-pvc-zookeeper-0`, `zk-pvc-zookeeper-1`, and `zk-pvc-zookeeper-2`.

```
for PVC in r1-pvc-fid-0 zk-pvc-zookeeper-0 zk-pvc-zookeeper-1 zk-pvc-zookeeper-2; do
cat <<EOF | kubectl apply -n self-managed -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: pre-v9-$PVC
  labels:
    radiantone.io/snapshot-set: pre-v9
spec:
  volumeSnapshotClassName: <your-VolumeSnapshotClass>
  source:
    persistentVolumeClaimName: $PVC
EOF
done
```

Wait until all snapshots show `READYTOUSE=true`:

```
kubectl get volumesnapshot -n self-managed \
  -l radiantone.io/snapshot-set=pre-v9
```

Snapshot completion can take several minutes, depending on the storage backend and volume size. Do not start the update until every snapshot is ready.

### 4. Check free space

During the update, the persistent volume holds:

- Existing v8 stores
- The export archive
- LDIF files extracted from the export
- Rebuilt v9 stores

The v9 stores are larger than the v8 stores — roughly twice the size, in measured runs. Plan for free space of at least three and a half times the current size of the data directory, and expand the volume before starting the update if necessary.

For example, in a measured 10-million-entry update, 7.5 GB of v8 stores produced a 4.3 GB export and 14.3 GB of v9 stores, for a peak usage of about 26 GB — roughly three and a half times the original.

```
kubectl exec -n self-managed fid-0 -- sh -c \
  'du -sh /opt/radiantone/vds/vds_server/data; df -h /opt/radiantone/vds'
```

### 5. Update values.yaml

Update values.yaml before running the v9 upgrade:

- Remove `image.tag`. In v9, the image version comes from `--version`. A remaining value such as `image.tag: "8.5.x"` causes the chart to render the old image and prevents the update from proceeding.
- If values.yaml contains a `directorySchema` section, rename it to `globalSync`. The component is now named `sync`. The chart does not apply settings that remain under `directorySchema` and does not report that they were ignored.
- Provide values.yaml by using `--values`.
- Do not use `--reuse-values`. It carries v8-era values into the v9 update and prevents the update from completing.
- Do not set `hdapMigration.rolloutTimeout`. This setting has no effect in this chart.

#### Configure timeouts

The default timeout values are suitable for small and medium stores. For large stores, increase the following values before starting the update. If a timeout expires during a step, the update is marked as failed even if the work continues.

| Setting | Default |
|---|---|
| `hdapMigration.scaleDownTimeout` | 300 seconds |
| `hdapMigration.exportTimeout` | 1800 seconds |
| `hdapMigration.import.maxTimeout` | 14400 seconds |
| `hdapMigration.import.maxAttempts` | 3 attempts |
| `hdapMigration.postUpgradeWaitTimeout` | 1800 seconds |

When to change them:

- **`scaleDownTimeout`** — Pods stop one at a time and each uses its entire `terminationGracePeriodSeconds`. If you increase `fid.terminationGracePeriodSeconds`, set this to at least `replicas × terminationGracePeriodSeconds + 60`.
- **`exportTimeout`** — Time allowed for export, which takes about 2 minutes per million entries. Raise it above roughly 10 million entries.
- **`import.maxTimeout`** — Maximum time allowed for one import attempt. The chart sizes the actual timeout from the export.
- **`import.maxAttempts`** — Number of import attempts. Each attempt has more memory than the previous attempt.
- **`postUpgradeWaitTimeout`** — Time allowed for the readiness gate to wait for Identity Data Management to roll out and open every store. Followers re-synchronize within this time too, at about a minute per million entries. Raise it above roughly 10 million entries.

Example timeout configuration:

```
hdapMigration:
  scaleDownTimeout: 900
  exportTimeout: 7200
  import:
    maxTimeout: 28800
```

> **If you turn off the rebuild worker.** A normal update needs no change to `fid.startupProbe` — the export and rebuild run in separate worker pods that Kubernetes does not health-check, and the server pod starts afterward, on an already-converted volume, within the default five-minute startup allowance. The exception is `hdapMigration.import.enabled: false`, which moves the rebuild inside the server pod on its first boot instead. If you use that setting, also raise `hdapMigration.firstBootImportBudget` (seconds) to about six minutes per million entries plus a margin, and confirm `fid.startupProbe.periodSeconds × failureThreshold` covers it. Remove any override once the update completes, since the same allowance then applies to every later restart of that pod.

### 6. Protect ZooKeeper from autoscaling

If the cluster uses a cluster autoscaler, protect ZooKeeper during the update.

While RadiantOne is stopped, cluster nodes can appear underused. An autoscaler might remove a node that hosts a ZooKeeper pod. The export requires ZooKeeper to be available and stops if ZooKeeper is unavailable.

Before starting the update, either pause scale-down for the maintenance window or prevent ZooKeeper pods from being evicted. Also confirm that ZooKeeper pods are distributed across nodes.

```
kubectl annotate pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  cluster-autoscaler.kubernetes.io/safe-to-evict=false \
  --overwrite
```

```
kubectl get pod -n self-managed \
  -l app.kubernetes.io/name=zookeeper \
  -o wide
```

### 7. Account for follower nodes

If you use follower-only nodes through `fid.followerOnly`, their volumes are deleted during the update. After `fid-0` starts in v9, the follower-only nodes rebuild their data by synchronizing from `fid-0`.

Include this re-synchronization time in the maintenance window. The update is complete when followers are ready.

### 8. If you deploy with Argo CD

The update Jobs are Helm hooks. Argo CD runs them as `PreSync` and `PostSync` hooks in the same order.

Argo CD does not impose a sync timeout, so synchronization runs as long as the update requires. Note the following behavior:

- Hook Jobs remain `OutOfSync` after synchronization. Do not use an Argo CD `Synced` status as the indicator that the update completed.
- Use the readiness-gate Job and the migration `phase` value to determine whether the update is complete.
- A pre-upgrade hook runs for every Argo CD sync, including the initial sync.

The application also stays `OutOfSync` after a successful update for a related reason: the 9.0 chart replaces the old `directory-schema` component with `sync`, and Helm removes `directory-schema` as part of the update, but Argo CD only deletes objects that are no longer in the chart when a sync prunes. Until then, the old `directory-schema` pod keeps running its 8.5 image alongside `sync`. Clear it by syncing once more with **Prune** selected, or by deleting the objects directly:

```
NS=self-managed
kubectl -n $NS delete deployment/directory-schema service/directory-schema-service --ignore-not-found
# only if directory-schema ran more than one replica, which adds a disruption budget
kubectl -n $NS delete pdb/fid-directory-schema-pdb --ignore-not-found
```

## Record the current state

Before starting the update, run the following command and retain the output. Run the same command after the update to compare the deployments.

```
NS=self-managed

echo "release : $(helm -n $NS list | awk '$1=="fid"{print $9" ("$8")"}')"
echo "fid     : $(kubectl -n $NS get sts fid -o jsonpath='image={.spec.template.spec.containers[0].image} ready={.status.readyReplicas}/{.spec.replicas}')"
echo "zk      : $(kubectl -n $NS get pods -l app.kubernetes.io/name=zookeeper --no-headers | awk '{r+=($2=="1/1")} END{print r"/"NR" ready"}')"
echo "pods    : $(kubectl -n $NS get pods --no-headers | grep -v Completed | awk '{t++; if($3=="Running") r++} END{print r"/"t" Running"}')"
echo "stores  : $(kubectl -n $NS exec fid-0 -c fid -- sh -c 'ls -1 /opt/radiantone/vds/vds_server/data | wc -l; du -sh /opt/radiantone/vds/vds_server/data | cut -f1; df -h /opt/radiantone/vds | tail -1 | awk "{print \$4\" free\"}"' | tr '\n' ' ')"
echo "version : $(kubectl -n $NS exec fid-0 -c fid -- /opt/radiantone/vds/bin/show_version.sh | grep -E '^RadiantOne [0-9]|Build-Id' | tr -s ' ' | tr '\n' ' ')"
echo "pvcs    : $(kubectl -n $NS get pvc --no-headers | awk '{printf "%s=%s ", $1, $4}')"
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

## Applying the update

> **Warning:** After the import job starts, do not manually scale or restart the v8 StatefulSet. The data volume has been converted to v9. If the update fails, correct the issue and rerun the same upgrade command.

Run the following command:

```
helm -n self-managed upgrade --install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 9.0.0 \
  --values </path/to/your/values.yaml> \
  --timeout 4h --wait
```

### Always set --timeout

Helm's default timeout is five minutes, which is much shorter than the export and rebuild steps.

Set `--timeout` to at least the expected duration of the entire update. See [How long the update takes](#how-long-the-update-takes) for guidance.

If Helm times out, it marks the release as failed, but the update Jobs continue running. Do not manually scale the StatefulSet or restart the update. See [If a step fails](#if-a-step-fails).

### How --timeout and --wait work together

Helm always waits for the Jobs it runs as hooks, so the update is governed by `--timeout` whether or not you pass anything else. `--wait` is a separate control that decides what happens *after* the Jobs finish.

| Flag | What it does on an update |
|---|---|
| `--timeout` (default `5m0s`) | How long Helm waits for any single operation, including each migration Job. This is the one that matters most: the default is far shorter than the export and rebuild. It limits Helm, not the cluster — when it expires, Helm reports the release failed while the Jobs carry on running. |
| `--wait` | Decides what Helm waits for once the migration Jobs are done. With it, Helm also waits until the server and every microservice report ready before it reports success. Without it, Helm still waits for the readiness gate (on by default), which holds until every `fid` node is ready and serving its stores — but the other services may still be starting when the command returns. In Helm 4, `--wait` alone means `watcher` (wait for every resource); omitting it means `hookOnly` (the hook-waiting behavior above). In Helm 3 it is a plain on/off flag with the same effect. |
| `--wait-for-jobs` | Used with `--wait`. The migration Jobs are hooks and are already waited for, so this changes nothing for this chart. |

Pass both `--timeout` (sized from [How long the update takes](#how-long-the-update-takes)) and `--wait` every time. `--timeout` is a limit per step, not for the whole command — each migration Job, and the final wait, gets the full value on its own, so it only needs to outlast the longest step, the rebuild.

With Argo CD, neither flag applies: Argo CD runs the same Jobs as sync hooks and has no sync timeout. See [If you deploy with Argo CD](#8-if-you-deploy-with-argo-cd).

> **Do not use `--atomic` or `--rollback-on-failure`.** These are the same option — Helm 4 renamed `--atomic` to `--rollback-on-failure` and still accepts the old name with a deprecation warning. Either one rolls the release back when the update fails or the timeout expires. On this update that means rolling back while the migration Jobs are still running against the volume. Let the Jobs finish and re-run the same command instead; see [If a step fails](#if-a-step-fails).

## Monitor progress

Use a second terminal to monitor the update.

`fid-0` does not exist while export and rebuild are running. Therefore, `kubectl logs fid-0` works only before and after these steps.

```
NS=self-managed
```

```
kubectl get jobs -n $NS -w
```

```
kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'
```

```
kubectl logs -f job/fid-hdap-export -n $NS
```

```
kubectl logs -f job/fid-hdap-import -n $NS
```

```
kubectl get pods -n $NS -w
```

A healthy update for one node and one million entries can appear as follows:

```
+13s   phase=ready-for-export  fid=1/0   scale-down=Running
+59s   phase=ready-for-export  fid=0/0   scale-down=Complete  export=Running
+116s  phase=importing         fid=0/0   export=Complete      import=Running
+299s  phase=completed         fid=0/0   import=Complete      pvc-cleanup=Running
+322s  phase=completed         fid=0/1   pvc-cleanup=Complete post-upgrade-wait=Running   <- fid-0 is starting
+427s  phase=completed         fid=1/1   post-upgrade-wait=Running
+437s  helm returns: Release "fid" has been upgraded. STATUS: deployed, REVISION: 2
```

After the rebuild, ZooKeeper pods restart one at a time as their images update. Other services are also replaced. Expect several minutes of pod changes at this stage.

Do not delete pods, scale the StatefulSet, or change values while the update is in progress.

## How long the update takes

Downtime begins when the scale-down Job starts and ends when the readiness gate completes (or, with the gate turned off, when the first node is serving again).

Duration depends mainly on the number of entries, not node count — adding nodes does not make export or rebuild faster. It does depend on how many nodes there are to restart: after the rebuild, each node comes back one at a time, and every node after the first replicates the stores from the first node before it reports ready. That step is proportional to the data and runs once per node, so on a deployment with several nodes and large stores it can add substantially to the window. Helm waits for it when the readiness gate is on (the default) or you pass `--wait`; with both off, it happens after Helm has already reported the release updated.

The table below plans for a three-node deployment (`fid-0` plus two followers) at the default `terminationGracePeriodSeconds`:

| Deployment | Scale-down | Export | Rebuild | Gate | Total downtime | Basis |
|---|---:|---:|---:|---:|---:|---|
| Configuration only, fresh install, 13 system stores, less than 1 MB | 1m 49s | 29s | 2m 09s | 12s | ≈5 min | measured |
| 1 million entries | ~3 min | ~3 min | ~8 min | ~3 min | about 17 min | estimated |
| 5 million entries | ~3 min | ~11 min | ~32 min | ~8 min | about 55 min | estimated |
| 10 million entries | ~3 min | ~21 min | more than 1 hour | ~13 min | about 1 h 40 min, or more | rebuild measured on a customer data set (ten stores of a million entries each); other steps derived from it |
| 20 million entries | ~3 min | ~41 min | ~2 hours | ~24 min | about 3 h 10 min | estimated |
| 50 million entries | ~3 min | ~1 h 40 min | ~5 hours | ~1 hour | about 7 h 45 min | estimated |

Scale-down time does not depend on data size. Pods stop sequentially, and each can use its full `terminationGracePeriodSeconds`, so allow roughly:

`{replicas} * {termination grace period}`

For a single-node deployment, scale-down usually takes under one minute and the gate takes about two minutes. There are no follower nodes to stop or re-synchronize.

These estimates are based on a test in which rebuilding 10 million entries across 10 stores took more than one hour. Approximate time per 1 million entries:

- Export: 2 minutes
- Rebuild: 6 minutes
- Follower re-synchronization: 1 minute


Choose the row closest to your entry count, rounding up, and set `--timeout` higher than the total estimate. A longer timeout has no cost; a shorter one can report failure while work continues.
Faster storage, larger nodes, and fewer larger stores can reduce the actual time. All estimates except the configuration-only row are approximate. For more than 10 million entries, test with comparable data in a lower environment before scheduling production. Use the following estimates to plan the update window:

| Entries | Recommended settings | `--timeout` |
|---|---|---|
| Up to 5 million | Defaults | 1 h 30 min |
| 5–10 million | Defaults | 2 h 30 min |
| 10–20 million | `exportTimeout: 3600`, `postUpgradeWaitTimeout: 3600` | 4 hr |
| 20–50 million | `exportTimeout: 10800`, `import.maxTimeout: 28800`, `postUpgradeWaitTimeout: 7200` | 10 hr |
| More than 50 million | Contact Radiant Logic Support to plan the maintenance window | — |

Validate timing in a lower environment with representative data before scheduling a production update.

> Monitor node restarts after the rebuild. Completing the rebuild does not complete the update. The first node must start and open all rebuilt stores before it can serve traffic. The remaining nodes then start one at a time, replicate and initialize the stores locally, and report readiness only when that work is complete. The update is complete when the final node becomes ready. Monitor progress with:

>
> ```
> NS=self-managed
> # nodes become ready one at a time; the last one to report ready ends the update
> kubectl get pods -n $NS -l app.kubernetes.io/component=fid -w
>
> # what a joining node is doing
> kubectl logs fid-1 -n $NS -c fid --tail=50 | grep -Ei "replicat|initializ|Opening index|Loaded with"
> ```

### Very large individual stores

The update sizes rebuild-worker memory from the largest export file. In the export archive, files of 4 GB or larger are recorded with a fixed placeholder value instead of their actual size. As a result, once a store export reaches approximately 4 GB, the rebuild worker receives the same memory allocation whether the export is 4 GB or significantly larger.

The rebuild reads input as a stream and does not normally require memory proportional to data size. A 10-million-entry store rebuilt successfully with memory selected in this way.

If you migrate unusually large individual stores and the rebuild fails because of memory, explicitly increase `hdapMigration.import.maxMemory` instead of relying on automatic memory sizing.

## After the update

Verify the update:

```
NS=self-managed
```

```
kubectl get pods -n $NS
```

All pods should be `Running`. The `sync` pod should be present, and `directory-schema` should not be present.

```
kubectl get jobs -n $NS
```

The `fid-hdap-post-upgrade-wait` Job must be `Complete`.

```
kubectl get configmap fid-hdap-migration-state -n $NS \
  -o jsonpath='{.data.phase}{"\n"}'
```

The result must be:

```
completed
```

```
kubectl get statefulset fid -n $NS \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

```
kubectl exec fid-0 -n $NS -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list
```

Run the [Record the current state](#record-the-current-state) command again and compare its output with the pre-update output. Confirm the following:

- The number of stores is unchanged.
- The version reports `9.0.0`.
- The data directory is larger.

Test LDAP, REST/ADAP, SCIM, and Control Panel access.

If you added the `safe-to-evict` annotation to ZooKeeper pods, remove it after the update. Also update monitoring that references `directory-schema`.

### View duration and migration details

The Jobs retain their start and completion times until the next update. Use the following command to view them:

```
kubectl get jobs -n self-managed \
  -o custom-columns='JOB:.metadata.name,STARTED:.status.startTime,COMPLETED:.status.completionTime,OK:.status.succeeded' \
  | grep -E 'JOB|hdap'
```

If `jq` is installed, display durations in seconds:

```
kubectl get jobs -n self-managed -o json | \
  jq -r '.items[] | select(.metadata.name|startswith("fid-hdap")) | "\(.metadata.name)\t\(((.status.completionTime|fromdate) - (.status.startTime|fromdate)))s"'
```

To view export size, import memory, attempt count, and verification status:

```
kubectl get configmap fid-hdap-migration-state -n self-managed \
  -o jsonpath='{range $k,$v := .data}{$k}={$v}{"\n"}{end}'
```

## If a step fails

Determine where the update stopped:

```
NS=self-managed
```

```
kubectl get jobs -n $NS
```

```
kubectl get configmap fid-hdap-migration-state -n $NS -o yaml
```

```
kubectl logs job/<Job-that-is-not-Complete> -n $NS | tail -40
```

### fid-hdap-scale-down

**Likely causes:** Pods do not stop within `scaleDownTimeout`; the combined grace periods exceed the timeout; a pod is stuck on an unreachable node; or a volume does not detach.

**Result:** Helm fails quickly. RadiantOne is restored automatically on its current version and remains available. The volume is unchanged. In testing, Helm returned after 23 seconds and the server was never taken down.

**Action:** Set `scaleDownTimeout` to at least `replicas × grace period + 60`, then run the same `helm upgrade` command again.

### fid-hdap-export

**Likely causes:** ZooKeeper is unavailable; the worker pod cannot start because no node has sufficient resources or the volume is still attached; insufficient free space; or `exportTimeout` expires.

**Result:** The Job log ends with `ERROR: Worker did not emit EXPORT_OK marker`. RadiantOne is automatically scaled back up on its current version. In testing, it became ready approximately five minutes after failure. The volume remains unchanged, and partial exports are not used.

**Action:** Correct the issue and run the same `helm upgrade` command again. A completed export is retained and reused.

### fid-hdap-import

**Likely causes:** Every rebuild attempt runs out of memory or time, or verification finds unconverted stores.

**Result:** The Job log identifies the cause, for example, `ERROR: import exceeded its ... budget and is still running; stopping it.` RadiantOne is not restored because the volume now contains the v9 installation. The StatefulSet remains at zero replicas.

**Action:** Run the same `helm upgrade` command again. The export is skipped, the rebuild resumes, and completed stores are verified. Import attempts persist across reruns. If the attempt limit is reached, increase `hdapMigration.import.maxAttempts` and run the update again, or contact Support.

### fid-hdap-pvc-cleanup

**Likely causes:** A follower-only volume cannot be deleted.

**Result:** The rebuild succeeded. Only follower cleanup remains.

**Action:** Run the same `helm upgrade` command again.

### fid-hdap-post-upgrade-wait

**Likely causes:** RadiantOne does not become ready within `postUpgradeWaitTimeout`, or a store recorded during export is not opened.

**Result:** The update is already applied. If the server is still starting, it can become healthy shortly afterward even though the gate timed out. The Job log identifies the condition.

**Action:** Review the Job log. If the server is running and serving data, rerun the same `helm upgrade` command. Migration steps are skipped and only the gate runs again. If stores were not opened, do not place the deployment into service. Contact Support with the Job log.

### Helm timeout

**Likely causes:** The specified `--timeout` is shorter than the update duration.

**Result:** The Jobs continue running. Helm reports the release as failed even though the update can still be finishing. If the rebuild began, the volume is already on v9.

**Action:** Wait for Jobs to finish with `kubectl get jobs -n self-managed -w`, then rerun the same command with a longer `--timeout`. Completed work is skipped.

### Do not manually scale after a failure

Do not manually scale the StatefulSet after a failed update.

If the update fails after rebuild starts, the StatefulSet still references the old image. Scaling it or restarting pods does not restore v8. The installation on the volume is already version 9.0.0.

Manual scaling can start a v9 server with v8 services and Control Panel components, while Kubernetes, Helm, and pod images still report version 8.5. Rerun the upgrade command instead.

The recovery behavior depends on whether the rebuild has started:

- A failure before rebuild starts is safe and self-correcting. The chart restores RadiantOne on its current version automatically. Only the elapsed update time is lost.
- A failure during or after rebuild leaves the server stopped by design. The volume has been converted, and starting the old version on it would create the condition the update process prevents.

In both cases, rerunning the upgrade is the supported recovery method.

If the readiness gate repeatedly fails on a deployment that you know is healthy, you can disable it by setting:

```
hdapMigration:
  postUpgradeWait: false
```

Keep the readiness gate enabled for normal updates. It detects a server that starts without serving all data.

### Example successful recovery

The following example shows recovery after a rebuild failure. The first rerun resumed the rebuild. The second rerun completed the remaining steps.

```
$ helm -n self-managed upgrade --install fid ... --version 9.0.0 --values values.yaml --timeout 4h
   Release "fid" has been upgraded.            <- returned after 5m37s
```

```
$ kubectl logs job/fid-hdap-import -n self-managed | tail
   === updater exit code: 0
   installed after updater: version=9.0.0 build=... migration.version=9.0.0_1
   VERIFY stores=14 converted=14 expected=14 pending=[] missing=[]
   IMPORT_OK
   HDAP import complete and verified.
```

```
$ helm -n self-managed upgrade --install fid ... (same command again)
   Release "fid" has been upgraded.            <- returned after 44s
```

```
$ kubectl get jobs -n self-managed
   export=Complete import=Complete pvc-cleanup=Complete post-upgrade-wait=Complete
```

```
$ kubectl get configmap fid-hdap-migration-state -n self-managed -o jsonpath='{.data.phase}'
   completed
```

After rebuild succeeds, later update runs do not repeat the rebuild. They complete only steps that are still outstanding.

## Troubleshooting

The following examples use `NS=self-managed`.

### fid-hdap-scale-down times out while pods remain

Scale-down is sequential and each pod uses its full grace period, or a pod is stuck in `Terminating` on a `NotReady` node.

```
kubectl get pod fid-N -n $NS -o jsonpath='{.metadata.deletionTimestamp} {.spec.nodeName}{"\n"}'
kubectl get node <node>
kubectl describe pod fid-N -n $NS | tail -20
```

If the node is healthy, increase `scaleDownTimeout`. If the node is `NotReady`, resolve the node issue first. Do not force-delete a RadiantOne pod only because its node is unreachable. If the node returns, two servers could share one volume.

### Export fails immediately with Cannot reach ZooKeeper

A ZooKeeper pod was evicted, often by a cluster autoscaler after RadiantOne stopped.

```
kubectl get pods -n $NS -l app.kubernetes.io/name=zookeeper -o wide
kubectl get events -n $NS --sort-by=.lastTimestamp | tail -20
```

Wait for ZooKeeper to be `3/3` ready, apply the safe-to-evict annotation from preparation step 6, and rerun the update.

### Worker pod remains Pending with Worker pod stuck in phase

No node has the required CPU or memory, or the volume is still attached to another node and reports a `Multi-Attach` condition.

```
kubectl describe pod fid-hdap-export-worker -n $NS | tail -20
kubectl get volumeattachment | grep <pvc-name>
```

Wait for Kubernetes to clear the stale attachment after the previous node is gone. Do not delete it manually.

### Import fails with an out-of-memory message

The largest exported store requires more memory than the worker received.

The chart automatically retries with more memory. If all attempts fail, increase `hdapMigration.import.maxMemory` and `hdapMigration.import.maxAttempts`, then rerun the update.

### A rerun reports that the attempt limit has been reached

Import attempts are stored in `fid-hdap-migration-state` and persist across update runs.

Increase `hdapMigration.import.maxAttempts` in the values file, then rerun the update.

### Readiness gate fails with fid is at 0 replicas after the migration

The new StatefulSet was not applied, for example because Helm was interrupted between the Jobs and the apply operation.

```
kubectl get statefulset fid -n $NS -o jsonpath='{.spec.template.spec.containers[0].image} {.spec.replicas}'
```

Rerun the same `helm upgrade` command. Do not scale the StatefulSet manually.

### Readiness gate reports exported stores were never opened

Identity Data Management started but is not serving some migrated data.

```
kubectl logs job/fid-hdap-post-upgrade-wait -n $NS
kubectl logs fid-0 -n $NS -c fid | grep -i -E 'error|exception' | tail -20
```

Contact Support with both logs before serving traffic.

### Kubernetes reports 8.5, but the server reports 9.0

The volume was rebuilt, then the old image was started manually.

Run the Helm upgrade to 9.0.0 to complete the update so that services and images match the installation.

### Control Panel or services return 401 after update

Usually an incorrect password was entered manually. The update does not change credentials.

Retrieve the password from the secret as described in the installation guide, then retry.

### After rollback, every pod is running except the RadiantOne server, which is missing

A PVC was still being deleted when the chart was reinstalled because a leftover migration worker pod still mounted it.

```
kubectl -n $NS describe statefulset fid | tail -5
kubectl -n $NS get pvc
kubectl -n $NS delete pod --field-selector=status.phase==Succeeded
```

After the leftover pod is removed, the claim is released within seconds. Uninstall and reinstall the chart so the StatefulSet creates the pod with a fresh claim.

### Monitoring reports that directory-schema is missing

The component was renamed to `sync`.

Update the monitoring check. See preparation step 5.

## Where to find logs

A pod named `fid-hdap-import-worker` remains in `Completed` state after the update. It is harmless while the deployment is running, and its log can be useful. However, it continues to mount the RadiantOne volume, so delete it before deleting the volume claim.

The rebuild's helper pod is removed as soon as the rebuild succeeds, so nothing is left holding the RadiantOne volume claim by then. Its full log is written to the volume under `/opt/radiantone/vds/work/hdap-migration/` before the pod goes, and the logging sidecar ships it once RadiantOne is back up. If you ever see a pod named `fid-hdap-import-worker` or `fid-hdap-export-worker` still running after an update has finished, that step did not complete — treat it as a failure and read its log rather than deleting it.

Use these sources to troubleshoot the update:

- Job output: `kubectl logs job/<name> -n self-managed`
- Export and import output: The export and import Jobs stream worker-pod output into their own logs. You do not need to capture logs before a worker pod is removed.
- Update summary: `fid-hdap-migration-state` ConfigMap, which records sizes, import memory, attempts, and verification results.
- RadiantOne logs after update:

  ```
  kubectl logs fid-0 -n self-managed -c fid
  ```

- RadiantOne log files in the pod:

  ```
  /opt/radiantone/vds/vds_server/logs/
  ```

  Including `vds_server.log` and `vds_events.log`.

Migration Jobs and their logs remain available for 24 hours after a Job completes. The retention period is controlled by hdapMigration.job.ttlSecondsAfterFinished, which defaults to 86400 seconds. Kubernetes deletes completed Jobs automatically when the period expires.

Collect logs from failed Jobs before they expire. Set the value to 0 or null to retain Jobs indefinitely. Other values below 300 seconds are not allowed because a Job could be deleted before Helm or Argo CD reads its result.

## Removing update leftovers

Deleting a v9 deployment with helm uninstall or by deleting its Argo CD application can leave update-related objects in the namespace. These objects are Helm or Argo CD hooks, so they are not considered part of the deployment and are not removed automatically:

* Migration RBAC objects: fid-hdap-migration-sa, fid-hdap-migration-role, and fid-hdap-migration-rb. These are also delete-time hooks, so they are recreated when the deployment is deleted.

* Completed migration Jobs: fid-hdap-scale-down, fid-hdap-export, fid-hdap-pvc-cleanup, fid-hdap-import, and fid-hdap-post-upgrade-wait. Kubernetes removes these automatically after 24 hours.

* Generic lifecycle-hook RBAC objects, if hooks.hooks_sa.enabled is enabled: fid-hook-account, fid-manage-pods, and the associated RoleBinding.

The migration state ConfigMap (fid-hdap-migration-state) and any export or import helper pods are deployment resources and are removed with the deployment. However, a migration state ConfigMap created by a chart earlier than 9.0.0 might remain; delete it manually if necessary.

To remove update-related leftovers immediately after deleting the deployment, run:

```
NS=self-managed
kubectl -n $NS delete serviceaccount,role,rolebinding \
  -l app.kubernetes.io/component=hdap-migration,app.kubernetes.io/instance=fid
kubectl -n $NS delete job --ignore-not-found \
  fid-hdap-scale-down fid-hdap-export fid-hdap-pvc-cleanup fid-hdap-import fid-hdap-post-upgrade-wait
kubectl -n $NS delete configmap fid-hdap-migration-state --ignore-not-found
# only if hooks.hooks_sa.enabled was set
kubectl -n $NS delete --ignore-not-found serviceaccount/fid-hook-account role/fid-manage-pods rolebinding/fid-manage-pods

# nothing of the release should be listed
kubectl -n $NS get serviceaccount,role,rolebinding,job,configmap,pod -l app.kubernetes.io/instance=fid
```

Do not run these while the deployment is still installed: the next update creates the objects again anyway, and deleting a migration Job that is still running stops the update. None of this removes the volume claims; see [Clear the namespace](#clear-the-namespace) to empty the namespace completely.


## Return to v8

A v9 deployment cannot be downgraded in place. A 9.x backup cannot be restored into an 8.x deployment.

To return to v8, create a new v8 deployment and restore the backup created before the update. Do not delete the backup, or the optional snapshots, until you accept the v9 deployment.

Confirm what the backup contains before relying on it:

- A backup created without `rli.migration.hdap.all` contains configuration only.
- Persistent caches must be reinitialized.
- Configuration and data changes made after the backup are not included.

### Clear the namespace

Both rollback methods require an empty namespace.

After a v9 update, a completed migration worker pod remains and continues to mount the RadiantOne volume. Kubernetes retains the persistent volume claim until the pod is removed. A `kubectl delete pvc` command can appear to hang, leaving the claim in `Terminating` state.

If you reinstall while a PVC is being deleted, microservices and ZooKeeper can start normally, but the RadiantOne server pod is not created because Kubernetes does not create a pod whose claim is being deleted.

Clear the namespace as follows:

```
NS=self-managed
```

1. Remove the Helm release:

   ```
   helm -n $NS uninstall fid
   ```

2. Remove migration Jobs and completed pods, including workers that mount the volume, and the leftover objects described in [Removing update leftovers](#removing-update-leftovers):

   ```
   kubectl -n $NS delete serviceaccount,role,rolebinding \
     -l app.kubernetes.io/component=hdap-migration,app.kubernetes.io/instance=fid
   ```

   ```
   kubectl -n $NS delete job \
     -l app.kubernetes.io/component=hdap-migration \
     --ignore-not-found
   ```

   ```
   kubectl -n $NS delete configmap fid-hdap-migration-state --ignore-not-found
   ```

   ```
   kubectl -n $NS delete pod \
     --field-selector=status.phase==Succeeded \
     --ignore-not-found
   ```

   ```
   kubectl -n $NS get pods
   ```

Confirm that no pods remain. Successful updates clean up helper pods automatically. If an update stops before completion, an export or import worker pod might remain running. Look for `fid-hdap-export-worker` or `fid-hdap-import-worker`, and delete any remaining worker pod before you continue.

3. Delete persistent volume claims:

   ```
   kubectl -n $NS delete pvc --all
   ```

4. Confirm that all claims are deleted:

   ```
   kubectl -n $NS get pvc
   ```

Do not reinstall until this command returns `No resources found`.

If a claim remains in `Terminating`, identify and remove the pod that still mounts it:

```
kubectl -n $NS get pods -o json | \
  jq -r '.items[] | select(.spec.volumes[]?.persistentVolumeClaim.claimName=="r1-pvc-fid-0") | .metadata.name'
```

A reinstall while the claim is deleting produces a deployment where the RadiantOne server is absent. The StatefulSet reports an event similar to:

```
Warning  FailedCreate  Create Pod fid-0 in StatefulSet fid failed error: pvc r1-pvc-fid-0 is being deleted
```

### Restore from a backup ZIP

Make the backup ZIP accessible to the cluster over HTTP or HTTPS, such as from an internal web server or object storage.

Use a URL without an `&` character. In the v8 chart, the URL is placed unquoted in a shell command. An `&`, such as one in a pre-signed S3 URL, interrupts the download.

Install the v8 chart matching the version from which the backup was created. Install it in a new namespace or in the cleared namespace. Set `fid.migration.url` to the backup ZIP:

```
fid:
  migration:
    url: "https://files.example.com/pre-v9-backup.zip"
```

```
kubectl create namespace self-managed-v8
```

```
kubectl apply -n self-managed-v8 -f regcred.yaml
```

```
helm -n self-managed-v8 install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 1.5.3 \
  --values </path/to/your/v8-values.yaml>
```

Verify that the backup downloaded successfully. The chart does not detect a failed download. If the file is not a valid ZIP archive, the deployment starts empty without an error.

```
kubectl exec -n self-managed-v8 fid-0 -- \
  unzip -l /migrations/export.zip | tail -3
```

Confirm that the RadiantOne server pod was created:

```
kubectl -n self-managed-v8 get pods | grep fid-
```

```
kubectl -n self-managed-v8 get pvc
```

Wait for all pods to become running and ready. Then:

- Reinitialize persistent caches.
- Repopulate content that the backup does not include.
- Reapply configuration changes made after the backup.
- Verify entry counts and spot-check known DNs in each store.
- Test Control Panel login and LDAP, REST/ADAP, and SCIM access.
- Repoint clients to the new deployment services.
- Update OIDC callback URLs.
- Retain the v9 namespace until the v8 deployment is accepted.

### Restore from volume snapshots

If you created snapshots during preparation, you can restore the volumes from them instead of importing the backup ZIP.

This restores the entire v8 installation, data, and ZooKeeper state as they existed when the snapshots were taken. It uses the standard Kubernetes mechanism: new PVCs that use the snapshots as their data source.

1. Clear the namespace as described in [Clear the namespace](#clear-the-namespace).

2. Confirm that `kubectl get pvc` returns no claims.

   The chart StatefulSets adopt existing claims that use the expected names.

3. Recreate each PVC using its snapshot as the data source:

   ```
   for PVC in r1-pvc-fid-0 zk-pvc-zookeeper-0 zk-pvc-zookeeper-1 zk-pvc-zookeeper-2; do
   SIZE=$(kubectl get volumesnapshot pre-v9-$PVC -n self-managed \
     -o jsonpath='{.status.restoreSize}')
   cat <<EOF | kubectl apply -n self-managed -f -
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: $PVC
   spec:
     storageClassName: <same-storage-class-as-before>
     accessModes: [ReadWriteOnce]
     resources:
       requests:
         storage: $SIZE
     dataSource:
       name: pre-v9-$PVC
       kind: VolumeSnapshot
       apiGroup: snapshot.storage.k8s.io
   EOF
   done
   ```

4. Verify that the PVCs were created:

   ```
   kubectl get pvc -n self-managed
   ```

5. Install the v8 chart using the v8 values file. Do not set `fid.migration.url`.

The StatefulSets adopt the restored claims and start with the restored installation.

Verify the deployment as described in [Restore from a backup ZIP](#restore-from-a-backup-zip), then repoint clients.

With the `WaitForFirstConsumer` binding mode used by most storage classes, restored claims remain `Pending` until a pod that uses them is scheduled. This is expected.

On cloud block storage, restored volumes are populated lazily from the snapshot, so the first startup can take longer than usual. If a claim remains `Pending` after its pod is scheduled, run `kubectl describe pvc <name>` to view the provisioner's reason.

## Known limitations

- There is no in-place downgrade.
- Volume snapshots use the standard Kubernetes snapshot API and work with storage drivers that support it. A `VolumeSnapshotClass` for the relevant driver must exist. Without one, snapshots do not become ready.
- Helm `--timeout` does not stop the update. It only stops Helm from waiting for completion.

## Release notes and support

For v9 improvements and fixes, see the [v9.0 release notes](../maintenance/v9release-notes/v9.0-release-notes-temp/).

For known issues reported after release, see the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues).

To report problems or provide feedback, use [Radiant Logic Support](https://support.radiantlogic.com). If you do not have a Support login, contact [support@radiantlogic.com](mailto:support@radiantlogic.com).
