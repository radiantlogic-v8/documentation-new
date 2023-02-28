---
title: Architect Guide
description: Architect Guide
---

# Getting Started with RadiantOne

As discussed throughout this document, at the heart of most identity integration problems is the need for an identity service that can be accessed to search/retrieve a unique user profile that is used for authentication and authorization. RadiantOne comes equipped with not only an arsenal of advanced configuration tools to solve the most complex of cases, but also a set of wizards to help you get started in solving some of the most common problems that our customers encounter. This chapter provides a high-level overview of the RadiantOne administration consoles. The identity service wizards are also discussed along with guidance to help determine which will meet your needs.

## Control Panels

The RadiantOne Control Panels are web-based interfaces to provide remote access to the most commonly used tools and wizards. In addition, the control panels offer monitoring, access to server statistics, reports, task management, and other administration options. They can be accessed from mobile or non-mobile devices including iPods and iPads.

>[!note] To access the control panels, JavaScript must be enabled in the Internet browser you are using.

### Main Control Panel

To launch the Main Control Panel on Windows, navigate to <RL_HOME>/bin and run openControlPanel.bat. This starts the web server and launches a web browser login screen for the Main Control Panel.

To launch the Main Control Panel on UNIX/Linux, after starting the Jetty web server that hosts the Control Panel application, open an Internet Browser and use the following URL:

`http://<server>:7070/main`

The default HTTP port for the web server hosting the control panels is 7070, and the default TLS port is 7171 (you can set the ports during the RadiantOne install).

The login page displays two fields, Username and Password. Enter your credentials you defined during the installation of RadiantOne.

![Main Control Panel Login Page](Media/login-page.png)

Figure 1: Main Control Panel Login Page

The following tabs are accessible from the Main Control Panel.

**Dashboard**

The dashboard tab is displayed upon successfully logging in to the Main Control Panel. There are two sections on the Dashboard tab: Overview and Internode Health. The Overview section displays the status of all nodes, and it indicates whether each node is the cluster’s RadiantOne leader (yellow-colored triangle beside the server name). You can start and stop the service from here as long as the Jetty web server is running on the node (and as long as the RadiantOne service is not installed to run as a service). This section also displays the status of ZooKeeper (ZK) port, ZooKeeper SSL port (ZK SSL), the RadiantOne service’s LDAP and LDAPS ports, the RadiantOne service’s Web Services HTTP and HTTPS ports, and VRS (SQL port).

![The Overview section of the Main Control Panel’s Dashboard tab](Media/Image5.2.jpg)

Figure 2: The Overview section of the Main Control Panel’s Dashboard tab

The Internode Health Section contains information about ZooKeeper and the RadiantOne service’s LDAP port connectivity among cluster nodes. If you have a single node deployed, this section is not applicable. Use the legend to select the connectivity state you are interested in:
ZooKeeper and/or LDAP.

![Cluster Nodes Depicted in the Health Section](Media/Image5.3.jpg)

Figure 3: Cluster Nodes Depicted in the Health Section

**Settings**

The Settings tab is where you will manage the majority of RadiantOne settings. This includes server front end and backend settings, SSL, logs, reporting, alerts, memory cache and alert settings. All changes on this tab are shared/affect all nodes if a cluster architecture is deployed.

**Context Builder**

The Context Builder is used to create model-driven virtual views. For details on Context Builder, see the RadiantOne Context Builder Guide.

**Directory Namespace**

The Directory Namespace tab is where you can configure and manage root naming contexts and persistent cache. This tab is not accessible on [follower-only](high-availability-and-performance.md#follower-only-nodes) cluster nodes.

Different icons represent various types of configurations associated with the Root Naming Contexts. For details on the icons and the meaning, please see the Namespace Configuration Guide.

**Directory Browser**

The Directory Browser tab is a client interface where an administrator can view the contents of the various RadiantOne naming contexts and manage entries and attributes (create, update, delete). This tab offers search and export functions as well.

**Wizards**

All Identity Service Wizards can be launched from the Wizards tab. Details on the usage of each wizard can be found in the [Identity Service Wizards](#identity-service-wizards) section.

**PCache Monitoring**

The PCache Monitoring Tab can be used to monitor periodic and real-time persistent cache
refresh.

On the PCache Monitoring Tab, a list of cache refresh topologies appears on the left.

![real-time refresh](Media/Imagerealtimerefresh.jpg) is the symbol for a real-time refresh.

![periodic refresh](Media/ImagePeriodicRefresh.jpg) is the symbol for a periodic refresh.

When you select a refresh topology, the persistent cache refresh components are shown on the right where you can see the number of messages processed by each component. Clicking on a component allows you to see the status and access the properties.

**Replication Monitoring**

RadiantOne Universal Directory (HDAP) stores across multiple sites/data centers support multi-master replication. This type of replication is referred to as inter-cluster replication. The state of inter-cluster replication can be monitored from the Replication Monitoring Tab.

**Global Sync**

The Global Sync tab is for managing synchronization pipelines and monitoring their activities. You can also set connector properties and perform uploads from here. For details on Global Sync, see the RadiantOne Global Sync Guide.

**ZooKeeper**

From the ZooKeeper tab, you can view configuration files maintained in ZooKeeper. Certain configuration files like the vds_server.conf can be edited from here as well by clicking on the Edit Mode button. The entire ZooKeeper configuration can also be exported from here (for keeping a backup copy) by clicking on the Export button.

### Server Control Panel

To open the Server Control Panel, click the Server Control Panel icon located at the top of the Main Control Panel's Dashboard tab. The Server Control Panel opens in a new browser tab and the user currently logged into the Main Control Panel is automatically signed into the Server Control Panel.

The following tabs are accessible from the Server Control Panel.

**Dashboard**

The Dashboard tab displays detailed server-level statistics in each section. To change the time frame for data displayed in the graphs, click the Graph range drop-down menu and select a value. Graphs for the following items are displayed.

- CPU of the machine hosting RadiantOne.
- Memory usage of the RadiantOne service
- Disk Space on the machine hosting RadiantOne
- Disk Latency on the machine hosting RadiantOne
- Connection usage to RadiantOne

**Usage & Activity**

From the Usage & Activity tab, you can access information about the RadiantOne software version installed on the node, monitor the current connections and operations, view statistics for all RadiantOne Universal Directory (HDAP) stores and view network latency between nodes (only applicable to cluster deployments).

<!-- 

**Settings**

The server name and server certificates can be managed from the Settings tab.

-->

**Tasks**

The Tasks tab allows you to start and stop the scheduler and manage defined tasks. When you perform various actions in the tools or wizards, like importing an LDIF file to initialize a persistent cache for example, a notification appears alerting you that the task has been defined and added to the scheduler. These tasks can be viewed and updated in the task list section of the Tasks tab. You can define a task as re-occurring in addition to setting to execution interval. You can also configure the task to run inside a dedicated JVM and specify any custom JVM parameters required.

**Log Viewer**

The Log Viewer Tab is the console where you can view all RadiantOne log files.

### Related Material

- RadiantOne System Administration Guide

## Identity Service Wizards

RadiantOne includes a set of wizards to assist administrators with some of the most common configuration tasks. They are designed to guide administrators through the identity integration process. This includes tasks such as building a unique user list, how to handle group entries (migrate them or create dynamic groups), and how to design the virtual namespace (flat tree or merge into an existing hierarchy). Each wizard is tailored for specific use cases, depending on the needs of the applications that will be consuming the identity. For more information on the wizards, please see the sections below.

>[!note] for step-by-step instructions on using the wizards, please see the RadiantOne Identity Service Wizards Guide.

### Global Identity Builder

The Global Identity Builder is used to build an integrated list of identities from multiple heterogeneous data sources. This process establishes a common index (union) and reference list for all identities. The result of this process is a virtual view containing a unique list of identities from multiple data sources which are extended with all relevant attributes required to comprise a global profile, with information remapped into whatever format the client application expects.

The Global Identity Builder should be used in situations where applications require a single source to locate all users required for authentication and/or need to access a complete user profile for attribute-based authorization. It should be used in cases where the data sources contain overlapping users whether there is a single existing common identifier. It can also be used in cases where there are no overlapping users but a complete aggregated flat list of users is required. At the end of the Global Identity Builder process, a persistent cache is configured and initialized for the identity data. Configure a cache refresh strategy from the Main Control Panel > Directory Namespace tab > Cache node.

### Groups Builder Wizard

The Groups Builder Wizard is used to manage virtual views for defining groups and members. With this wizard, you can define rules for dynamically creating groups from multiple heterogeneous data sources. Administrators can utilize this wizard to either create auto-generated groups or user-defined groups.

When creating user-defined groups, you specify a group name and who you want the members of this group to be. The members can either be explicitly defined by looking for specific user accounts to add, or dynamically defined based on an LDAP filter where any user matching the filter populates the group.

When defining auto-generated groups, the group name is generated based on a specified attribute available in user entries. An administrator will select which attribute contains the possible group names. For example, if all user entries contained a location attribute, possible group names could be determined by creating a unique list of all possible locations. The list will then be the basis for creating the group names. The group members are then dynamically defined based on who contains this attribute value.

For more information on user-defined and auto-generated groups please see the [Design Considerations](virtual-view-design.md#design-considerations) section of this guide.

The Groups Builder wizard should be used in situations where applications are accessing RadiantOne FID to retrieve groups/membership for enforcing authorization and a list of applicable groups either does not currently exist in any backend data source or the existing groups are insufficient because they lack all the required members. This wizard should be used if there is the need to add new members into existing groups or if there is the need to build entirely new global groups containing members from multiple different data sources.

### Groups Migration Wizard

The Groups Migration Wizard is used to import existing LDAP groups from data sources into RadiantOne FID. In LDAP directories, the "address" (DN) for the user and group entries are static. Existing group membership references user DNs, the naming of which are based on the structure of the LDAP directory. When you model a new directory namespace with virtualization, the group identity DNs will change. Therefore, the group members must reference the new naming. The group migration wizard assists you with the effort of translating the existing group membership to match the new name.

The Groups Migration wizard can be used in situations where applications are accessing RadiantOne FID to retrieve groups/membership for enforcing authorization and a list of applicable groups exists in a backend data source. The existing groups and users (who are members of these groups) should be virtualized in the virtual namespace. Then, the Groups Migration wizard is used to migrate and translate the group member DNs to match the new naming structure of RadiantOne FID.

### Merge Tree Wizard

The Merge Tree Wizard is used for merging multiple data sources into a single RadiantOne FID naming context, while maintaining the underlying directory hierarchy. The wizard helps you build a virtual view that not only creates a unique list of users across multiple sources, but also allows you to join common users based on different criteria (on a DN or an LDAP filter).

The Merge Tree Wizard should be used in cases where applications are expecting to find information in an explicit hierarchy which already exists in a backend LDAP directory and there is a need to extend a part of this hierarchy with additional information from other data sources. The Merge Tree Wizard helps you create the view that maintains the existing hierarchy and allows you to append/extend this hierarchy with information from other data sources. A basic example is depicted in the diagram below.

![Example of Merging Tree](Media/Image5.4.jpg)

Figure 4: Example of Merging Trees

### Directory Tree Wizard

The Directory Tree Wizard walks you through the process of defining a new directory tree and
allows you to create a virtual view which aggregates multiple types of backends (a combination
of LDAP and database). Once created, the naming context stores entries from these different
backends in separate organizational units, containers, organizations, and domains.

![Example of a Directory tree Comprised of an Aggregation of Three Sources](Media/Image5.5.jpg)

Figure 5: Example of a Directory tree Comprised of an Aggregation of Three Sources

### Related Material

- RadiantOne Identity Service Wizards Guide