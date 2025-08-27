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

> [!warn]> Important Note - if you are using any of the following settings, and are moving to SaaS, ensure you let the customer onboarding team know, so your tenant can be customized to support IP address-related and/or client certificates checking.

**IP Access Controls**

Following IP-based settings can be configured by Radiant Logic on a case-by-case basis. Contact support for assistance.

**Allowed IPs (Administration)**  
  ![config example](Media/img-2.png)  

**Per Computer/IP Limits & Special IP Checks (Limits)**  
  ![config example](Media/img-5.png)  

**IP Restrictions (ACI Settings)**  
  ![config example](Media/img-7.png)  

**Mutual Authentication (Security Settings)** 


## Feature Usage Requiring Further Discussion 

If you use any of the following features in v7.4, work with Radiant Logic Customer Support team to understand your options when upgrading:

### Log2DB

The Log2DB utility is discontinued in 8.1. However, logging feature is still available in 8.1. Self-managed deployments must set up **[their own logging](../../v8.1/installation/metrics-and-logging/)**.

### Reporting
Reporting is included in Environment Operations Center for SaaS deployments. Self-managed deployments should use **Prometheus (15.13.0+)** and optionally **Grafana (6.40.0+)** to generate reports from **[metrics](../../v8.1/installation/metrics-and-logging/)**.

### Caching Existing Active Directory Passwords

Caching Existing Active Directory Passwords - For SaaS deployments, this requires a Secure Data Connector to be deployed in the Active Directory network. This capability will be offered for self-managed deployments soon.

### NTLM Authentication 

### Kerberos Authentication

### Kerberos to Backend Active Directory Data Sources

### Synchronizing Passwords to Entra ID 

### Using the Active Directory Password Filter



