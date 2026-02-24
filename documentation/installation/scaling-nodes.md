---
title: Scaling Cluster Nodes 
description: Learn how to safely remove a node from you RadiantOne Identity Data Management delployment in your own Kubernetes cluster.
---

# Scaling Cluster Nodes 

This guide covers steps to safely scale down and subsequently scale up a self-managed RadiantOne Identity Data Management cluster deployed in Kubernetes.

## Prerequisites

- Ensure you have `kubectl` access to the Kubernetes namespace where RadiantOne is deployed.  
- Verify the current number of replicas for your StatefulSet.

## Steps to remove a node

Follow these steps to remove a node cleanly:

### 1. Capture the Cloud ID

Before scaling down, retrieve the Cloud ID of the node you plan to remove.

```
NAMESPACE="<your-namespace>"

kubectl exec -n $NAMESPACE fid-0 -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list
```

Locate the entry for the node to be removed (for example, `fid-2`) and note its **Cloud ID (UUID)**.  
This value is required for the next step.

### 2. Scale Down the StatefulSet

Reduce the number of replicas to remove the target node.

**Example:** Scale from 3 replicas to 2

```
kubectl scale statefulset fid --replicas=2 -n $NAMESPACE
kubectl wait --for=delete pod/fid-2 -n $NAMESPACE --timeout=300s
```

Wait until the `fid-2` pod is completely deleted before continuing.


### 3. Unregister the Removed Node

Run the unregister command from one of the remaining nodes (for example, `fid-0`).

```
kubectl exec -n $NAMESPACE fid-0 -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh unregister vds_server <CLOUD_ID>
```

**Example:**

```bash
cluster.sh unregister vds_server 04a39cd8-6a23-4344-b732-487234236f71
```

This command does the following:

- Connects to ZooKeeper
- Removes the node’s metadata using its Cloud ID
- Cleans up cluster membership entries
- Prevents ghost or **OFF** nodes from appearing

No pod restarts are required.

### 4. Delete the PVC

After the node has been unregistered, remove its persistent volume claim.

```
kubectl delete pvc r1-pvc-fid-2 -n $NAMESPACE
```

This deletes the storage associated with the removed pod.

### 5. Verify node removal 

Verify the cluster’s current state:

```
kubectl exec -n $NAMESPACE fid-0 -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list
```

You should see that the removed node no longer appears in the list. All remaining nodes must be fully operational and synchronized.

## Scaling the Cluster Back Up

To increase the replica count again, run the following commands:

```
kubectl scale statefulset fid --replicas=3 -n $NAMESPACE
kubectl wait --for=condition=ready pod/fid-2 -n $NAMESPACE --timeout=600s
```

The new node will:

- Create a new PVC
- Generate a new Cloud ID
- Automatically register itself
- Synchronize its configuration from ZooKeeper
- Join the cluster as a follower

No manual registration is needed during scale-up.



