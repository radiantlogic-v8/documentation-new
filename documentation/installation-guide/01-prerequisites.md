---
title: Installation Guide
description: Installation Guide
---

# RadiantOne Installation Guide

## Chapter 1: Prerequisites

### RadiantOne License

To activate RadiantOne, copy your license file into <RLI_HOME>/vds_server or enter it during installation. If you have not received the license file, please contact Radiant Logic, Inc at support@radiantlogic.com.

If you are using an evaluation or subscription-based license, the Main Control Panel displays the license’s expiration date and time. Default evaluation licenses expire after 14 days. If your evaluation license expires, you can renew it by contacting Radiant Logic, Inc.

> [!note] if you already have a license.lic file and are installing the RadiantOne platform on a new machine, during the installation, choose the Skip this Step option on the license page. After the installation, copy your existing license.lic file in <RLI_HOME>/vds_server.

### Cloud Installation

If you plan to install RadiantOne in your cloud data center, on either Amazon Web Services or Azure, please see the RadiantOne AWS Cloud Installation Guide or the RadiantOne Azure Cloud Installation Guide instead of this guide.

### Minimum System Requirements

#### Windows 64-bit Platforms

Hardware
<br> Cluster nodes must be deployed on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines.

Processor: Intel Pentium or AMD Opteron. Minimum dual core.

Processor Speed: 2GHZ or higher

Network Bandwidth: Minimum 1Gbps, low latency

Memory: 16 GB minimum. For most production deployments, more than 16 GB of memory is required. For more details on sizing, see the Hardware Sizing Guide.

Hard Drive: 500 GB of disk space (the hard disk usage will vary depending on log types/levels that are enabled and the desired log history to maintain). The recommended minimum data transfer rate is 150 MB/sec.

Software
Operating Systems: Windows Server 2016, Windows Server 2019, Windows Server Core

#### Linux 64-bit Platforms

Hardware
Cluster nodes must be deployed on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines.
Processor: Intel Pentium or AMD Opteron. Minimum dual core.
Processor Speed: 2GHZ or higher

Network Bandwidth: Minimum 1Gbps, low latency

Memory: 16 GB minimum. For most production deployments, more than 16 GB of memory is required. For more details on sizing, see the Hardware Sizing Guide.
Hard Drive: 500 GB of disk space (the hard disk usage will vary depending on log types/levels that are enabled and the desired log history to maintain). The recommended minimum data transfer rate is 150 MB/sec.

Software
Red Hat Enterprise Linux v5+, Fedora v24+, CentOS v7+, SUSE Linux Enterprise v11+, Ubuntu 16+

#### DNS Settings

If deploying in a cluster, make sure DNS resolution for the cluster nodes is configured properly. Improper DNS resolution will affect ZooKeeper which oversees the cluster management. It is highly recommended that you edit the /etc/hosts file to map hostnames to IP addresses for all cluster nodes.

#### Required Ports

The following is a list of all ports which could be used by RadiantOne (could vary based on
configuration during install and product usage) and as such should be available to avoid any
potential testing/deployment issues:

Ports usable by clients to access the RadiantOne service:

- Standard LDAP: 389 or 2389 and 636 or 1636 (SSL)
- Web Services Interface HTTP Ports: 8089 and 8090 (SSL)
- JDBC (VRS): 2399
Ports used by the RadiantOne service to access backend data sources (some examples are shown below):

- LDAP directories: 389, 636 (SSL)
- SQL Server: 1433
- Derby: 1527
- MySQL: 3306
- Oracle: 1521
- Azure Active Directory: 443 (HTTPS)

Ports used for RadiantOne Administration:

- Control Panels HTTP Ports: 7070 and 7171 (SSL)

Ports used between RadiantOne internal components:

- Admin HTTP Service: 9100 and 9101 (SSL)
- Zookeeper (configuration management): 2181 (client port), 2182 (JMX), 2888 (ensemble port), 3888 (leader election port)
- Task Scheduler: 1099 (RMI registry) and another random port for RMI object (ports 49,000 - 65,000 are the standard dynamic port range, but could vary depending on OS).

#### Virtualization Platforms

RadiantOne supports the following virtualization platforms:

- Microsoft Windows Virtual Server
- Microsoft HYPER-V
- VMWare ESX
- Citrix XenServer

For details on required settings for virtual machines, please see the Hardware Sizing Guide.

#### Virus Scanners

Virus scanners can have a negative impact on performance including I/O speed and network throughput. This can result in a failure of the [system checks](02-installation#installing-a-single-node) that are performed by the RadiantOne installer. It is recommended to disable Virus Scanners while installing and/or uninstalling RadiantOne.

After installing RadiantOne, it is recommended to configure virus scanner software to not scan <RLI_HOME> files and folders and avoid scanning all RadiantOne processes (e.g. RadiantOne, Jetty which hosts the Control Panels and ZooKeeper) if possible. At a bare minimum, avoid scanning the files found under:

<RLI_HOME>\vds_server\logs folder and all files with a suffix .log
<RLI_HOME>\vds_server\data
<RLI_HOME>\apps\zookeeper\data
<RLI_HOME>\vds_server\work\main

### Expert Mode

Some settings in the Main Control Panel are accessible only in Expert Mode. To switch to Expert Mode, click the “Logged in as, (username)” drop-down menu and select Expert Mode.

![An image showing expert mode](Media/expert-mode.jpg)

>**Note - The Main Control Panel saves the last mode (Expert or Standard) it was in when you log out and returns to this mode automatically when you log back in. The mode is saved on a per-role basis.**

### Technical Support

Before contacting Customer Support, please make sure you have the following information:


- Version of RadiantOne.
- Type of computer you are using including operating system.
- The license number for your software.
- A description of your problem including error numbers if appropriate

Technical support can be reached using any of the following options:

- E-mail: support@radiantlogic.com
- Website: https://support.radiantlogic.com

