---
title: ACI Migration Guide
description: ACI Migration Guide.
---

# Overview

Part of the process to migrate from a legacy LDAP directory into RadiantOne Universal
Directory involves access controls. This document describes migrating OpenDJ, SunOne/Oracle
ODSEE, IBM Tivoli Directory, and RadiantOne v6 ACI into ACI compatible with RadiantOne v7.
ACI in OpenDJ, SunOne/Oracle ODSEE and RadiantOne v6 formats are migrated using the
migration tool, aciUtils.bat (.sh on Unix systems). IBM Tivoli Directory ACIs are migrated using
the migration tool ibmAciMigration.bat (.sh on Unix systems). Both tools are located at
<RLI_HOME>\bin\advanced.

## How the Manual is Organized

[Overview](01-overview.md)

This chapter provides a general review of the ACI migration process and describes credential requirements related to the process.

[OpenDJ, SunOne/Oracle ODSEE and RadiantOne v6 ACI Migration](opendj-sunone-migration.md)

This chapter describes how to migrate OpenDJ, SunOne/Oracle ODSEE and RadiantOne vACI to RadiantOne v7 using the aciUtils.bat (.sh on Unix systems) tool.

[IBM Tivoli Directory ACI Migration](ibm-tivoli-directory-aci-migration.md)

This chapter describes how to migrate IBM Tivoli Directory ACI to RadiantOne v7 using the ibmAciMgration.bat (.sh on Unix systems) tool.

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
- Phone: 415-209-6800
- Toll-Free Phone: 1-877-727-6442
- Fax: 415-798-5697
