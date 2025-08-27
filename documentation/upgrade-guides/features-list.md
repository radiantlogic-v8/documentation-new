---
title: Feature comparison guide 
description: Compare features and plan upgrades accordingly
---


# Feature comparison guide

This document provides details on deprecated features and features that may require alternatives or additional support when upgrading from v7.4 to v8.1.


## Features deprecated in 8.1

| Feature                                                       | Where to find this feature in 7.4                                                           | Availability in 8.1                                                   |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Server Front-End – Other Protocols (VRS)                      | Check configuration for VRS protocol usage. <br>![config example](Media/img-1.png)          | Deprecated|
| ACI Settings – Level of Assurance                             | Check Access Control rules for “Level of Assurance.” <br>![config example](Media/img-6.png) | Deprecated|
| Security Settings – Role Mapped Access in Proxy Views of LDAP | Review proxy view settings for role mapping.                                                | Deprecated|
| Wizard – Directory Tree Wizard                                | Check if used in workflows. <br>![config example](Media/img-12.png)                         | Deprecated|
| Wizard – Groups Builder Wizard                                | Check if used in workflows. <br>![config example](Media/img-13.png)                         | Deprecated|
| Wizard – Groups Migration Wizard                              | Check if used in workflows. <br>![config example](Media/img-15.png)                         | Deprecated|
| Wizard – Merge Tree Wizard                                    | Check if used in workflows. <br>![config example](Media/img-14.png)                         | Deprecated|

## Features that may need additional considerations 

Some features that were available in v7.4 are not readily available in the v8.1 UI and require additional customization on a case by case basis. If you rely on any of these, you may need to work with Radiant Logic Customer Support team to configure them:  

### 1. IP Access Controls

Following IP-based settings can be configured by Radiant Logic on a case-by-case basis. Contact support for assistance.

- **Allowed IPs (Administration)**  
  ![config example](Media/img-2.png)  

- **Per Computer/IP Limits & Special IP Checks (Limits)**  
  ![config example](Media/img-5.png)  

- **IP Restrictions (ACI Settings)**  
  ![config example](Media/img-7.png)  


### 2. Logging and Reporting

- **Log2DB** is discontinued in 8.1. However, logging feature is still available in 8.1. Self-managed deployments must set up **[their own logging](../../v8.1/installation/metrics-and-logging/)**.
- Reporting feature is supported in SaaS with updated infrastructure. Self-managed deployments should use **Prometheus (15.13.0+)** and optionally **Grafana (6.40.0+)** to generate reports from **[metrics](../../v8.1/installation/metrics-and-logging/)**.

### 3. Authentication and AD Password Management

These features can be used with subject to the considerations described below:
- **AD Password – Caching** is supported in SaaS only via Secure Data Connector.
- **Mutual Authentication (Security Settings)** is supported in 8.1 but requires additional customization in SaaS. Reach out to Radiant Logic Customer Support team for assistance related to this feature. 

Theese features are currently not supported in 8.1. Contact Radiant Logic support team to discuss your use cases/ alternatives. 

- **NTLM Authentication** 
- **Kerberos Authentication**
- **Kerberos to Backend AD (Data Source)** 
- **AD Password – Sync to Entra ID** 
- **AD Password – Password Filter**








