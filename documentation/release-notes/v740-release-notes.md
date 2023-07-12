---
title: v7.4.0 Release Notes
description: v7.4.0 Release Notes
---

# RadiantOne v7.4.0 Release Notes

February 14, 2022

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[New Features](#new-features)

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## New Features

-	[VSTS39486]: Revamped the ICS architecture to replace GlassFish and OpenMQ components with services built into RadiantOne. This new synchronization component is named the Global Sync module.

- [VSTS41222, 41431]: Added a new section in the Main Control Panel (Settings -> Server Front End -> SCIM) for configuring RadiantOne as a SCIMv2 service. New schemas, resource types, and attribute mappings can be managed here.

- [VSTS40337]: Added new deployment and automation resources to our Git repository. These include Docker, Kubernetes, Helm and Terraform artifacts for deploying the RadiantOne Platform on a Kubernetes cluster.

## Improvements

-	[VSTS37056]: Integrated Context Builder into the Main Control Panel (new tab) and removed the old Eclipse plugin version.

-	[VSTS41676]: Improved vds_server.log contents to make cascading LDAP operations traceable in the server logs across nodes.

-	[VSTS41752]: Added csrf header names and values to the directory browser HTTP queries.

-	[VStS42259]: Default evaluation license term changed to 30 days.

-	[VSTS42427]: Added Context Builder audit log settings to log settings page and added context builder audit log level property to log4j2-control-panel.json in ZooKeeper.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Servers Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base at https://support.radiantlogic.com.

## Known Issues/Important Notes

-	The following options have been removed from Context Builder-Schema Manager: Default Attribute Mapping editor, Load LDAP Schema (for mappings)

-	The following options have been removed from Context Builder-View Designer: Default Views Generator, Sentence View tab, Verb parameter, Add to Context Catalog button, Virtual Tree Generation, and Data Source Management. 

-	The SCIMv1 API to RadiantOne has been deprecated. Only SCIMv2 is supported. SCIMv2 URLs have changed between v7.3 and v7.4. Please reference the Web Services API Guide in v7.4 for examples on querying RadiantOne via SCIMv2.

-	For synchronization, rules-based transformation templates are not included. They are planned for a future v7.4 patch release.

-	The installation process has changed. There are no longer .exe and .bin installer files. A zip file is provided for Windows, and a tar file for Linux. After the files are extracted to the location where you want RadiantOne to be installed, you can use either a web-based install (use \radiantone\vds\bin\setup.bat/.sh) or install-sample.properties with Instance Manager to install in a silent mode. See the RadiantOne Installation Guide for details.

-	RadiantOne-specific environment variables used/set during installation are no longer used. You will not have or need RLI_HOME or RLI_JAVA_HOME.

For known issues reported after the release, please see the Radiant Logic Knowledge Base:
https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

