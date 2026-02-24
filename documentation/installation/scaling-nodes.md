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

Follow these steps to remove a node manually:

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

## Remove nodes using a script 

You may also automate this process by using the following script. 

1. Save this script and name it `fid-scale-down.sh` or another name of your choice. 

```
## Automation Script 
```bash
#!/bin/bash
# fid-scale-down.sh — Production FID Scale-Down
# Usage: ./fid-scale-down.sh <namespace> <target-replicas>
set -euo pipefail
NAMESPACE="${1:?Usage: $0 <namespace> <target-replicas>}"
TARGET="${2:?Usage: $0 <namespace> <target-replicas>}"
CURRENT=$(kubectl get statefulset fid -n "$NAMESPACE" -o jsonpath='{.spec.replicas}')
if [ "$CURRENT" -le "$TARGET" ]; then
  echo "Already at $CURRENT replicas (target: $TARGET). Nothing to do."
  exit 0
fi
echo "=== FID Scale Down: $CURRENT → $TARGET ==="
echo "Namespace: $NAMESPACE"
echo ""
# Step 1: Capture Cloud IDs for nodes being removed
echo "Step 1: Capturing Cloud IDs..."
CLUSTER_LIST=$(kubectl exec -n "$NAMESPACE" fid-0 -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list 2>&1)
declare -a CLOUD_IDS
for ((i=CURRENT-1; i>=TARGET; i--)); do
  CID=$(echo "$CLUSTER_LIST" | grep "fid-${i}\.fid-headless" | awk -F'|' '{print $3}' | tr -d ' ')
  CLOUD_IDS+=("$i:$CID")
  echo "  fid-$i → $CID"
done
echo ""
# Step 2: Scale down
echo "Step 2: Scaling StatefulSet to $TARGET..."
kubectl scale statefulset fid --replicas="$TARGET" -n "$NAMESPACE"
for ((i=CURRENT-1; i>=TARGET; i--)); do
  echo "  Waiting for fid-$i to terminate..."
  kubectl wait --for=delete "pod/fid-$i" -n "$NAMESPACE" --timeout=300s
done
echo ""
# Step 3: Unregister each removed node
echo "Step 3: Unregistering removed nodes..."
for entry in "${CLOUD_IDS[@]}"; do
  NODE_NUM="${entry%%:*}"
  CID="${entry##*:}"
  echo "  Unregistering fid-$NODE_NUM ($CID)..."
  kubectl exec -n "$NAMESPACE" fid-0 -- \
    /opt/radiantone/vds/bin/advanced/cluster.sh unregister vds_server "$CID" 2>&1 | \
    grep -E "unregistered|Error"
done
echo ""
# Step 4: Delete PVCs
echo "Step 4: Deleting PVCs..."
for entry in "${CLOUD_IDS[@]}"; do
  NODE_NUM="${entry%%:*}"
  echo "  Deleting r1-pvc-fid-$NODE_NUM..."
  kubectl delete pvc "r1-pvc-fid-$NODE_NUM" -n "$NAMESPACE" 2>/dev/null || echo "  (PVC already gone)"
done
echo ""
# Verify
echo "=== Verification ==="
echo ""
echo "Cluster list:"
kubectl exec -n "$NAMESPACE" fid-0 -- \
  /opt/radiantone/vds/bin/advanced/cluster.sh list 2>&1 | grep -E "^\||^\+"
echo ""
echo "StatefulSet:"
kubectl get statefulset fid -n "$NAMESPACE"
echo ""
echo "PVCs:"
kubectl get pvc -n "$NAMESPACE" -l app=iddm-helm
echo ""
echo "=== Scale down complete ==="
```

2. Run the script. The example below shows how to scale a 3-node cluster down to 2 nodes and then to 1 node.

```
chmod +x fid-scale-down.sh
# Scale from 3 to 2
./fid-scale-down.sh duploservices-qaibtest 2
# Scale from 3 to 1
./fid-scale-down.sh duploservices-qaibtest 1

```

## Scaling the Cluster Back Up

To increase the replica count by adding a node, run the following commands:

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



