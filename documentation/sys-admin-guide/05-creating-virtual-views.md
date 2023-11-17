---
title: System Administration Guide
description: System Administration Guide
---

# Creating Virtual Views

The RadiantOne namespace is managed from the Directory Namespace tab. New root naming contexts are configured and managed from here. A naming context can represent virtual views from LDAP, database or web service backends or local RadiantOne Universal Directory stores. For details, please see the [RadiantOne Namespace Configuration Guide](/namespace-configuration-guide/01-introduction).

>[!note] The Directory Namespace tab is not accessible from follower-only cluster nodes.

# Context Builder Tab

For details on using the Context Builder to create model-driven views, see the RadiantOne Context Builder Guide.

# Wizards Tab

All Identity Service Wizards can be launched from the Main Control Panel > Wizards tab. RadiantOne must be running in order to launch a wizard. If RadiantOne is not running, it can be started from the Dashboard tab. Details on each wizard can be found in the [Identity Service Wizards](#identity-service-wizards) section of this guide.

![wizards tab](Media/Image3.160.jpg)
 
Figure 1: Wizards Tab

## Identity Service Wizards

RadiantOne includes a set of wizards to assist administrators with some of the most common configuration tasks. They are designed to guide administrators through the creation of an identity service. This includes tasks such as building a unique user list, how to handle group entries (migrate them or create dynamic groups), and how to design the namespace (flat tree or merge into an existing hierarchy). Each wizard is tailored for specific use cases, depending on the needs of the applications that will be consuming the identity service.

The wizards are launched from the [Wizards Tab](05-creating-virtual-views#wizards-tab) in the Main Control Panel. The RadiantOne service must be running prior to launching a wizard and can be started from the Dashboard tab in the Main Control Panel if needed.

Below is a summary for each wizard. For more information including configuration steps, please see the Identity Service Wizards Guide.

### Directory Tree Wizard

The Directory Tree Wizard creates a virtual view which can aggregate multiple types of backends (combination of directories, database, web services, and so on) under a naming context. The wizard guides you through creating the root naming context, creating levels of hierarchy beneath the root naming context, and mounting LDAP and database backends to leaf nodes.

Data sources that you connect to in the Directory Tree Wizard must be configured prior to reaching the Define Backends page of the wizard. This can be done before launching the wizard from the Main Control Panel > Settings tab > Server Backend section.

### Identity Data Analysis

The RadiantOne Identity Data Analysis tool analyzes the quality of data in the backends, helping you determine which attributes would be the best candidates for correlation rules in addition to providing other information that is important for sizing and tuning your identity service. 

The Identity Data Analysis tool generates a report for each of your data sources. These reports give a glimpse of the data and provide insight on the quality and size. This provides RadiantOne administrators with valuable information about what can be used for correlation logic and join rules. You can mount virtual views from each of your data sources below a global root naming context in the RadiantOne namespace and point the Identity Data Analysis tool to this location to perform a single analysis/report from all sources at once. This helps to detect attribute uniqueness and calculate statistics across heterogeneous data sources.

### Global Identity Builder

The Global Identity Builder can be used in situations where applications require a single data source to locate all users required for authentication and/or need to access a complete user profile for attribute-based authorization. The overlapping identities do not need to have a single common identifier, because a combination of matching rules can be used to determine a link. The Global Identity Builder creates a unique reference list of identities spread throughout multiple data silos. An existing single source of identities is not required. For details, please see the [RadiantOne Global Identity Builder Guide](/global-identity-builder-guide/introduction).

### Groups Builder

The Groups Builder Wizard manages virtual views for defining groups and members. With this wizard, you can define rules for dynamically creating groups from multiple heterogeneous data sources. Administrators can utilize this wizard to either create user-defined or auto-generated groups. 

For more information on [groups](02-concepts#groups) supported in RadiantOne please see [Concepts](concepts.md).

The Groups Builder wizard should be used in situations where applications are accessing RadiantOne to retrieve groups/membership for enforcing authorization and a list of applicable groups either does not currently exist in any backend data source or the existing groups are insufficient because they lack all the required members. This wizard should be used if there is the need to add new members into existing groups or if there is the need to build entirely new global groups containing members from multiple different data sources.

### Groups Migration

Existing group membership references user DNs, the naming of which is based on the structure of the LDAP directory. When you model a new directory namespace with virtualization, the user DNs change. The four steps in the Group Migration Wizard assist with the effort of translating the existing group membership to match the new namespace. 

### Merge Tree

The Merge Tree Wizard merges multiple data sources into a single RadiantOne naming context, while maintaining the underlying directory hierarchy. The Merge Tree Wizard is ideal for situations where applications expect to find information in an explicit hierarchy which already exists in a backend LDAP directory and there is a need to extend a part of this hierarchy with additional entries from other data sources. 

>[!warning]
>The Merge Tree Wizard does not perform identity correlation or joins. If the data sources being merged contain overlapping users (identified by the same DN after the merge) only the entry from the primary/main source are returned when browsing or searching against the view. If the overlapping users have an attribute in common, you can always join the view created in the merge tree wizard with another virtual view to return attributes from other sources.
