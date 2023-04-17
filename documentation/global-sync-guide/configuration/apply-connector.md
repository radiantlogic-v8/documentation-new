---
title: Apply connector
description: Get a quick introduction to the apply connector process in Global Synchronization.
---

# Apply connector

The apply connector applies changes to the destination object(s). Once the transformation component is successfully configured, the Apply connector automatically starts. There is no configuration of the apply connector. The apply process leverages the [virtualization of the target](../introduction.md#architecture) as depicted in [this figure](../introduction.md#global-synchronization-architecture-figure), meaning that all changes are sent to the RadiantOne service, directed to the branch in the namespace where the virtual view of the target has been mounted.
