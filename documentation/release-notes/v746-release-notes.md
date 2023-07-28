---
title: v7.4.6 Release Notes
description: v7.4.6 Release Notes
---

# RadiantOne v7.4.6 Release Notes

May 15, 2023

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections: 

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Server Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base at: https://support.radiantlogic.com

## Bug Fixes

-	[VSTS45314]: Fixed an issue where the Global Identity Builder would not load properly by fixing the CSP nonce value.

-	[VSTS45318]: Fixed an issue with editing MOTD by allowing support for line breaks.

## Known Issues

Related to [VSTS44715] in the v7.4.4 Release Notes: The following error appears when using the RadiantOne web UI for applying the v7.4.4 patch. This error is only seen when updating from v7.4.2 or v7.4.3 to v7.4.4 using the web UI. ERROR com.rli.install.web.filters.ExceptionFilter:36 - Caught unexpected exception.

To avoid this issue, use the command line method to apply the patch. For more details, see https://support.radiantlogic.com/hc/en-us/articles/12795702674964-Known-Issue-Updating-from-v7-4-3-to-v7-4-4 

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact:

support@radiantlogic.com
