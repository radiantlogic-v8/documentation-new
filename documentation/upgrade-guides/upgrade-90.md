## Overview

Learn how to patch an environment from RadiantOne Identity Data Management v8 to v9 on a SaaS or a self-managed deployment. The steps vary depending on how you have deployed the application. 

Updating from v8 to v9 is triggered like a typical patch. However, there are a few differences that you should be aware of. Read *Main differences in v9* before you begin and plan a maintenance window.

> **Important Note** – if you have multiple clusters deployed in SaaS, contact Radiant Logic Support with your planned maintenance window so your client traffic can be redirected to your failover cluster while your primary cluster is being updated. Even if you only have a single cluster deployed, it is highly recommended to contact Radiant Logic Support to notify them about your planned maintenance window for updating, so staff can be available to assist with any issues you encounter.

### Main differences in v9

v9 updates the platform from Java 8 to Java 25 and from Lucene 6 to Lucene 10. Lucene is the storage engine behind RadiantOne Directory, and the v10 index format cannot be read by a v6 engine. As a result, the update is not an image swap like typical updates/patches: every RadiantOne Directory store is exported to LDIF on the old version and rebuilt on the new version. This is automatically handled during the patching process but requires all cluster nodes to be stopped at the same time.

## Updating SaaS Deployments

The following steps describe how to update RadiantOne Identity Data Management v8 to v9.0.0 for SaaS deployments.

### Preparing for the Update

**1. Confirm your current version is 8.5.0 or newer.**

In Environment Operations Center, navigate to **Environments > [EnvironmentName] > OVERVIEW** tab and check the version under **Application Details**.

Environments on 8.1.x or 8.3.x must first update to 8.5.0 or newer. Apply patch updates until you reach 8.5.x, confirm the application returns to **Operational**, then continue.

**2. Create a backup.**

Prior to updating RadiantOne Identity Data Management, ensure you have a recent environment backup for your existing v8.5.x version.

1. In Environment Operations Center, navigate to **Environments > [EnvironmentName] > BACKUPS** tab.
2. If you do not have any recent backups, click **Backup**.

   ![BACKUPS tab in Environment Operations Center with the BACKUP button highlighted](images/01-backups-tab.png)

3. Enter a backup file name (there is a default auto-prefix) and click **SAVE**. This process takes a few minutes. Ensure the backup file shows in the list of backups before updating.
4. Download the backup file and save it to your device. You can use this backup to do any of the following if needed:

   i. Installing Identity Data Management v9 in a new environment with existing configurations saved in your backup.

   ii. Rolling back to your older version by installing a new v8 Identity Data Management application that references the backup file in the Advanced Setup, CUSTOM CONFIGURATION.

   > **NOTE** - A 9.x backup can't be restored into a 8.x deployment.

**3. Confirm the application is active.**

If the status of the application is OFFLINE, the UPDATE option is not displayed. Restart the application first.

**4. Plan a maintenance window.**

All nodes stop during the update, so only run the update during a scheduled maintenance window. See *Expected downtime* below.

> **Important Note** – if you have multiple clusters deployed in SaaS, contact Radiant Logic Support with your planned maintenance window so your client traffic can be redirected to your failover cluster while your primary cluster is being updated. Even if you only have a single cluster deployed, it is highly recommended to contact Radiant Logic Support to notify them about your planned maintenance window for updating, so staff can be available to assist with any issues you encounter.

### Applying the Update

1. In Environment Operations Center, navigate to **Environments > [EnvironmentName] > OVERVIEW** tab.
2. In the Application Details section, click **UPDATE** next to the VERSION.

   ![Update Application dialog with the version drop-down set to 9.0.0 and the UPDATE button highlighted](images/02-update-application-dialog.png)

3. Select **v9.0.0** from the drop-down list and click **UPDATE**. This version must be greater than the version currently installed.
4. Click **UPDATE** again to confirm.

The application status displays as UPDATE APPLICATION while the update runs. Do not restart, stop, or re-update the environment while the update is in progress.

If the update succeeds, a success notification is displayed and the application status changes to **Operational**. If it fails, an error notification is displayed and the status changes to **Update Failed**; if this happens, contact Radiant Logic Support with the environment name and the time of the attempt.

You can view the result from **Environments > [EnvironmentName] > OVERVIEW > View Version History**, which lists the version number, the date applied, and the user who applied it.

### Expected Downtime

This is not a rolling update of each cluster node independently. All cluster nodes are stopped during the update. The update runs in the following order:

1. All RadiantOne Identity Data Management nodes stop.
2. Every RadiantOne Directory store is exported to LDIF on the old version.
3. fid-0 node starts with v9 and imports the LDIF, rebuilding each store.
4. The follower nodes start and rebuild their data from the fid-0 directory store images.

All endpoints (LDAP, REST/ADAP, SCIM) and the Control Panel are unavailable for the whole update window. The duration depends on the size of your stores (entry counts, number of stores, and indexes to rebuild). Where possible, run the update in a lower environment with a representative data set first and size your production window downtime from the measured time.

### After the Update

1. Confirm the version under Application Details reads 9.0.0 and the status is **Operational**.
2. Confirm all expected nodes are present and healthy.
3. Test Control Panel login and LDAP, REST/ADAP and SCIM access from a client.
4. (Optional) if you had your client traffic redirected to a failover cluster during the update, contact Radiant Logic Support to have your traffic redirected back to your primary cluster and proceed to update your failover cluster to v9.

### Reverting to v8

An environment cannot be downgraded in place, and a 9.x backup cannot be restored into a v8.x environment. If you need to revert to v8 for some reason, you will need to create a new environment and use your last v8 backup zip file in the advanced setup option.

![New environment Options panel with ADVANCED SETUP enabled and the CUSTOM CONFIGURATION ZIP upload area](images/03-advanced-setup-custom-configuration.png)

Additionally, you might need to perform these steps after the v8 application is operational:

1. Rebuild persistent caches and repopulate excluded data, such as inactive stores and cn=queue.
2. Reapply configuration changes made after the backup.
3. Verify data and application access.
4. Update client endpoints and, if applicable, the OIDC callback URL.

## Updating Self-managed Deployments

The following steps describe how to update an existing self-managed RadiantOne Identity Data Management v8 deployment to v9.0.0.

### Preparing for the Update

#### 1. Confirm the current version is 8.5.0 or newer.

```bash
helm -n self-managed list

kubectl get statefulset fid -n self-managed -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

Deployments running version 8.1.x through 8.4.x must first update to version 8.5.0 or later within the v8 release line, using the legacy chart mapping (for example `--version 1.4.5` for IDDM 8.4.5). Confirm the deployment is healthy before continuing.

#### 2. Export the configuration as a backup.

Execute the following command in the pod and copy that file locally.

```bash
kubectl exec -it -n <namespace> fid-0 -- /opt/radiantone/migrate.sh export myexport.zip
```

If the export runs successfully, the file is created at `/opt/radiantone/vds/work/myexport.zip`.

Copy the file locally:

```bash
kubectl cp -n <namespace> fid-0:/opt/radiantone/vds/work/myexport.zip ./myexport.zip
```

#### 3. Snapshot fid-0's PVC.

Rollback from v9 to v8 is not automated. A volume snapshot of fid-0's PVC is the fastest route back, so take one and confirm it is ready before you start.

```bash
kubectl get pvc -n self-managed

cat <<'EOF' | kubectl apply -n self-managed -f -
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: fid-0-pre-v9
spec:
  volumeSnapshotClassName: csi-snapshot-class
  source:
    persistentVolumeClaimName: <fid-0-pvc-name>
EOF

kubectl get volumesnapshot fid-0-pre-v9 -n self-managed
```

#### 4. Check free space.

The update writes an LDIF export before rebuilding the stores, so fid-0's volume must hold both the existing store data and the export at the same time.

#### 5. Update values.yaml.

Set the image tag for v9 and confirm the required Java option is present.

```yaml
image:
  tag: "9.0.0"
env:
  JAVA_TOOL_OPTIONS: "-Djdk.lang.Process.launchMechanism=FORK"
```

For large stores, also raise the migration timeout so the rollout is not cut short mid-import. The default is 30 minutes.

```yaml
hdapMigration:
  rolloutTimeout: 7200   # seconds
```

Set this before running the update. If the timeout expires while the import is still running, the rollout is marked failed even though data movement may be in progress.

### Applying the Update

Run the following helm command:

```bash
helm -n self-managed update --install fid oci://registry-1.docker.io/radiantone/iddm-helm --version 9.0.0 --values </path/to/your/values.yaml>
```

Monitor progress:

```bash
kubectl get pods -n self-managed -w

kubectl logs -f fid-0 -n self-managed
```

Do not interrupt the update, delete pods, or re-run helm update while the migration is in progress. Expect downtime for the whole window, and note that its duration depends on the size of your stores rather than the number of nodes.

### After the Update

1. Confirm all expected pods are running, including `iddm-sync`.

   ```bash
   kubectl get pods -n self-managed
   ```

2. Confirm the running image is 9.0.0.

   ```bash
   kubectl get statefulset fid -n self-managed -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
   ```

3. Check cluster membership and that the followers have rejoined.

   ```bash
   kubectl exec -it fid-0 -n self-managed -- cluster.sh list
   ```

4. Test LDAP, REST/ADAP, SCIM and control panel access.

### Release Notes 

For the list of improvements and bug fixes related to the v9 release, see [Release Notes](to-add).  

### Known Issues 

For known issues reported after the release, please see the Radiant Logic Knowledge Base: 

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

### How to Report Problems and Provide Feedback 

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact support@radiantlogic.com. 
