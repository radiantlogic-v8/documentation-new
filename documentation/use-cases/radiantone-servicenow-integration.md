---
title: RadiantOne SCIM Integration with ServiceNow
description: This document provides implementation details for RadiantOne SCIM Integration with ServiceNow
---

# Overview 

The RadiantOne Identity Data Management service acts as a virtual hub, capable of ingesting and synchronizing data from all your identity applications for administration, management, and 
provisioning to other applications in the required format. Building the hub requires a set of sophisticated features that can be difficult to manage without a guided process. 

RadiantOne offers a set of tools that guide users through implementing best practices for these advanced features. The purpose of this guide is to provide the necessary steps to implement the RadiantOne 
SCIM connector for synchronizing and managing identity data from the ServiceNow ITSM platform. 

The target audience includes administrators, engineers, contractors, consultants, and managers responsible for an organization’s identity management infrastructure and applications.

## Capabilities 

The System for Cross-domain Identity Management (SCIM) specification automates user identity management between identity domains. The RadiantOne SCIM connector supports the SCIM v2 specification and
connectivity to any SCIM compliant target endpoint.

Connectivity and management of objects in ServiceNow are configured and enabled through the Identity Data Management Control Panel. This integration can allow for full CRUD (Create, Read, Update and Delete)
operations against the ServiceNow SCIM endpoint objects.


## Prerequisites

The following are general prerequisites for implementing and supporting the RadiantOne SCIM connector to synchronize and manage ServiceNow identity data in RadiantOne:
* Familiarity and general understanding of SCIM and LDAP protocols and standards
* Working knowledge of ServiceNow, including access and permissions to administer and configure the target ServiceNow environment for integration with RadiantOne
* Working knowledge of RadiantOne Identity Data Management, including access and permissions to administer and configure the system for integration with ServiceNow
* Networking ingress and egress enabled as needed for connectivity from RadiantOne to ServiceNow

## High-level configuration steps

* Create an account in ServiceNow with the necessary permissions to connect and manage the ServiceNow identity data via SCIM, to be synchronized and managed in the RadiantOne environment.
* Have RadiantOne Identity Data Management deployed (either self-managed or through an Environment Operation Center (EOC) tenant).
* Create an account with the required access and permissions to manage RadiantOne Data Sources, Schema and Namespace configuration in the RadiantOne environment.
* Create a RadiantOne Identity Data Management Data Source.
* In the RadiantOne Identity Data Management environment, extract the Schema for desired ServiceNow endpoints and objects.
* Create a RadiantOne Identity Data Management namespace to ingest and synchronize targeted ServiceNow SCIM endpoint objects.
* Test and validate the SCIM integration and synchronization between ServiceNow and RadiantOne Identity Data Management.

The sections below outline detailed configuration steps.  

## ServiceNow configuration steps

### 1. Create a ServiceNow account
Create an account in ServiceNow to be used by the RadiantOne SCIM connector.

### 2. Assign required permissions to ServiceNow account

In the example included in this configuration guide, we assigned the ‘Admin’ role to the service account to be used by RadiantOne SCIM connector to ServiceNow. 

* The ‘Admin’ role provides the necessary level of access to connect to associated SCIM and Web Services endpoints and ingest the ServiceNow data into a defined RadiantOne Namespace.
* The ‘Admin’ role grants full CRUD(Create, Read, Update, Delete) access to objects via the SCIM API and Web Services for the respective Endpoints.
    
> Note that additional scoping and rights management within ServiceNow to provide more granular control in ServiceNow is beyond the scope of this document. Read the [linked document](https://www.servicenow.com/docs/search?q=roles) for further assistance with understanding the administrative model used in ServiceNow documentation on roles. 

![image of service now roles UI](images/servicenow-roles.png)

The ‘rl_admin’ user is created with the ‘admin’ role assigned.  Other roles are inherited with the ‘admin’ role.  If needed, more granular permissions can be established but that is beyond the scope of this document. 

## RadiantOne configuration steps

### 1. Create a Data Source

Log in to the Identity Data Management Control Panel UI using an account with sufficient privileges to manage Data Sources, Namespaces, and Schema configuration. All setup is performed through point-and-click operations in the UI.

The following sections with images illustrate how to create a data source in Identity Data Management and also highlight any additional considerations or caveats you may need to be aware of. 

a. After logging into Identity Data Management Control Panel, select ‘Data Catalog’ > ‘Data Sources’ from the navigation pane on the left hand side and click ‘NEW SOURCE’.

![image of service now roles UI](images/new-ds.png)

b. Click the ’SCIM v2’ tile from the list of displayed data sources and click the 'Select' button. 

![image of service now roles UI](images/scim.png)

c. 




