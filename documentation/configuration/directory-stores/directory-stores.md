---
title: RadiantOne Directory Stores
description: Introduction to RadiantOne Directory stores and how to create them. 
---

## Overview

RadiantOne Identity Data Management offers a scalable directory storage that can be used to store any entries. After the root naming context is created, the local store can be populated from an LDIF file or using the Control Panel > Manage > Directory Browser.

Once a directory store is mounted at a naming context, a properties tab is available for managing the configuration. To access the properties tab, select the node representing the directory storage below the Root Naming Contexts section on the Control Panel > Setup > Directory Namespace > Namespace Design.

INSERT IMAGE

>[!warning] 
>Although persistent cache leverages the RadiantOne Directory as a storage, the functionality and configuration can vary slightly. For steps on configuring persistent cache and details on applicable properties, see [Tuning](../../tuning/persistent-cache).

## Creating Directory Stores

1.	On the Control Panel > Setup > Directory Namespace > Namespace Design click ![An image showing ](Media/new-naming-context.jpg).

2.	Enter the new naming context label and click **SAVE**.

3.	Click ![An image showing ](Media/mount-backend.jpg).

4.	Choose the **RadiantOne Directory** type and click **SELECT**.
5.	Choose to activate the store or not (it can be activated later after it has been initialized).
6.	Click **MOUNT**.

The new naming context appears in the list of root naming contexts. Populate the directory by importing an LDIF file or manually adding entries using the Directory Browser. See [Initializing Directory Stores](managing-directory-stores) for more information.
