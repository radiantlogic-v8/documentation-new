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

## INTRODUCTION

<section>
  
  > [Architecture](introduction/architecture-overview)  
  > Learn about the components and capabilities that comprise the RadiantOne Identity Data Management architecture. 
  
  > [Admin Tools](introduction/admin-tools-overview)  
  > Learn about the two main administration tools used in Identity Data Management: The Environment Operations Center and the Main Control Panel.
  
  > [Concepts](introduction/concepts)  
  > Learn the concepts related to configuring Identity Data Management.
  
  
</section>


## INSTALLATION and INITIAL SETUP

<section>
   
  > [Deployment Options](installation/deployment-options)  
  > Learn about subscribing to Identity Data Management as SaaS and options for deployment as a self-managed platform.
  
  > [Configuring Environment Operations Center](installation/configure-eoc)  
  > Learn how to log into the Environment Operations Center and perform the initial configuration required for delegated administration.
  
  > [Creating Environments](installation/create-environments)  
  > Learn how to create environments and install Identity Data Management.
  
  > [Configuring Secure Data Connectors](installation/configure-sdc)  
  > Learn how to configure secure data connectors for integrating with identity sources in your on-premises or provide cloud networks.
      
</section>

## CONFIGURATION

<section>
   
  > [Data Sources](configuration/data-sources/data-sources)  
  > Learn how to use the Data Catalog to connect to and extract identity source metadata. This is the first step to creating views.
  
  > [Identity Views](configuration/identity-views/identity-views)  
  > Learn how to create views that are comprised of attributes from one or more identity data sources. 
  
  > [Directory Stores](configuration/directory-stores/directory-stores)  
  > Learn how to configure RadiantOne Directory stores. 
  
  > [Synchronization](configuration/synchronization/synchronization-concepts)  
  > Learn how to configure synchronization to keep identity data accurate and up-to-date across silos. 
  
  > [Global Settings](configuration/global-settings/global-settings)  
  > Learn about configuring joins, interception scripts, client protocols and more.
  
  > [Security](configuration/security/security)  
  > Learn about securing Identity Data Management with access controls, password policies, attribute encryption and more.
    
</section>

## DEPLOYMENT

<section>
   
  > [Architectures](deployment/deployment-topics)  
  > Learn about basic production architectures.
  
  > [Migrating to Production](deployment/deployment-topics/migrating-configuration)  
  > Learn how to migrate configuration from a testing environment to production. 
  
  > [Managing Services](deployment/deployment-topics/managing-services)  
  > Learn how stop, start and restart the service. 
     
</section>

## TUNING

<section>
   
  > [Limits](tuning/tuning-limits)  
  > Learn about using limits to tune the Identity Data Management service.
  
  > [Identity Views](tuning/optimize-views)  
  > Learn how to optimize identity views including how to configure and manage persistent cache. 
  
  > [Directory Stores](tuning/directory-stores)  
  > Learn about tuning properties for Directory Stores. 
     
</section>

## MONITORING AND ALERTS

<section>
   
  > [Monitoring in Control Panel](monitoring-and-alerts/monitoring-and-alerts/monitoring-in-control-panel)  
  > Learn about Monitoring capabilities built into the Control Panel.
  
  > [Monitoring in Environment Operations Center](monitoring-and-alerts/monitoring-and-alerts/monitoring-in-eoc)  
  > Learn about Monitoring capabilities built into the Environment Operations Center. 
  
  > [Alerts](monitoring-and-alerts/monitoring-and-alerts/configuring-alerts)  
  > Learn how to configure integrations to support alerts triggered by monitored activities. 
     
</section>

## TROUBLESHOOTING

<section>
   
  > [Managing Log Levels](troubleshooting/troubleshooting/managing-log-levels)  
  > Learn how to manage log levels.
  
  > [Understanding Logs](troubleshooting/troubleshooting/understanding-logs)   
  > Understanding log contents to assist with troubleshooting. 
  
</section>

## REPORTING

<section>
   
  > [Creating Reports](reporting/reporting)  
  > Learn about basic reporting capabilities in RadiantOne Identity Data Management.
  
</section>


## MAINTENANCE

<section>
   
  > [Applying Patches](maintenance/applying-patches)  
  > Learn how to apply patches to an environment to update the version of RadiantOne Identity Data Management.
  
  > [Performing Backups](maintenance/managing-environments/performing-backups)  
  > Learn how to backup environments. 
  
  > [Scaling Nodes](maintenance/scaling-nodes)  
  > Learn how to scale the number of nodes in an environment. 

  > [Restarting Environments](maintenance/managing-environments/restarting-environments)  
  > Learn how to restart environments. 
     
  > [Deleting Environments](maintenance/managing-environments/deleting-environments)  
  > Learn how to delete environments. 

</section>

</section>
</tabpanel>

<tabpanel>

## Data Management APIs

A rich set of HTTP-based API's have been developed on top of LDAP, to provide broader access to the RadiantOne service. 

<section>
  
  > [SCIM](web-services-api-guide/scim)  
  > The System for Cross-domain Identity Management (SCIM) specification automates user identity management between identity domains. 
  
  > [REST](web-services-api-guide/rest)  
  > The REST interface supports all LDAP operations and the ability to navigate the directory tree. Wrapping these operations and the progressive disclosure capabilities that exist in LDAP directories into a REST interface opens it up to the web.
   
</section>

## Configuration APIs

<section>
  
  > COMING SOON!
  
</section>


## Interception and Transformation Scripting API

<section>
  
  > [Javadocs](javadoc/allclasses-frame)
  > The API documentation applicable for customizing interception scripts and transformation scripts.
  
</section>

</tabpanel>

</tabpanels>
</tabs>
