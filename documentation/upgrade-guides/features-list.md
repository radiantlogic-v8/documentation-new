---
title: Feature Comparison Guide 
description: Compare features and plan upgrades accordingly
---


## Upgrade Checklist: Upgrading from 7.4 to 8.1

| **Item / Feature** | **Where to find this feature in 7.4** | **Action to Take** | **Availability in 8.1 (SaaS / Self-managed Identity Data Management)** |
|---------------------|--------------------------|--------------------|---------------------------------------|
| **Server Front-End – Other Protocols (VRS)** | Check configuration for VRS protocol usage. <br>![VRS config example](Media/img1.png)   | Contact Support for alternatives. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Administration – Allowed IPs** | Review load balancer/firewall IP restriction settings. | SaaS customers can coordinate with SaaS team; Self-managed Identity Data Management customers can configure it via their load balancer. | SaaS: Supported with customization; Self-managed: Supported |
| **RadiantOne as SAML Attribute Service** | No UI setting; contact Support if unsure. | Contact Support for alternatives. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Advanced – Custom RootDSE** | No UI setting; contact support if unsure. | Contact Support to review use case. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Data Source – Kerberos to Backend AD** | Review Data Source settings for Kerberos authentication. | Contact Support to assess migration. | Not included in 8.1 UI (SaaS & Self-managed Identity Data Management) |
| **Internal Connections – Use SSL** | Check Internal Connections in Control Panel. | SaaS: Interim config by SaaS Ops; Self-managed Identity Data Management: Configure directly. | Supported in both SaaS and Self-managed Identity Data Management |
| **Limits – Per Computer/IP Address / Special IP Checking** | Review load balancer/firewall IP restriction settings. | SaaS: Work with SaaS team; Self-managed Identity Data Management: Configure directly. | SaaS: Supported with customization; Self-managed Identity Data Management: Supported |
| **ACI Settings – Level of Assurance** | Check Access Control rules for “Level of Assurance.” | Contact Support for alternatives. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **ACI Settings – IP Restriction** | Check Access Control rules for “Allowed IP.” | SaaS: Work with SaaS team; Self-managed Identity Data Management: Configure directly. | SaaS: Supported with customization; Self-managed Identity Data Management: Supported |
| **Security Settings – Mutual Authentication** | Check Security Settings for “REQUIRED” or “REQUESTED.” | SaaS: Coordinate with SaaS team; Self-managed Identity Data Management: Configure directly. | Supported in both SaaS and Self-managed Identity Data Management |
| **Security Settings – Role Mapped Access in Proxy Views of LDAP** | Review proxy view settings for role mapping. | Contact Support for alternatives. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Security Settings – CRL** | Check CRL configuration in Security Settings. | SaaS: Coordinate with SaaS team; Self-managed Identity Data Management: Configure directly. | Supported in both SaaS and Self-managed Identity Data Management |
| **Authentication – NTLM** | Review authentication configuration. | Contact Support if in use. | Not supported in SaaS or Self-managed Identity Data Management |
| **Authentication – Kerberos** | Review authentication configuration. | Contact Support if in use. | Not supported in SaaS or Self-managed Identity Data Management |
| **AD Password – Caching AD Passwords** | No UI setting; contact Support if unsure. | None if unused. | SaaS: Supported via SDC; Self-managed Identity Data Management: Not supported |
| **AD Password – Sync to Entra ID** | No UI setting; contact Support if unsure. | Contact Support; requires Windows, not supported yet. | Not supported in SaaS or Self-managed Identity Data Management |
| **AD Password – Password Filter** | No UI setting; contact Support if unsure. | Contact Support; update planned for v8.1. | Not supported until update (SaaS & Self-managed Identity Data Management) |
| **Wizard – Directory Tree Wizard** | Check if used in workflows. | Contact Support for updated processes. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Wizard – Groups Builder Wizard** | Check if used in workflows. | Contact Support for updated processes. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Wizard – Groups Migration Wizard** | Check if used in workflows. | Contact Support for updated processes. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Wizard – Merge Tree Wizard** | Check if used in workflows. | Contact Support for updated processes. | Deprecated in both SaaS and Self-managed Identity Data Management |
| **Radiant SSO – CFS** | No UI setting; contact Support if unsure. | No action if unused. | Not available in SaaS or Self-managed Identity Data Management |
| **Logging – Log2DB** | Check logging configuration for database storage. | Migrate to fluentd/ElasticSearch or other aggregator. | SaaS: fluentd/ElasticSearch; Self-managed Identity Data Management: Similar setup possible |
| **Reporting – Access, Audit, Groups Audit Reports** | Check if reports are used. | Move to Prometheus (15.13.0+) and optionally Grafana (6.40.0+). | Supported in both; infrastructure changed |

