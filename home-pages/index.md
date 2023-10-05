---
title: Knowledge
description: Knowledge homepage
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
  
  > [Introduction](environment-operations-center-guide/overview)  
  > Radiant Logic’s fully managed, RadiantOne SaaS offering is built to deploy quickly and streamline configuration, maintenance, and upgrades.
  
  > [Environment Operations Center](environment-operations-center-guide/environments/environment-overview/environments)  
  > Learn how to use the Environment Operations Center as a centralized control plane to manage all RadiantOne environments.

  > [Secure Data Connectors](environment-operations-center-guide/secure-data-connectors/data-connectors-overview)  
  > Learn how to install, configure and use Secure Data Connectors as a secure way for cloud environments to selectively access on-premise identity data sources.

</section>

## RadiantOne Integration

<section>
  
  > [Introduction](architect-guide/preface)  
  > Learn about the common use cases for RadiantOne Integration capabilities including how it addresses the widespread problems of a fragmented identity data infrastructure. 
  
  > [Installation](environment-operations-center-guide/environments/environment-overview/create-an-environment)  
  > Learn how to use the Environments Operations Center to create environments and install the RadiantOne Identity Data Platform.
  
  > [Server Configuration](sys-admin-guide-rebuild/01-introduction)  
  > Learn how to use the Control Panel to integrate identity data silos into RadiantOne and define global server settings.
  
  > [Global Identity Builder](global-identity-builder-guide/introduction)  
  > Learn how to use the Global Identity Builder tool for creating a virtual view that aggregates identities from multiple data sources into a unique reference list. 
  
  > [Global Identity Viewer](global-identity-viewer-guide/01-introduction)  
  > Learn how to use the Global Identity Viewer tool for keyword searching and reporting on users and groups associated with Global Identity Builder projects.
  
  > [Proxy Virtual Views](namespace-configuration-guide/01-introduction)  
  > Learn how to configure proxy virtual views from LDAP and Active Directory data sources.
  
  > [Model Driven Virtual Views](context-builder-guide/introduction)  
  > Learn how to configure flexible, model-driven virtual views from identity source backends using a variety of design elements such as label, content, and container nodes.
  
  > [Operational Attributes](operational-attributes-guide/01-overview)  
  > Learn about the operational attributes used by RadiantOne to handle functionality for authorization enforcement, password policies, replication...etc.
  
  > [Identity Data Analysis](data-analysis-guide/01-introduction)  
  > Learn how the Identity Data Analysis tool can generate a report for each of your data sources to provide insight on the quality of your data and what is available for you to use for correlation logic to handle identity overlap. 
  
  > [Troubleshooting](logging-and-troubleshooting-guide/01-overview)  
  > Learn about the structure and contents of the log files associated with RadiantOne.
  
  > [Monitoring & Reporting](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor RadiantOne, configure alerts for concerning activities, and access the default reports (Access, Audit and Group Audit).  
  
  > [Deployment & Tuning](deployment-and-tuning-guide/00-preface)  
  > Learn the best practices approaches for deploying and tuning RadiantOne.
  
</section>


## RadiantOne Directory

<section>
   
  > [Installation](environment-operations-center-guide/environments/environment-overview/create-an-environment)  
  > Learn how to use the Environments Operations Center to create environments and install the RadiantOne Identity Data Platform.
  
  > [Configuration](namespace-configuration-guide/05-radiantone-universal-directory)  
  > Learn how to create Directory stores and manage all configuration properties related to indexing, attribute encryption, and replication.
  
  > [Deployment & Tuning](deployment-and-tuning-guide/00-preface)  
  > Learn the best practices approaches for deploying and tuning RadiantOne Directory.
  
  > [Operational Attributes](operational-attributes-guide/01-overview)  
  > Learn about the operational attributes used by RadiantOne Directory to handle functionality for authorization enforcement, password policies, replication...etc.
  
  > [Troubleshooting](logging-and-troubleshooting-guide/01-overview)  
  > Learn about the structure and contents of the log files associated with RadiantOne Directory.
  
  > [Monitoring & Reporting](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor RadiantOne Directory, configure alerts for concerning activities, and access the default reports (Access, Audit and Group Audit). 
  
</section>

## RadiantOne Synchronization

<section>
   
  > [Introduction](global-sync-guide/introduction)  
  > Learn about RadiantOne  Synchronization including detailed architecture, key concepts and common use cases for the tool.
  
  > [Installation](environment-operations-center-guide/environments/environment-overview/create-an-environment)  
  > Learn how to use the Environments Operations Center to create environments and install the RadiantOne Identity Data Platform which includes Synchronization. 
  
  > [Configuration](global-sync-guide/introduction)  
  > Learn how to configure synchronization pipelines and create transformation logic using a combination of scripting, attribute mappings and advanced rules. 
  
  > [Connector Properties](connector-properties-guide/overview)  
  > Learn how to configure change capture connectors for detecting and processing changes from data sources. 
  
  > [Deployment & Tuning](global-sync-guide/deployment)  
  > Learn the best practices approaches for deploying and tuning RadiantOne Synchronization.
  
  > [Troubleshooting](logging-and-troubleshooting-guide/05-global-synchronization)  
  > Learn about the structure and contents of the log files associated with RadiantOne Synchronization.
  
  > [Monitoring](monitoring-and-reporting-guide/01-monitoring)  
  > Learn how to monitor RadiantOne Synchronization and configure alerts for concerning activities.
  
</section>
</section>
</tabpanel>

<tabpanel>

## Data Management APIs

A rich set of HTTP-based API's have been developed on top of LDAP, to provide broader access to the Universal directory, using modern protocols, such as SCIM, SPML and other web services API's, are described in this section

<section>
  
  > [SCIM](web-services-api-guide/scim)  
  > The System for Cross-domain Identity Management (SCIM) specification automates user identity management between identity domains. 
  
  > [REST](web-services-api-guide/rest)  
  > The REST interface supports all LDAP operations and the ability to navigate the directory tree. Wrapping these operations and the progressive disclosure capabilities that exist in LDAP directories into a REST interface opens it up to the web.
   
</section>

## Configuration APIs

<section>
  
  > [API Specification](developer)
  > Coming soon
  
</section>


## Interception and Transformation Scripting API

<section>
  
  > [Javadocs](javadoc/allclasses-frame)
  > The API documentation applicable for customizing interception scripts in RadiantOne FID and transformation scripts in RadiantOne Global Synchronization.
  
</section>

</tabpanel>

</tabpanels>
</tabs>
