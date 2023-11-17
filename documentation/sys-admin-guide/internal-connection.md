---
title: Internal Connections
description: Internal Connections
---

# Internal Connections

These settings define how RadiantOne accesses itself (internally) as a client. This can happen in some cases where interception scripts or joins are used. 

>[!note] The settings in this section are accessible only in [Expert Mode](01-introduction#expert-mode).

Three advanced settings applicable to internal connections to the RadiantOne service are, Use SSL, Disable Referral Chasing and Paged Results Control. These are each described in more details below.

![An image showing ](Media/Image3.79.jpg)
 
Figure 19: Internal Connection to RadiantOne

## Use SSL

RadiantOne leverages an internal connection to the LDAP port for performing joins configured in virtual views. If the non-SSL LDAP port is turned off in RadiantOne, and the internal connection must connect via SSL, check the Use SSL option. Click **Save** to apply the changes to the server.

## Disable Referral Chasing 

By default, RadiantOne attempts to chase referrals that have been configured in the underlying LDAP server (if for internal connections when calling itself as an LDAP server). If you do not want RadiantOne to chase referrals when searching the underlying LDAP server, then you should enable the Disable Referral Chasing option. Click Save to apply the changes to the server.

## Paged result controls

If you enable the Paged Results Control option, RadiantOne (as a client to itself) requests the result of a query in chunks (to control the rate at which search results are returned). After enabling the Paged Results Control, indicate the page size you want to use. Click **Save** to apply the changes to the server.

This functionality can be useful when RadiantOne (as a client to itself) has limited resources and may not be able to process the entire result set from a given LDAP query. Verify that support for the [Paged Results Control](/03-front-end-settings#paged-results-control) is enabled RadiantOne to use this option for the internal connection.

## Idle Timeout

Connections made internally, when RadiantOne is a client to itself, are configured with a default idle timeout length of 6 hours. This value is configurable in ZooKeeper. From the Main Control Panel > ZooKeeper tab, navigate to /radiantone/v1/cluster/config/vds_server.conf. Click Edit Mode and locate the "idleTimeoutForLocalConnection" property. Define the idle timeout value (in seconds) for this property. Click **Save**.

>[!warning] The idleTimeoutForLocalConnection property must always be greater than the [Global Idle Timeout](#idle-timeout), otherwise the Global Idle Timeout takes precedence for closing the internal connections as well as the external (client) connections.

## Persistent Cache Initialization Location

Initialization of a persistent cache happens in two phases. The first phase is to create an LDIF formatted file of the cache contents (if you already have an LDIF file, you have the option to use this existing file as opposed to generating a new one). If you choose to generate a new LDIF file during the initialization wizard, you can indicate a file location for it to be generated. The second phase is to initialize the cache with the LDIF file.

After the first phase, RadiantOne prepares the LDIF file to initialize the cache. This could include re-ordering some entries to enforce parent-child relationships, re-formatting entries…etc. and leverages the Persistent Cache Initialization Location setting. This can be defined on the Main Control Panel > Settings Tab > Server Backend section > Internal connections sub-section. The value should be the location where the prepared LDIF file is written to. For the best performance (to avoid reading/writing from the same disk), this should be a different disk than where the original LDIF file was created or currently exists (the location indicated during the initialization wizard, whether you choose to generate the LDIF or browse to an existing LDIF). Ideally, the Persistent Cache Initialization Location is also a different disk than where RadiantOne is installed.

![An image showing ](Media/Image3.80.jpg)

Figure 20: Persistent Cache Initialization Location
