---
title: Knowledge
description: knowledge
---

<tabs>
  <tablist>
    <tab>Knowledge</tab>
    <tab>Developer</tab>
  </tablist>

<tabpanels>
  <tabpanel>

# Welcome to RadiantOne Identity Data Management!

Harness your identity data with intelligent integration to drive better business outcomes, improve security and compliance posture, increase speed-to-market, and more. Browse below to learn more about the capabilities and components that comprise Identity Data Management and link to the user guides to help get you started.

<section>
  
  > [Introduction](architect-guide/preface)  
  > Learn about the common use cases for the Identity Data Platform including how it addresses the widespread problems of a fragmented identity data infrastructure. 
  
  > [Installation](installation-guide/01-prerequisites)  
  > Learn how to install using the web-based GUI process and in silent-mode from command line. 
  
  > [Hardware Sizing](hardware-sizing-guide/01-introduction)  
  > Understand hardware sizing aspects for capacity planning to help ensure that the server hardware is adequate for handling peak loads.
  
  > [Accessibility](wca-compliance-guide/01-overview)  
  > Understand how Radiant Logic Identity Data Platform reaches level AA compliance for W3C standards for accessibility.
  
  > [LDIF Utility](ldif-utility-guide/01-overview)  
  > Learn how to use the LDIF utility for a variety of functions like compiling statistics about the entries in your virtual view, and determining if a persistent cache is out of sync from backends.
  
  > [LDAP Browser](ldap-browser/01-overview)  
  > Learn how to use the general purpose LDAP Browser tool to manage entries in an LDAP directory.
  
  > [Hardening](hardening-guide/00-preface)  
  > Learn the best practices approaches for hardening against security threats.
  
  > [Operations](operations-guide/01-overview)  
  > Learn how to maintain the product once it is deployed. Topics include the management of clusters, persistent cache, and Directory stores.

  > [Command Line Configuration](command-line-configuration-guide/01-introduction)
  > Learn how to configure RadiantOne from a command line interface. 

  > [Release Notes](release-notes/v740-release-notes)
  > Review the release notes to learn more about what fixes and improvements have been made for each patch release.

  > [System Requirements](system-requirements/v74-system-requirements)
  > Review the supported backend data sources and the recommended minimum system requirements for installing RadiantOne. 

  > [Migration Utility](migration-utility/01-introduction)
  > Learn how to migrate your existing RadiantOne configuration from a development/QA environment to a production environment.

  > [Applying Patches](migration-utility/applying-patch)
  > Learn how to patch your RadiantOne v7.4 service.

</section>

## RadiantOne Integration

<section>
  
  > [Server Configuration](sys-admin-guide/01-introduction)  
  > Learn how to use the Control Panel to integrate identity data silos and define global server settings.
  
  > [Global Identity Builder](global-identity-builder-guide/introduction)  
  > Learn how to use the Global Identity Builder tool for creating a virtual view that aggregates identities from multiple data sources into a unique reference list. 
  
  > [Global Identity Viewer](global-identity-viewer-guide/01-introduction)  
  > Learn how to use the Global Identity Viewer tool for keyword searching and reporting on users and groups associated with Global Identity Builder projects.
  
  > [Directory Proxy Views](namespace-configuration-guide/03-virtual-view-of-ldap-backends/)  
  > Learn how to configure proxy virtual views from LDAP and Active Directory data sources.
  
  > [Model Driven Virtual View](context-builder-guide/introduction)  
  > Learn how to configure flexible, model-driven virtual views from identity source backends using a variety of design elements such as label, content, and container nodes.
  
  > [Operational Attributes](operational-attributes-guide/01-overview)  
  > Learn about the operational attributes used by RadiantOne Federated Identity to handle functionality for authorization enforcement, password policies, replication...etc.
  
  > [Identity Data Analysis](data-analysis-guide/01-introduction)  
  > Learn how the Identity Data Analysis tool can generate a report for each of your data sources to provide insight on the quality of your data.
  
  > [Troubleshooting](logging-and-troubleshooting-guide/01-overview)  
  > Learn about the structure and contents of the log files associated with Identity Data Platform.
  
  > [Monitoring & Reporting](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor the services, configure alerts for concerning activities, and access the default reports (Access, Audit and Group Audit).
  
  > [Deployment & Tuning](deployment-and-tuning-guide/00-preface)  
  > Learn the best practices approaches for deploying and tuning the service.
    
</section>

 
## RadiantOne Directory

<section>
  
  > [Configuration](namespace-configuration-guide/05-radiantone-universal-directory)  
  > Learn how to create directory stores and manage all configuration properties related to indexing, attribute encryption, and replication.

  > [Deployment & Tuning](deployment-and-tuning-guide/00-preface)  
  > Learn the best practices approaches for deploying and tuning the directory.
  
  > [Operational Attributes](operational-attributes-guide/01-overview)  
  > Learn about the operational attributes used by the directory to handle functionality for authorization enforcement, password policies, replication...etc.
  
  > [Troubleshooting](logging-and-troubleshooting-guide/01-overview)  
  > Learn about the structure and contents of the log files.
  
  > [Monitoring & Reporting](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor the directory, configure alerts for concerning activities, and access the default reports (Access, Audit and Group Audit).
 
  > [ACI Migration](aci-migration-guide/overview)  
  > Learn how to migrate ACIs from legacy LDAP directories like OpenDJ, Novell eDirectory, IBM Tivoli Directory and SunOne (Oracle ODSEE) to the RadiantOne Directory.
  
</section>


## RadiantOne Synchronization

<section>
  
  > [Introduction](global-sync-guide/introduction)  
  > Learn about synchronization including detailed architecture, key concepts and common use cases for the tool.
 
  > [Configuration](global-sync-guide/configuration/overview)  
  > Learn how to configure synchronization pipelines and create transformation logic using a combination of scripting, attribute mappings and advanced rules.

  > [Connector Properties](connector-properties-guide/overview)  
  > Learn how to configure change capture connectors for detecting and processing changes from data sources.

  > [Deployment & Tuning](global-sync-guide/deployment)  
  > Learn the best practices approaches for deploying and tuning synchronization.
  
  > [Troubleshooting](logging-and-troubleshooting-guide/05-global-synchronization)  
  > Learn about the structure and contents of the log files associated with synchronization.
  
  > [Monitoring](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor synchronization and configure alerts for concerning activities.
  
  > [Password Filter](password-filter-guide/01-overview)  
  > Learn how to use the Password Filter component to synchronization passwords from accounts in Active Directory to other directory targets.
  
</section>

## RadiantOne CFS

<section>

  > [Introduction](cfs/01-getting-started)
  > Learn about key concepts and system requirements for CFS. 

  > [Installation](cfs/01-getting-started)
  > Learn how to install CFS Master and create your first CFS tenant.

  > [Configuration](cfs/02-configuration)
  >Learn how to configure identity providers, applications, and smart links. 

  > [Deployment](cfs/04-deployment)
  > Learn the best practices approaches for deploying CFS.

  > [Troubleshooting](cfs/05-troubleshooting)
  > Learn how to use the CFS Log Analyzer. 

</section>

</tabpanel>

<tabpanel>

## Data Management APIs 

A rich set of HTTP-based API's have been developed on top of LDAP, to provide broader access to the Universal directory, using modern protocols, such as SCIM, SPML and other web services API's, are described in this section

<section>
  
  > [SCIM](web-services-api-guide/04-scim)  
  > The System for Cross-domain Identity Management (SCIM) specification automates user identity management between identity domains. 
  
  > [REST](web-services-api-guide/05-rest)  
  > The REST interface supports all LDAP operations and the ability to navigate the directory tree. Wrapping these operations and the progressive disclosure capabilities that exist in LDAP directories into a REST interface opens it up to the web.
   
</section>

## DevOps 

<section>
  
  > [Docker](getting_started/docker)  
  > Learn how to automate your deployment of RadiantOne in your cloud using Docker containers.
  
  > [Kubernetes](getting_started/kubernetes)  
  > Learn how to automate your deployment of RadiantOne using Kubernetes orchestration. 
  
   
</section>

## Configuration APIs

<section>
  
  > [API Specification](command-line-configuration-guide/01-introduction)
  > Learn how to configure RadiantOne from command line.
  
</section>

## Interception and Transformation Scripting API

<section>
  
  > [Javadocs](javadoc/allclasses-frame)
  > The API documentation applicable for customizing interception scripts in RadiantOne FID and transformation scripts in RadiantOne Global Synchronization.
  
</section>

</tabpanel>

</tabpanels>
</tabs>
