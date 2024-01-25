---
title: CFS v3.15.1 Release Notes
description: CFS v3.15.1 Release Notes
---

# CFS v3.15.1 Release Notes

July 23, 2021

These release notes contain important information about improvements and bug fixes for CFS v3.15.1. Note that if you are upgrading from CFS 3.9, you are NOT required to run the PowerShell commandlet to upgrade the schema.
CFS v3.15.1 supports RadiantOne FID v7.1.14 and later, with the following exceptions:
- v7.2.20
- v7.2.21
- v7.2.22


These release notes contain the following sections:

[Improvements](#improvements)

[Bug Fixes](#bug-fixes)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS40091]: Added support for “groups” scope in OIDC.
-       [VSTS40299]: Added support for including custom attributes for OIDC Claims in ID tokens.
-	[VSTS40311]: Added support for Proof Key for Code Exchange (PKCE) code flow in OIDC.
-	[VSTS40939]: Added support for RSA MFA during SP-initiated SSO from OIDC applications.


## Bug Fixes

-	[VSTS39212]: Fix to include Session Management of users in OIDC.
-	[VSTS39996]: Fixed an issue with the OIDC implicit flow where the ID token was missing the at_hash claim.
-	[VSTS40039]: Fix in OIDC so that claims will be returned for the profile scope either in the ID token, or from the /userinfo endpoint when the claims are requested using an access token.
-	[VSTS41129]: Fixed special character encoding in SAML tokens to be UTF8.
 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

