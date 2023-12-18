---
title: Create Topologies
description: Learn how to create topologies
---

## Create topologies

After all synchronization source and target objects are represented in the RadiantOne directory namespace and the LDAP Schema contains all object definitions, synchronization topologies can be configured from the Classic Control Panel > Synchronization tab.

To load the Classic Control Panel, click the logged in account profile in the upper-right and click Switch to Classic Control Panel.

1. Navigate to the Synchronization tab.
1. Select **New Topology**.
1. Select **Browse for the Source Naming Context** and select the location in the RadiantOne namespace that contains the source objects you want to detect change events on.
1. Select **Browse for the Destination Naming Context** and select the location in the RadiantOne namespace that contains the destination objects that you want to synchronize change events to. In the example shown below, the source objects are located in `o=companydirectory` (representing an LDAP directory backend) and the target is `object=EMPLOYEES,o=hrdatabase` (representing a table named `EMPLOYEES` in an HR database).
    ![Example Topology Definition](../media/image22.png)
1. Select **OK**. The topology is added to the list on the left and the pipelines associated with the selected topology are shown on the right where the components can be configured.
This section focuses on configuring the connector type. For details on the behavior of and properties for database connectors (Timestamp, Counter, Changelog), LDAP connectors (changelog or persistent search), and Active Directory connectors (usnChanged or DirSync), please see the RadiantOne Connector Properties Guide.
1. A pipeline represents a synchronization flow from a given source object and a target object endpoint. Each pipeline in the selected topology must be configured.
1. Select **CONFIGURE** next to the pipeline. There are two components that need configured per pipeline: Capture Connector and Transformation. Apply Connectors do not require configuration.
