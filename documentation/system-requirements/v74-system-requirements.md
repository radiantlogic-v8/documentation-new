---
title: System Requirements
description: System Requirements
---

This document describes the supported backend data sources and the recommended minimum system requirements for installing RadiantOne v7.4.X.

For detailed memory requirements for specific configurations, please see the [RadiantOne Hardware Sizing Guide](/hardware-sizing-guide/01-introduction).

## Supported Identity Data Sources

### LDAP Directory Servers	

- Microsoft Active Directory 2008, 2012, 2016, 2019, 2022
- Active Directory Lightweight Directory Service (AD-LDS)
- Active Directory Application Mode (ADAM)
- SunONE Directory Server 4.X – 7.X
- Sun Java System Directory v6.X
- IBM Directory Server v5(+)
- Novell eDirectory v8(+)
- IBM Domino (formerly Lotus Domino)
- Oracle Internet Directory v9 & v10, Oracle   Directory Server Enterprise Edition (ODSEE)
- CA Directory r12.X
- Any LDAP v3 Service

### Database Servers	

- Oracle 8i, 9i, 10g, 11g, 12c
- Microsoft SQL Server v2008, v2012, v2016, v2017
- IBM DB2 (UDB) v7(+)
- Sybase v12 and 12.5
- MongoDB
- Snowflake
- Terradata
- Any JDBC/ODBC-accessible database

### Cloud Directory Services

- Entra ID (formerly Azure AD)
- PingOne
- Okta Universal Directory

### Applications/Other**

- SAP
- Siebel v7.5+
- Oracle Financials v12+
- Salesforce
- Google Apps/Directory
- SharePoint 2010, 2013, 2016 (on-premises)
- Workday
- Concur
- Any SCIM-accessible Service
- Other
    - 	Web Services
    - 	RACF
    -	ACF2
    -	Top Secret
    -	Java API
    -  	Microsoft NT Domain

>[!warn] ** All of these require customization. Consult your Radiant Logic Account Representative for details.

## System Requirements

### Supported Client Access Protocols

- LDAP
- Web Services (SCIM, REST)

### DNS Settings

If running in a cluster, you must make sure DNS resolution for the cluster nodes is configured properly. Improper DNS resolution will affect ZooKeeper which is in charge of the cluster management. It is highly recommended that you edit the /etc/hosts file to map hostnames to IP addresses for all cluster nodes. 

### Firewall Ports

The following is a list of all ports which could be used by RadiantOne (could vary based on configuration during install and product usage) and as such should be opened to avoid any potential testing/deployment issues:

Standard LDAP: 2389 and 636 (SSL)

RadiantOne Main Control Panel HTTP Ports: 7070 and 7171 (SSL)

RadiantOne FID Admin HTTP Service: 9100 and 9101 (SSL)

Zookeeper (configuration management): 2181 (client port), 2182 (JMX), 2888 (ensemble port), 3888 (leader election port)

Web Services Interface HTTP Ports: 8089 and 8090 (SSL)

Any ports required to access backends: e.g. LDAP directories: 389, 636 (SSL), SQL Server: 1433, Derby: 1527, MySQL: 3306, Oracle: 1521

### Supported Load Balancer

For cluster deployments, an F5 load balancer (or similar LDAP-aware load balancer) is required to perform load balancing across the RadiantOne nodes (between the client applications and RadiantOne cluster nodes).

## Supported Platforms

### Supported Virtualization & Container Platforms

If RadiantOne will be running on a virtual machine, the minimum recommendations detailed in the platform specific sections (Windows Platforms and Linux Platforms) are what should be allocated for the virtual machine. It should be noted that these minimums may not be sufficient for a production environment.

RadiantOne supports the following virtualization platforms:

-	Microsoft Windows Virtual Server
-	Microsoft HYPER-V
-	VMWare ESX
-	Citrix XenServer

For other sizing considerations related to running RadiantOne on virtual machines, please see the [RadiantOne Hardware Sizing Guide](/hardware-sizing-guide/01-introduction).

RadiantOne supports the following container platforms:

-	Docker containers running in Kubernetes.

** The design, installation, configuration, and testing of a Kubernetes deployment may require a Professional Services engagement with Radiant Logic. To discuss your Kubernetes deployment, recommendations, and best practices, contact your Radiant Logic Account representative.

### RadiantOne Nodes

Hardware

Cluster nodes must be deployed on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines.

Processor: Intel Pentium or AMD Opteron. Minimum dual core.

Processor Speed: 2GHZ or higher

Network Bandwidth: Minimum 1Gbps, low latency

Memory: 16 GB minimum. For most production deployments, more than 16 GB of memory is required. For more details on sizing, see the [RadiantOne Hardware Sizing Guide](/hardware-sizing-guide/01-introduction).

Hard Drive: 500 GB of disk space, SSD (the hard disk usage will vary depending on log types/levels that are enabled and the desired log history to maintain in addition to quantity of HDAP stores and Persistent Cache configurations). The recommended minimum data transfer rate is 150 MB/sec.

Software

Operating Systems: Windows Server 2012 R2, Windows Server 2016, Windows Server 2019, Windows Server Core, Windows Server 2022, Red Hat Enterprise Linux v5/v6/v7/v8+, Fedora v24+, CentOS v7+, SUSE Linux Enterprise v11+, Ubuntu 16+

### ZooKeeper Nodes:

Hardware

Cluster nodes must be deployed on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines. For production environments, it is recommended that the ZooKeeper nodes be installed separate from the RadiantOne FID nodes.

Processor: Intel Pentium or AMD Opteron. Minimum dual core.

Processor Speed: 2GHZ or higher

Network Bandwidth: Minimum 1Gbps, low latency

Memory: 8 GB minimum. 

Hard Drive: 50 GB of disk space, SSD. The required minimum data transfer rate is 100 MB/sec.

Software

Operating Systems: Windows Server 2012 R2, Windows Server 2016, Windows Server 2019, Windows Server Core, Windows Server 2022, Red Hat Enterprise Linux versions 5,6,7,8+, Fedora v24+, CentOS v7+, SUSE Linux Enterprise v11+, Ubuntu 16+
