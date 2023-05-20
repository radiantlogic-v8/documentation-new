---
title: Hardware Sizing Guide
description: Hardware Sizing Guide
---

# Network Capacity

RadiantOne is a network-intensive application, and for each client application request, it may send multiple operations to different data sources. Make sure the network connections between RadiantOne and your backend data sources are fast, with plenty of bandwidth and low latency. Also make sure the connections between client applications and the RadiantOne service can handle the amount of traffic you expect.

Testing has demonstrated that 100 Mbit Ethernet may be sufficient for classic (active/active or active/passive architectures) depending on the maximum throughput expected. You may estimate theoretical maximum throughput as follows:

max. throughput = max. entries returned/second x average entry size

Imagine for example that a Directory Server must respond to a peak of 6000 searches per second for which it returns 1 entry each with entries having average size of 2000 bytes, then the theoretical maximum throughput would be 12 MB, or 96 Mbit. 96 Mbit is likely to be more than a single 100 Mbit Ethernet adapter can provide. Actual observed performance may vary.

If you expect to perform multi-master replication (replication across clusters, or replication across active/active or active/passive classic architectures) over a wide area network, ensure the connection provides sufficient throughput with minimum/low latency and near-zero packet
loss.

>[!warning]
>If you intend to deploy RadiantOne in a cluster, on the same network for load balancing purposes, ensure the network infrastructure can support the additional load generated. 1 Gb minimum (this is a basic network card speed) between the cluster nodes is required. It is preferable to have the nodes connected to the same network switch. If you are deploying RadiantOne cluster nodes on Virtual Machines (VM), ensure the network capacity allocated to the VMs is 1 Gb minimum.

If you intend to support high update rates for replication in a wide area network environment, ensure through empirical testing that the network quality and bandwidth meet your requirements for replication throughput. When deploying multiple clusters or a classic active/active or active/passive architecture (clusters or individual servers across different networks), to ensure optimal inter-cluster/multi-master replication speeds, 1 Gb is preferred.

## Sizing for SSL

By default, support for the Secure Sockets Layer (SSL) protocol is implemented in RadiantOne.

Using the software-based SSL implementation may have significant negative impact on the Directory Server performance. Running the directory in SSL mode may require the deployment of several directory replicas to meet overall performance requirements.
