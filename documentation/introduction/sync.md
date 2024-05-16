---
title: Introduction to the Synchronization Architecture
description: Learn about the components and capabilities that comprise the synchronization component.
---

## Synchronization

RadiantOne Synchronization offers bi-directional synchronization across data sources that have been integrated into the RadiantOne platform.

Connectors are used for synchronization and have three main functions.

1. Query data sources and collect changed entries.
2. Filter unneeded events.
3. Publish changed entries with the required information (requested attributes).

Synchronization flows are configured as a set of pipelines that dictate the source and target. 

Global Synchronization pipelines can be started from the Main Control Panel > Global Syn tab. Select the topology from the list on the left. Click **RESUME** to start synchronization for all pipelines. 

![An image showing ](Media/Image6.1.jpg)

If a topology has more than one pipeline, you can start synchronization for each independently. To resume a single pipeline, click CONFIGURE and select the APPLY component. Click RESUME.

![An image showing ](Media/Image6.2.jpg)
