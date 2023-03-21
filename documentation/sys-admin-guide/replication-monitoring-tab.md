---
title: System Administration Guide
description: System Administration Guide
---

# Replication Monitoring Tab

RadiantOne Universal Directory (HDAP) stores across clusters support multi-master replication. This type of replication is referred to as inter-cluster replication. The state of inter-cluster replication can be monitored from the Replication Monitoring Tab.

## Central Journal Replication

The default, recommended replication model for RadiantOne Universal Directory (HDAP) stores is based on a publish and subscribe methodology. When writes occur on a site, the leader node publishes the changes into a central journal. The leader nodes on all other sites pick up the changes from the central journal and update their local store. These changes are then automatically replicated out to follower/follower-only nodes within the cluster. For more details on inter-cluster replication, please see the RadiantOne Deployment and Tuning Guide.

If inter-cluster replication is enabled, the clusters that are participating in replication can be viewed in the Central Journal Replication section. The topology depicts the connectivity between the clusters and the cluster housing the replication journal. If a red line is visible, this indicates a connection problem between a cluster and the replication journal.

More than one store per cluster can be participating in inter-cluster replication. The table shown in the Central Journal Replication section lists each store involved in replication. Then, for each cluster, the table shows the number of pending changes. An example is shown below.

![Replication Monitoring](Media/Image3.165.jpg)
 
Figure 3. 159: Replication Monitoring

## Push Mode Replication

To address a very small subset of use cases, namely where a global load balancer directs client traffic across data centers/sites, where the inter-cluster replication architecture might be too slow, you have the option to enable an additional, more real-time replication mode where changes can be pushed directly to intended targets. For example, an update made by a client to one data center might not be replicated to other data centers in time for the client to immediately read the change, if the read request it sent to a different data center than the update was. This is generally not an ideal load distribution policy when working with distributed systems. Load balancing is best deployed across multiple nodes within the same cluster on the same site/data center.

In any event, to address scenarios like this, a push replication mode can be used to send the changes directly to the intended targets. The targets must be other RadiantOne servers defined as LDAP data sources. For more details on Push Mode Replication, please see the RadiantOne Deployment and Tuning Guide.

If push mode replication is enabled, the clusters that are participating in replication can be viewed in the table in the Push Mode Replication section. The table lists, for each RadiantOne Universal Directory (HDAP) store, the clusters involved in replication. The source cluster, target cluster and connectivity status between them is shown.
