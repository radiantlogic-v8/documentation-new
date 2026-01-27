---
title: CFS Release Notes
description: CFS Release Notes
---

## CFS Release Notes

### v3.15

January 13, 2021

If you are upgrading from CFS 3.9, you are NOT required to run the PowerShell commandlet to upgrade the schema.
CFS v3.15 supports RadiantOne FID v7.1.14 and later, with the following exceptions:
- v7.2.20
- v7.2.21
- v7.2.22

**Improvements**
-	[VSTS38868]: Improvement to use JWKs to sign the ID and Access Tokens.
-	[VSTS38997]: Standardized the OIDC Access tokens.
-	[VSTS39430]: Updated the RSA APIs used for two-factor authentication.
-	[VSTS39623]: Increase number of configured applications viewable in tenant portal to 250.
-	[VSTS39809]: Ensure FIPS140-2 compliance when FID is configured for FIPS-mode.
-	[VSTS39979]: Added support to handle the grant_type=refresh_token in OIDC.
-	[VSTS39996]: Added implicit flow support in OIDC.
-	[VSTS39998]: Added hybrid flow support in OIDC.
-	[VSTS40039]: Improvement to include the proper scope claims when requested in either ID Tokens or from the /userinfo endpoint.

### v3.15.1

July 23, 2021

If you are upgrading from CFS 3.9, you are NOT required to run the PowerShell commandlet to upgrade the schema.
CFS v3.15 supports RadiantOne FID v7.1.14 and later, with the following exceptions:
- v7.2.20
- v7.2.21
- v7.2.22

**Improvements**

-	[VSTS40091]: Added support for “groups” scope in OIDC.
- [VSTS40299]: Added support for including custom attributes for OIDC Claims in ID tokens.
-	[VSTS40311]: Added support for Proof Key for Code Exchange (PKCE) code flow in OIDC.
-	[VSTS40939]: Added support for RSA MFA during SP-initiated SSO from OIDC applications.


**Bug Fixes**

-	[VSTS39212]: Fix to include Session Management of users in OIDC.
-	[VSTS39996]: Fixed an issue with the OIDC implicit flow where the ID token was missing the at_hash claim.
-	[VSTS40039]: Fix in OIDC so that claims will be returned for the profile scope either in the ID token, or from the /userinfo endpoint when the claims are requested using an access token.
-	[VSTS41129]: Fixed special character encoding in SAML tokens to be UTF8.


### v3.16

February 17, 2022

**Improvements**

-	[VSTS36058]: CSRF Vulnerability Mitigation.
-	[VSTS40927]: Upgrade .NET Framework and Dependencies.
-	[VSTS41094]: OIDC support in CFS - Make expiration time configurable for the access token and ID token.
-	[VSTS42522]: SAML2 SSO Template for AWS SSO.
-	[VSTS41327]: Add Support for new format of IP Ranges in COT Rules.
-	[VSTS41205]: Metadata Ingest Process for SAML.
-	[VSTS41753]: Add Client Credentials flow support in CFS OAuth server.
-	[VSTS41366]: Add Validation on OIDC token lifetime + improve UI


**Bug Fixes**

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

### v3.16.1

March 4, 2022

**Bug Fixes**

-	[VSTS42691]: Fixed OIDC multi-tenancy bleed issue.
-	[VSTS42789]: Fixed OIDC /userinfo endpoint not handling OPTIONS requests.

### v3.16.2

May 20, 2022

**Improvements**

-	[VSTS42685]: Minor Improvements to OIDC functionality/UI.
-	[VSTS42111]: Updated Social Network Authentication APIs
-	[VSTS42525]: Enhanced Generic SAML 2 Import Metadata Functionality
-	[VSTS42941]: Created a utility to clear the cache manually.
-	[VSTS43246]: Updated the Application and Theme Packages Download location. The new location is https://cfs-package-gallery.dotnetteam.com.


**Bug Fixes**

-	[VSTS39685]: Fixed a problem with users being able to login to CFS Applications if they have an apostrophe character in the name (for e.g. O'Brien).
-	[VSTS42895]: Fixed a problem with the proxy not properly communicating health data back to the master.
-	[VSTS42896]: Using IIS to change ID/secret for Proxy fails.
-	[VSTS43016]: Fixed a problem with filters missing for clearing cache items.

### v3.16.3

March 31, 2023

**Improvements**

-	[VSTS44677]: Improvement to add two operational attributes (lastLogintime and lastLoginStatus) to user’s entry when certificate authentication (e.g. PIV/CAC cards) is used.

### v3.16.4

April 20, 2023

**Improvements**

-	[VSTS44677]: Improvement to use the timestamp format defined for the lastLoginTime from the RadiantOne LDAP schema (yyyyMMddHHmmss.fffZ). Also added authContextData objectClass to users authenticating with certificate and custom attributes if possible.


### v3.16.5

May 12, 2023

**Bug Fixes**

-	[VSTS45303]: Added System.memory and System.Runtime.CompilerServices.Unsafe dll files to fix issues with RTC and issues pinging FID jobs

### v3.16.6

July 28, 2023

**Improvements**

-	[VSTS45409]: Change Log type to debug for the specific exception httpException with not found action on controller that was causing log pollution for the CFS logs when using security scanning tools.
-	[VSTS45411]: Updated the New-IdpRtc powershell CFS cmdlet to reference all the possible properties when configuring a new RTC from script. Also updated the similar powershell CFS cmdlet New-IdpTrusted.


**Bug Fixes**
-	[VSTS45558]: Fixed an issue with the Name Id Format field in saml2 applications mappings where it would only show 1 value (emailaddress) instead of the list of possible values.

### v3.17.0

October 2, 2024

**Improvements**

-	[VSTS47047]: Improvement to be able to configure CFS without requiring the RadiantOne super user account.


**Bug Fixes**

-	[VSTS42991]: Fix for the duplicate entry of servers created during un-install and re-install of CFS applications.
-	[VSTS46044]: Fix 403 errors seen after too many requests in application admin interface by optimizing the LDAP connections and including pagination to avoid potential timeouts.
-	[VSTS46525]: Multiple fixes for OIDC to address error response message and better validation.
-	[VSTS46653]: JWKs alg value (RS256) is fixed to reflect IETF standards.
-	[VSTS46663]: "denyUrlSequences" configured to handle escape sequences properly with custom error pages. 

### v3.17.1

December 6, 2024

**Improvements**

-	[VSTS44477]: Improvement to notify non-password users to log in via smart card when they attempt to reset passwords.
- [VSTS46962]: When 2FA is enabled (via Yubikey or TOTP), users in the ROPC flow can authenticate without 2FA as 2FA is not supported for this flow. For all other authentication flows, users will be required to complete the 2FA process when prompted for credentials to gain access.
- [VSTS47173]: Added support for multiple audiences/recipients per application in the CFS SAML SSO integration.

### v3.17.2

February 13, 2025

**Improvements**

-	[VSTS47204]: Added support for SessionIndex in SAML based applications.
- [VSTS47205]: Added support for signing the entire SAML message.
- [VSTS47245]: Added support to disable application access requests at application level or across all applications within a tenant.

### v3.17.3

June 16, 2025

**Improvements**

- [VSTS 47426] Added support for Single Logout (SLO) in WS-Federation authentication.
- [VSTS 47470, 47479, 47501, 47502] Added pagination to improve performance across various pages:
  * Gallery page located under CFS Master > Administration > Application > Gallery  
  * Dashboard page located under CFS Master > Administration > Dashboard 
  * Applications page located under CFS System > Applications 
  * Dashboard page located under CFS System > Dashboard 

**Bug fixes** 

* [VSTS 47553] Fixed an issue with RSA failover handling and included masked OTP values in logs to enhance security.



### v3.17.4

August 05, 2025

**Bug fixes** 

- [VSTS 47556] Fixed a bug that caused failures when custom claims were used in OIDC and required dependency libraries were missing.
- [VSTS 47557] Fixed a bug that caused log failures when advanced attributes values were null.
- [VSTS 47559] Fixed a regression bug related to failover when encountering an invalid RSA endpoint, and masked logs that previously exposed OTP values.

### v3.17.5

October 30, 2025

**New Feature**

- [VSTS 47563] Added Certificate Rollover feature enabling zero-downtime certificate updates for SAML 2.0 and WS-Federation SSO applications. This enhancement allows new certificates to be staged and automatically rotated during SSO operations without service interruption.

**Bug fixes** 

- [VSTS 47560] Fixed a regression issue that caused RTC authentication to fail on versions 3.17.3 and above.
- [VSTS 47561] Fixed an issue preventing RTC and CFS Master from being installed on the same system.
- [VSTS 47562] Fixed an issue where the Disclaimer field under Login Page Customization in CFS did not save its content.

### v3.17.6

January 26, 2026

**New Feature**

- [VSTS 47563] Added granular signing configuration option for each application.

**Improvements**

- [VSTS 47565] Updated the Global Certificates UI to improve support for certificate rollover, including validation logic and certificate management features.
- [VSTS 47566] Improved password reset availability after failed login to respect user attributes such as smart card or certificate authentication.

**Bug fixes** 

- [VSTS 47564] Fixed an issue causing a 500 error due to inconsistent scope handling between CFS Master and Proxy.
- [VSTS 47568] Fixed an issue that prevented OIDC mapping edits in the UI.
 




