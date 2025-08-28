---
title: Feature comparison guide 
description: Compare features and plan upgrades accordingly
---


# Overview

This document provides details on deprecated features and features that may require alternatives or additional support when upgrading from v7.4 to v8.1.


## Features Deprecated in 8.1

| Feature                                                       | Where to find this feature in 7.4                                                           |  
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | 
| Server Front-End – Other Protocols (VRS)                      | Check configuration for VRS protocol usage. <br>![config example](Media/img-1.png)          | 
| ACI Settings – Level of Assurance                             | Check Access Control rules for “Level of Assurance.” <br>![config example](Media/img-6.png) | 
| Security Settings – Role Mapped Access in Proxy Views of LDAP | Review proxy view settings for role mapping.                                                |
| Wizard – Directory Tree Wizard                                | Check if it is used to create virtual identity views. <br>![config example](Media/img-12.png)                         |
| Wizard – Groups Builder Wizard                                | Check if it is used to create virtual identity views. <br>![config example](Media/img-13.png)                         | 
| Wizard – Groups Migration Wizard                              | Check if it is used to create virtual identity views. <br>![config example](Media/img-15.png)                         |
| Wizard – Merge Tree Wizard                                    | Check if it is used to create virtual identity views. <br>![config example](Media/img-14.png)                         |


## Features Available Upon Request

If you are using any of the following settings, and are moving to SaaS, let the Radiant Logic customer onboarding team know, so your tenant can be customized to support client IP address-related checking and/or client certificates checking.

- **Allowed IPs (Administration)** 
 
   ![config example](Media/img-2.png)  

- **Per Computer/IP Limits & Special IP Checks (Limits)**  

   ![config example](Media/img-5.png)  

- **IP Restrictions (ACI Settings)** 
 
  ![config example](Media/img-7.png)  

- **Mutual Authentication (Security Settings)** 

  ![config example](Media/mutual-auth.png)  


## Feature Usage Requiring Further Discussion 

If you use any of the following features in v7.4, work with Radiant Logic Customer Support team to understand your options when upgrading:

- **Synchronizing Passwords to Entra ID**

- **Using the Active Directory Password Filter**

- **Kerberos Authentication**

  ![config example](Media/img-11.png)

- **Kerberos to Backend Active Directory Data Sources**

  ![config example](Media/img-3.png)

- **Log2DB**: The Log2DB utility is discontinued in v8.1. However, pushing log files to a log aggregator like Splunk is available in Identity Data Management (SaaS & Self-managed). Self-managed deployments must set up **[their own logging](../../v8.1/installation/metrics-and-logging/)**.

- **Reporting**: Reporting is included in Environment Operations Center for SaaS deployments. Self-managed deployments should use **Prometheus (15.13.0+)** and optionally **Grafana (6.40.0+)** to generate reports from **[metrics](../../v8.1/installation/metrics-and-logging/)**.

- **Retrieving Existing Active Directory Passwords**: For SaaS deployments, this requires a Secure Data Connector to be deployed in the Active Directory network. This capability will be offered for self-managed deployments soon.





