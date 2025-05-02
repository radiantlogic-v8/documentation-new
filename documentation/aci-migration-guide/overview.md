---
title: ACI Migration Guide
description: ACI Migration Guide
---

# Overview

Part of the process of migrating from a legacy LDAP directory to the RadiantOne Universal Directory involves handling access controls. This document describes how to migrate ACIs from OpenDJ, SunOne/Oracle ODSEE, IBM Tivoli Directory, and RadiantOne v6 into a format compatible with RadiantOne v7. ACIs from OpenDJ, SunOne/Oracle ODSEE, and RadiantOne v6 are migrated using the `aciUtils.bat` tool (`aciUtils.sh` on Unix systems).

IBM Tivoli Directory ACIs are migrated using the migration tool ibmAciMigration.bat (.sh on Unix systems). Both tools are located at
<RLI_HOME>\bin\advanced.

Additionally, this document also covers guidance on how to migrate ACIs from one RadiantOne v7.4 environment to another RadiantOne v7.4 environment. 

## How This Manual Is Organized

- [Overview](01-overview.md)  
  Provides a general summary of the ACI migration process and the required credentials.

- [OpenDJ, SunOne/Oracle ODSEE, and RadiantOne v6 ACI Migration](opendj-sunone-migration.md)  
  Explains how to use `aciUtils.bat` (`.sh` on Unix) to migrate ACIs from OpenDJ, SunOne/ODSEE, and RadiantOne v6 to RadiantOne v7.

- [IBM Tivoli Directory ACI Migration](ibm-tivoli-directory-aci-migration.md)  
  Describes how to use `ibmAciMigration.bat` (`.sh` on Unix) to migrate ACIs from IBM Tivoli Directory.

- [Migrating ACIs Between Two RadiantOne v7.4 Environments](migrating-acis.md)  
  Provides steps for migrating ACIs between RadiantOne v7.4 environments using the Control Panel.


### Require a User ID and Password to Execute Commands

Some commands parameters available in the aciUtils.bat utility are available to anyone who can launch the utility. The only exceptions here are [Bind DN](opendj-sunone-migration.md#bind-dn) and [OpenDJ Password](opendj-sunone-migration.md#password) in the aciUtils.bat utility, and the bind DN and password required for the [IBM ACI Migration](ibm-tivoli-directory-aci-migration.md#running-the-ibm-aci-migration-utility) tool. In these contexts, the RadiantOne FID super user credentials are required.

### Technical Support

Before contacting Customer Support, please make sure you have the following information:

- Version of RadiantOne.
- Type of computer you are using including operating system.
- The license number for your software.
- A description of your problem including error numbers if appropriate


Technical support can be reached using any of the following options:


- E-mail: support@radiantlogic.com
- Website: http://support.radiantlogic.com
