---
title: Homepage 2
description: Homepage 2 Description
---

# Welcome to Radiant Logic DevOps

This site provides resources for DevOps professionals to deploy the RadiantOne platform. Docker images and Kubernetes for orchestration allows for easily deploying the RadiantOne platform in the cloud.

# Global sync guide

<section>
  
  > [Introduction](/global-sync-guide/introduction)  
  > The RadiantOne Global Sync module is an advanced set of tools for synchronization and identity management
  
  > [Deployment](/global-sync-guide/deployment) 
  > The components required for synchronization are: Agents, Queues, and Sync Engine/processor. These components ensure guaranteed message delivery and recoverability in case some part of the process is temporarily down/offline. 
  
  > [Uploads](/global-sync-guide/uploads)
  > If the target/destination needs populated with entries before starting synchronization, perform an initial upload. Uploads can be performed from the Main Control Panel or from a command line utility.
    
</section>

# Global sync guide

<section>
    
  > [Overview](/connector-properties-guide/overview) 
  > Connectors are used for synchronization in the RadiantOne Global Sync module and have three main functions: 1) Query data sources and collect changed entries, 2) Filter unneeded events, and 3) publish changed entries with the required information (requested attributes).
  
  > [Configuring connector types and properties](/connector-properties-guide/configuring-connector-types-and-properties)
  > The process of configuring connector properties and the property definitions described throughout the rest of this section are applicable to all connector types.
  
  > [LDAP connectors](/connector-properties-guide/ldap-connectors)
  > There are two types of LDAP connectors: Changelog and Persistent Search. These connector types are described in this chapter.
  
  > [Active Directory Connectors](/connector-properties-guide/active-directory-connectors)
  > There are three types of Active Directory connectors: USNChanged, DirSync and Hybrid. These connector types are described in this chapter.
  
  > [Database Changelog (Triggers) Connector](/connector-properties-guide/database-changelog-triggers-connector)
  > When a database object is configured as a publisher, triggers are installed on the object and document all changes to a log table.
  
  > [Database Timestamp Connector](/connector-properties-guide/database-timestamp-connector)
  > For Oracle, SQL Server, MySQL, MariaDB, and Salesforce backends (using the RadiantOne JDBC driver), a timestamp-based change detection mechanism is available.
  
  
</section>
