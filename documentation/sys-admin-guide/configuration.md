---
title: System Administration Guide
description: System Administration Guide
---

# Configuration

In the configuration section, versions of RadiantOne configuration files can be viewed, the LDAP schema can be managed, ORX schema files can be viewed and used to extend the LDAP schema. These topics are discussed below.

## LDAP Schema

The LDAP schema associated with RadiantOne can be managed from here. For details on managing and extending the schema, see [RadiantOne LDAP Schema](radiantone-ldap-schema).

## ORX Schema

One part of the virtualization process performed by RadiantOne is schema/metadata extraction from backend sources. The metadata information is stored in XML files containing an .orx extension in the file names. The object and attribute definitions contained in these .orx files can be used to extend the RadiantOne LDAP schema. For details on managing and extending the schema from objects and attributes in .orx files, see [RadiantOne LDAP Schema](radiantone-ldap-schema).

## Configuration Lock

The RadiantOne super user account (e.g. cn=directory manager) and members of the cn=directory administrators group (cn=directory administrators,ou=globalgroups,cn=config) can enable a lock on all configuration changes. This ensures that no changes are being made while the configuration is being backed up and/or migrated. To lock the configuration, navigate to Main Control Panel > Settings > Configuration > Configuration Lock. Toggle the Configuration Changes property to the Locked position. Click **Save**.

When the configuration is locked, no one can make changes to the RadiantOne configuration (either from the UI or command line tools). In the UI, an ![An image showing ](Media/Image3.148.jpg) icon appears at the top of the Control Panel, configuration options are read-only, and FID can be restarted but not stopped. Command-line operations that display information still function, but operations that modify the configuration do not. Only the RadiantOne super user, or a member of the cn=directory administrators group, can unlock the configuration. When they log into the Control Panel, there is a message along with a button, prompting them to unlock the configuration.

When other users log into the Control Panel, there is a message prompting the user to contact the Directory Manager to unlock the configuration. 

![An image showing ](Media/Image3.149.jpg)
 
Figure 1: Message Displayed for Locked Configuration
