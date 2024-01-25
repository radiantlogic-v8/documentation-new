---
title: CFS v3.16 Release Notes
description: CFS v3.16 Release Notes
---

# CFS v3.16 Release Notes

February 17, 2022

These release notes contain important information about improvements and bug fixes for CFS v3.16.


These release notes contain the following sections:

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS36058]: CSRF Vulnerability Mitigation.
-	[VSTS40927]: Upgrade .NET Framework and Dependencies.
-	[VSTS41094]: OIDC support in CFS - Make expiration time configurable for the access token and ID token.
-	[VSTS42522]: SAML2 SSO Template for AWS SSO.
-	[VSTS41327]: Add Support for new format of IP Ranges in COT Rules.
-	[VSTS41205]: Metadata Ingest Process for SAML.
-	[VSTS41753]: Add Client Credentials flow support in CFS OAuth server.
-	[VSTS41366]: Add Validation on OIDC token lifetime + improve UI


## Bug Fixes

-	[VSTS41148]: OIDC Configuration URL Validation for Known Tenants.
-	[VSTS41204]: Fix an Issue in which CFS was unrecoverable if the RadiantOne service was absent for a period of time.
-	[VSTS42163]: The phone_number_verified and email_verfied claims in OIDC tokens are Returned as Boolean Instead of String.
-	[VSTS42325]: Fix an Issue where including equals sign (=) would break searching for users if their User Identifier is something like entryDn.
-	[VSTS41893]: Form validation for OIDC breaks when encountering sufficiently complex passwords.
-	[VSTS42486]: OIDC through CFS Proxy Fails.
-	[VSTS41226]: Fixed an issue with creating new users with invalid email address.
-	[VSTS41227]: Fixed an Issue with Creating New OpenID Connect Application.
-	[VSTS41229]: Add New CoT Rule - Validation and UI Issue.
-	[VSTS41231]: Fix an Issue in the General Settings tab for CFS Master.
-	[VSTS41232]: Fix a Validation Issue in the CFS Master Administration Section for Web Portal Customization.
-	[VSTS41263]: Fixed a Validation Issue in CFS Master Login/Password Pass through Authentication Section.
-	[VSTS41228]: Fix an Issue where duplicate Custom Claims Could be Added for OIDC Mappings.
-	[VSTS41367]: Fix an Issue where Saving a new OIDC Application didn't Save the Parameters.
-	[VSTS42382]: Fix an Issue where Enabling/Disabling a user in the Users tab was not properly displaying.
-	[VSTS42383]: Fix an Issue where Disabling a Login/Password Authentication option and deleting fields still showed deleted fields after Save.
-	[VSTS42398]: Fix an Issue where messages were improperly displayed when a user goes through forgot password process.
-	[VSTS42401]: Fix an Issue where the /system/System/Server/Access page was broken.



## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

