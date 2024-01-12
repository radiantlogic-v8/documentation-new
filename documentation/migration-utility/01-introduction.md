---
title: Migration Utility
description: Migration Utility
---

# Introduction

Version 2.1 of the migration tool is for RadiantOne v7.4 and serves two purposes.

 >[!warning] Do not use earlier versions of the Migration Utility with v7.4.

1. First time migration of configuration from a lower (e.g. dev/QA) environment to a higher (e.g. production) environment.

   >[!note] If the target RadiantOne environment already exists, migrate new naming contexts, .orx files, .dvx files, and data sources using the vds-config utility (resource-traverse, resource-export, resource-import commands) instead of the migration tool. See the RadiantOne Operations Guide for assistance.

2. Upgrade to a new major version of RadiantOne (e.g. v7.3 to v7.4).

This guide covers #1 only. For details on using the migration utility for upgrading, see the RadiantOne Upgrade Guide applicable to the version you are moving from/to.

The migration tool (migrate.bat/.sh) is provided as a separate download. It is not included with the RadiantOne install. Contact Support (support@radiantlogic.com) for credentials and location of the Migration Utility. Download the latest migration utility from the Radiant Logic support site and unzip it on both the source machine (from where you are exporting) and the target machine (where you plan on importing). The migration tool leverages the RadiantOne configuration location identified in the <RLI_HOME> environment variable to perform the export/import of the configuration. 

>[!note] The source and target machines must be running the same operating system. This means, if you export configuration from a Windows machine, you must import this configuration onto a Windows machine. If you export configuration from a Linux machine, you must import this configuration onto a Linux machine.

## Specifying RLI_HOME

If you do not have an RLI_HOME system environment variable set, you must pass the location where you have RadiantOne installed when you run the Migration Utility.

An example of exporting configuration on Linux where RadiantOne is installed in /home/r1user/radiantone/vds, can be seen below.

 ./migrate.sh /home/r1user/radiantone/vds export test2.zip
