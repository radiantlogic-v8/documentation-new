---
title: Kubernetes
description: Kubernetes
---

# Kubernetes
You can use Kubernetes to orchestrate the configuration and deployment of RadiantOne. Radiant Logic provides DevOps images for deployments on cloud platforms such as Amazon Web Services (AWS) using Amazon Elastic Kubernetes Service (EKS) and Microsoft Azure Kubernetes Service (AKS).

## Prerequisites
Before deploying RadiantOne, you should already be familiar with Kubernetes Pods, Services and StatefulSets. See the [Kubernetes Documentation](https://kubernetes.io/docs/concepts/) for details. You should also be familiar with Kubernetes kubectl commands. See the [Kubernetes Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) for details.

In addition, you should:

1. Have a supported Kubernetes cluster running in the cloud. A commonly deployed Kubernetes cluster is [Amazon Elastic Kubernetes Service](https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateCluster.html). 
For a highly available architecture, the underlying Kubernetes cluster should support at least two pods running RadiantOne nodes and three pods running ZooKeeper. 

>[!note]
>  Kubernetes v1.18+ is required. The pods running RadiantOne nodes need at least 2 CPUs and 4 GiB memory. The pods running ZK need at least 2 CPUs and 2 GiB memory.

2. Install and configure the Kubernetes kubectl command-line tool on the machine where you will manage the Kubernetes cluster from.  This utility controls the Kubernetes Cluster. An example is [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html).

3. Have a RadiantOne configuration exported from a Linux Dev/QA environment. After installing RadiantOne in the Kubernetes cluster, you can import the configuration and make any needed configuration updates from the RadiantOne Main Control Panel or from command line using the vdsconfig utility.

## Deployment
Deploy RadiantOne on Kubernetes using HELM.
Helm must be installed to use the charts. Please refer to [Helm's documentation](https://helm.sh/docs/) to get started.

```
helm repo add radiantone https://radiantlogic-devops.github.io/helm
helm install my-fid-release radiantone/fid --set fid.license=<license> \
--set dependencies.zookeeper.enabled=true --set image.tag=7.4 --set fid.mountSecrets=false
```
### Add Helm Repo
Add the repo by running the following command:
```
helm repo add radiantone https://radiantlogic-devops.github.io/helm
```

To update a repository that has been added and retrieve the latest versions, run the following command:
```
helm repo update
```

To see the charts in the radiantone repository, run the following command:
```
helm search repo radiantone
```

### Charts
Prerequisites
- Kubernetes 1.18+
- Helm 3

**Install RadiantOne FID version 7.4 (latest) using helm --set values**
To install the helm chart, run the following command:
```
helm upgrade --install --namespace=<name space> <release name> radiantone/fid \
--set dependencies.zookeeper.enabled=true
--set zk.clusterName=my-demo-cluster \
--set fid.license="<license key>" \
--set fid.rootPassword="test1234" \
--set fid.mountSecrets=false \
--set image.tag=7.4.7
```

>[!note] Curly brackets in the license must be escaped --set fid.license="{rlib}xxx"
Image tag 7.4 contains the latest patch release (7.4.7)

**Install RadiantOne FID version 7.4 (latest) using helm values file.**
Create a file with these contents and save it as fid_values.yaml

```
image:
  tag: "7.4.7"
fid:
  rootPassword: "test1234"
  license: "<license key>"
  mountSecrets: false
zk:
  cluserName: "my-demo-cluster"
dependencies:
  zookeeper:
    enabled: true
```

Run the following command:

```
helm upgrade --install --namespace=<name space> <release name> radiantone/fid --values fid_values.yaml
```

**Install RadiantOne FID version 7.4 (latest) using Argo CD**
This example application demonstrates how an OTS (off-the-shelf) helm chart can be retrieved and pinned to a specific helm sem version from an upstream helm repository, and customized using a custom values.yaml in the private git repository.

In this example, the radiantone/fid application is pulled from the stable helm repo, and pinned to v1.0.0:

```
dependencies:
- name: fid
  version: 1.0.0
  repository: https://radiantlogic-devops.github.io/helm
```

A custom values.yaml is used to customize the parameters of the radiantone/fid helm chart:

```
fid:
  fullnameOverride: fid
  image:
    tag: "7.3.28"
  replicaCount: 2
  service:
    type: NodePort
  fid:
    rootPassword: "<random password>"
    license: "<license key>"
  dependencies:
    zookeeper:
      enabled: true
  resources:
    limits:
      cpu: 2
      memory: 2Gi
    requests:
      cpu: 1
      memory: 1Gi
  persistence:
    enabled: true
    storageClass: gp3
    size: 50Gi

  zookeeper:
    fullnameOverride: zookeeper
    persistence:
      enabled: true
      storageClass: gp3
      size: 10Gi
```

*List FID releases*

```
helm list --namespace=<name space>
```

*Test FID release*

```
helm test <release name> --namespace=<name space>
```

**Upgrade FID Release**
>[!note] Upgrade can only be performed to a higher version. Upgrade from 7.3.x to 7.4.x is not supported.

*Using --set values - set image.tag value:*

```
helm upgrade --install --namespace=<name space> <release name> radiantone/fid --set image.tag=7.4.8 --reuse-values
```

*Using values file - update the values file with the newer version tag.*

```
image:
  tag: "7.4.8"
fid:
  rootPassword: "test1234"
  license: "<license key>"
  mountSecrets: false
zk:
  cluserName: "my-demo-cluster"
dependencies:
  zookeeper:
    enabled: true
```

```
helm upgrade --install --namespace=<name space> <release name> radiantone/fid --values fid_values.yaml --reuse-values
```

**Delete FID**
Use the following command:
```
helm uninstall --namespace=<name space> <release name>
```
>[!note] This does not delete the persistent volumes.

**Remove Helm Repo**
```
helm repo remove radiantone
```

