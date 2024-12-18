---
title: Scaling Identity Data Management Nodes
description: Learn how to Scale In/Out Identity Management Nodes.
---

## Overview

This guide describes how to adjust the number of nodes in an environment and to monitor the status details of a specific node.

## SaaS Deployment

To set the number of RadiantOne nodes contained in an environment, in the EOC navigation pane on the left, select Environments. On the Environments page, select an environment and select an application.Select the Scale option under "Application Details". For more information, see [Adjusting the Number of Nodes](/../../eoc/latest/environments/environment-details/node-details#adjust-number-of-nodes).

## Self-Managed Deployment

For self-managed deployments, you can specify the number of nodes to scale during the initial installation or an upgrade by setting the desired value in the [`replicaCount`](../installation/self-managed/#steps-for-deployment)) field of the Helm Chart's values.yaml file. The number of nodes should be determined based on your throughput requirements. Generally, for test deployment, you can set the value as 1 and for production deployments, the value can be 2 or higher. While the recommended maximum for production environment is 5 nodes, you can adjust this value as needed to suit your specific needs. For more information, see [Self-managed Deployment](../installation/self-managed).
