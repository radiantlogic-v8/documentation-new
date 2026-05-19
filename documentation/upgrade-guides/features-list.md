---
title: Feature comparison guide 
description: Compare features and plan upgrades accordingly
---


# Overview

This document provides details on deprecated features and features that may require alternatives or additional support when upgrading from v7.4 to v8.1.


## Features Deprecated in 8.1

The following features have been deprecated and are no longer available in v8.1 of Identity Data Management. If you have any questions about these features, reach out to the Radiant Logic Customer Support team.

| Feature                                                       | Where to find this feature in 7.4                                                             |  
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | 
| Global Identity Viewer | The Global Identity Viewer was accessible using `https://<RadiantOnehost>:7171/portal/login`
| Server Front-End – Other Protocols (VRS), <br> SAML Attribute Service, SPML and DSML have also been deprecated.                   | Check configuration for VRS protocol usage. <br> <br> ![config example](Media/img-1.png) <tr></tr>      | 
| ACI Settings – Level of Assurance                             | Check Access Control rules for 'Level of Assurance.' A value other than 0 indicates that this feature is being used. <br> <br> ![config example](Media/img-6.png) <tr></tr>   | 
| Security Settings – Role Mapped Access in Proxy Views of LDAP | Review proxy view settings for role mapping. <br> <br> ![config example](Media/img-role.png) <tr></tr>                                                  | 
| Wizard – Directory Tree Wizard                                | Check if it is used to create virtual identity views. In v8, you can use Directory Namespace to create your tree. <br> <br> ![config example](Media/img-12.png) <tr></tr>  |
| Wizard – Groups Builder Wizard                                | Check if it is used to create virtual identity views. In v8, you can use Directory Browser to create dynamic groups. <br> <br> ![config example](Media/img-13.png) <tr></tr>  | 
| Wizard – Groups Migration Wizard                              | Check if it is used to create virtual identity views.  In v8, you can use Directory Namespace to create views of existing groups and either DN remapping or a computed attribute to remap group members. <br> <br> ![config example](Media/img-15.png) <tr></tr>  |
| Wizard – Merge Tree Wizard                                    | Check if it is used to create virtual identity views. In v8, you can use Directory Namespace to create your merged tree. <br> <br> ![config example](Media/img-14.png)  <tr></tr> | 



## Features Available Upon Request

If you are using any of the following settings, and are moving to SaaS, let the Radiant Logic Support team know, so your tenant can be customized to support client IP address-related checking and/or client certificates checking. In self-managed deployments, customers are responsible for configuring their own load balancer with the required passthrough logic so that client IP addresses can be captured and used for IP-based access controls. <br> <br>

1. **Allowed IPs (Administration)** 
  
    ![config example](Media/img-2.png)  
   
    Review if you have enabled this feature. A value of "0" means this feature is inactive. If the value is set to one or more IP addresses, it means that you are using this feature. <br> <br>


2. **Per Computer/IP Limits & Special IP Checks (Limits)**  

    ![config example](Media/img-5.png)  

    Review if you have enabled any of the highlighted options in the image. <br> <br>
  

3. **IP Restrictions (ACI Settings)** 
 
    ![config example](Media/img-7.png)  
   
    Review if you have enabled Allow IP option for any IP addresses. <br> <br>

4. **Mutual Authentication (Security Settings)** 

    ![config example](Media/mutual-auth.png)  
   
    Review if you have enabled this feature. If the value is set to NONE, the feature is inactive. If it is set to any other option, it means that you are currently using this feature. <br> <br>


## Feature Usage Requiring Further Discussion 

If you have enabled any of the following features in v7.4, work with Radiant Logic Customer Support team to understand your options when upgrading:

1. **Synchronizing Passwords to Entra ID** <br> <br>

2. **Using the Active Directory Password Filter** <br> <br>

3. **Kerberos Authentication** 

    ![config example](Media/img-11.png)
    
    Review if this authentication is enabled. <br> <br>
   
4. **Kerberos to Backend Active Directory Data Sources**

    ![config example](Media/img-3.png)
    
    Review if you have configured a Kerberos profile in your LDAP data source. <br> <br>

5. **Log2DB**: The Log2DB utility is discontinued in v8.1. However, pushing log files to a log aggregator like Splunk is available in Identity Data Management (SaaS & Self-managed). Self-managed deployments must set up **[their own log aggregator](../../v8.1/installation/metrics-and-logging/)**. <br> <br>

6. **Reporting**: Reporting is included in Environment Operations Center for SaaS deployments. Self-managed deployments should use **Prometheus (15.13.0+)** and optionally **Grafana (6.40.0+)** to generate reports from **[metrics](../../v8.1/installation/metrics-and-logging/)**. <br> <br>

7. **Retrieving Existing Active Directory Passwords**: For SaaS deployments, this requires a Secure Data Connector to be deployed in the Active Directory network. This feature will be supported in self-managed deployments soon. <br> <br>

8. **Custom Authentication Providers**: The UI configuration is being refactored and not available in v8.1+. <br>

   ![custom authentication provider config in v7.4](Media/customauthpro.jpg)<br>

   An interception script configured ON BIND can easily be used in v8.1+ during the interim.<br>

    ![intereception script v8.1](Media/intscriptbind.jpg)<br>
   

9. **CPLDS**: RadiantOne v7.4 includes a Capture Process for Large numbers of distributed Directory Stores (CPLDS). This feature leverages components known as Workers to detect changes in source LDAP directories, Active Directories, or LDIF files and refreshes a RadiantOne Directory (HDAP) replica. To find out if you are using this feature, navigate to your directory namespace and check if the process is enabled under Distributed Directories Aggregation. <br>

   ![config example](Media/cplds.png) <br> <br>

   




