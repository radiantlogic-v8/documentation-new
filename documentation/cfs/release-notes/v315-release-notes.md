---
title: CFS v3.15 Release Notes
description: CFS v3.15 Release Notes
---

# CFS v3.15 Release Notes

January 13, 2021

These release notes contain important information about improvements for CFS v3.15. Note that if you are upgrading from CFS 3.9, you are NOT required to run the PowerShell commandlet to upgrade the schema.
CFS v3.15 supports RadiantOne FID v7.1.14 and later, with the following exceptions:
- v7.2.20
- v7.2.21
- v7.2.22


These release notes contain the following sections:

[Improvements](#improvements)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS38868]: Improvement to use JWKs to sign the ID and Access Tokens.
-	[VSTS38997]: Standardized the OIDC Access tokens.
-	[VSTS39430]: Updated the RSA APIs used for two-factor authentication.
-	[VSTS39623]: Increase number of configured applications viewable in tenant portal to 250.
-	[VSTS39809]: Ensure FIPS140-2 compliance when FID is configured for FIPS-mode.
-	[VSTS39979]: Added support to handle the grant_type=refresh_token in OIDC.
-	[VSTS39996]: Added implicit flow support in OIDC.
-	[VSTS39998]: Added hybrid flow support in OIDC.
-	[VSTS40039]: Improvement to include the proper scope claims when requested in either ID Tokens or from the /userinfo endpoint.



## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

