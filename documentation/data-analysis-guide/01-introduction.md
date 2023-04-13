---
title: Identity Data Analysis 
description: Get a quick introduction to the Data Analysis tool to understand how it can help assess the quality of your identity data and assist in determining good attribute candidates for correlation logic depending on the complexity and amount of identity data overlap. 
---

# Chapter 1: Introduction

If you don’t have a single source of users, an application would have to look in all the different data stores across the enterprise to find a particular user. Even if a user is listed in only one store (unless that exact store is already known), an application still needs to locate them, resulting in multiple queries issued (at least one to each source the user could potentially be located in). However, if you have a master index (an “identity hub”), the application only needs to query this list to locate a user, which results in queries to only the backend stores where the user is located. The more sources involved, the more valuable this global index is. It is this global list that is created and maintained by RadiantOne.

In cases where the data stores contain user overlap, RadiantOne performs aggregation and correlation, creating a common key to identify users across disparate systems. However, the union operation is still important for data sources that may or may not have identity intersection. If they do not have identity overlap there is no need for correlation, but the function of union is still crucial for building your identity service.

The diagrams below provide a summary/review of data sources containing duplicate/intersecting identities.

In the first scenario, the data sources have no overlap of identities. In this scenario the benefits of union would still be important for identity management since a single unique index/list is still required for applications to identify a user for authentication. However, the design effort is a bit easier as no correlation logic is required. An aggregation of sources A, B, and C is sufficient, so the primary design consideration in this case is what hierarchy applications are expecting and to build this namespace accordingly.

![An image showing ](Media/Image1.1.jpg)
 
Figure 1. 1: Data Sources with No Overlapping Identities

In cases where there starts to be user overlap (as seen in Sources A and B in the diagram below), the configuration starts to require correlation. In this scenario, an aggregation of users from sources A, B and C is required in addition to correlation for the overlapping users in sources A and B. The design considerations now involve correlation logic in addition to where you want the unique list of users to appear in the virtual namespace.

![An image showing ](Media/Image1.2.jpg)
 
Figure 1. 2: Data Sources with No Overlapping Identities

In scenarios where the number of data sources increases, the amount of overlapping identities varies (as depicted in the diagram below), and the logic required to correlate identities becomes complex with the possible need of cascading rules to determine correlation. 

![An image showing ](Media/Image1.3.jpg)
 
Figure 1. 3: Complex Identity Integration Scenario

The RadiantOne Identity Data Analysis tool analyzes the quality of data in the backends, helping you determine which attributes would be the best candidates for correlation rules. 

The Identity Data Analysis tool generates a report for each of your data sources. These reports give you a glimpse of your existing data and provide insight on the quality of your data and what is available for you to use for correlation logic. 

>[!warning] 
>You can also choose to mount virtual views from each of your data sources below a global root naming context in RadiantOne and point the Identity Data Analysis tool to this location to perform a single analysis/report from all of your sources at once. This helps you detect attribute uniqueness and statistics across heterogeneous data sources.
