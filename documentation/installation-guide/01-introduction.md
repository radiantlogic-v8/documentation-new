---
title: Hardware Sizing Guide
description: Hardware Sizing Guide
---

# Introduction

Hardware sizing is a critical component of directory service planning and deployment. When sizing hardware, both the amount of memory and the amount of local disk space available are of key importance.

RadiantOne runs as a multi-threaded Java program, and is built to scale across multiple processors. In general, the more processing power available, the better. However, in practice, adding memory, faster disks, or faster network connections can enhance performance more than additional processors.

When deploying a cluster, nodes must be running on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines.

The information in this guide provides a basis for capacity planning that helps ensure that the virtual directory server hardware is adequate for handling peak loads. The following minimum requirements must be met and might be inadequate for a production environment. For best results, install and configure a test system with a subset of entries representing those used in production. You can then use the test system to approximate the behavior of the production server.


- CPU Cores - minimum 2 cores.
- Machine Memory - minimum 15GB.
- Disk Throughput - minimum 100MB/sec.
- Disk Space - minimum 20GB.
- DNS resolution - all hostnames must be resolvable.
- Zookeeper network latency - maximum 15ms.
- Zookeeper read throughput - minimum 25MB/sec.
- Zookeeper write throughput - minimum 5MB/sec.
- Linux Open File Descriptors - minimum 48k.
- Linux Maximum resident set size - requires unlimited.
- Linux Memory Map Areas for processes - minimum 256KB.
- Linux Swappiness - swap to be disabled or swappiness <=20.
- Linux Maximum amount of virtual memory available to a process launched by the user associated with the RadiantOne installation - requires unlimited.
