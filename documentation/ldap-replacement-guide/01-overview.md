---
title: LDAP Replacement Guide
description: LDAP Replacement Guide
---

# Overview

The purpose of this handbook is to provide guidance for migrating from a legacy LDAP directory (OpenDJ, SunOne/ODSEE, IBM Tivoli Directory) into the RadiantOne Universal Directory. This document provides a general overview of the migration process. The steps provided in this handbook are not exhaustive and may vary depending on the use case.

Although the RadiantOne Universal Directory supports the standard LDAP v3 RFC and closely mimics the behavior of legacy LDAP directory implementations, slight variations are possible. These variations might impact client applications. The level of impact depends on how tightly-coupled the application is with the LDAP variations implemented by the legacy LDAP directory.  In certain cases, the logic of the application might need to change. In some situations, where clients cannot change, RadiantOne’s various customization techniques (e.g. interception scripts, computed attributes…etc.) can be used to mimic the legacy directory. If you encounter this situation, reach out to support@radiantlogic.com for assistance.

This gets you all of the components needed for your replacement task. Then, the outline below details the general migration strategy. Each item is further detailed in later chapters.

[Chapter 2](02-inventory-existing-directory.md) - Inventory existing directory (schema, hierarchy, password policies…etc.)

[Chapter 3](03-import-data-into-radiantone-universal-directory.md) - Import data into RadiantOne Universal Directory

[Chapter 4](04-configure-radiantone-server-settings.md) - Configure RadiantOne server settings

[Chapter 5](05-determine-the-application-usage-and-cutover-strategy.md) - Determine the application usage and cutover strategy

[Chapter 6](06-decommission-legacy-directory.md) - Decommission legacy directory

# Expert Mode

Some settings in the Main Control Panel are accessible only in Expert Mode. To switch to Expert Mode, click the Logged in as, (username) drop-down menu and select Expert Mode. 

![An image showing ](Media/expert-mode.jpg)
 
>[!note] The Main Control Panel saves the last mode (Expert or Standard) it was in when you log out and returns to this mode automatically when you log back in. The mode is saved on a per-role basis.
