---
title: ZooKeeper Install Guide
description: ZooKeeper Install Guide
---

# RadiantOne ZooKeeper Install Guide

## Chapter 1: Introduction

Apache ZooKeeper is a centralized service for maintaining configuration information across a RadiantOne cluster. Although RadiantOne comes bundled with ZooKeeper to simplify installation in Dev/QA environments, it is discouraged to use this architecture in production. Shutting down a redundant RadiantOne server will also shut down ZooKeeper on this server. Because a ZooKeeper ensemble must have a quorum of more than half its servers running at any given time, this can be a problem for cluster integrity and stability. The solution is to deploy ZooKeeper in a separate, external ensemble.

Other advantages of having a ZooKeeper ensemble separate from the RadiantOne nodes include:

- As a general best practice, you should only have one main service per server. This allows machines resources to be devoted to a single service and not have to compete for resources with other services.
- You can choose the number of ZooKeeper nodes to deploy to meet your HA requirements (e.g. 3, which allows for the failure of 1 server, or 5 which allows for the failure of 2 servers) independently from the number of RadiantOne nodes you need to
serve client requests.
- You can choose the number of RadiantOne nodes to meet your needs. Only one node needs to be up for the service to work. A RadiantOne cluster of 2 nodes might be sufficient whereas if ZooKeeper was on the same server as RadiantOne you would be required to have 3 nodes to accommodate the requirements of the ZooKeeper ensemble for HA.
- This de-coupled (single service per server) architecture is better for running in container technologies like Docker, simplifying deployment.
- Easier to troubleshoot problems and there is one less point of failure per machine.

For details on installing RadiantOne in a Dev/QA environment see the RadiantOne Installation
Guide.

For details on installing RadiantOne in a production environment, start with the steps in this guide to setup the external ZooKeeper ensemble. Then, refer to the RadiantOne installation guide on how to point to an external ZooKeeper ensemble.

The installers are available via an ftp site. Contact support@radiantlogic.com for access information.
