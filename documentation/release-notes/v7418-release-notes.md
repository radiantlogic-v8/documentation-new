---
title: v7.4.18 Release Notes
description: v7.4.18 Release Notes
---

# RadiantOne v7.4.18 Release Notes

September 11, 2025

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4.

These release notes contain the following sections:

[Supported Platforms](#supported-platforms)

[Security Vulnerability Fixes](#security-vulnerability-fixes)

[Critical Bug Fixes](#critical-bug-fixes)

[Bug Fixes](#bug-fixes)

[Known Issues/Important Notes](#known-issuesimportant-notes)

[Patch Installers](#patch-installers)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)


## Improvements


- [IV4-88]: Added a maintenance mode screen under the Monitoring section in the Control Panel that allows users to turn on maintenance mode and avoid alerts during this period.
- [IV4-98,SQ-419]: Improved the privileges for the Global Identity Viewer, so that there are separate capabilities for the 'globalidviewer-write'   
privilege.
- [IV4-104]: Variety of improvements to the computed attributes dialog window related to reordering, activating and validating. 
- [IV4-111, SQ-420]: Added the onPremisesSyncEnabled attribute to the default schema for backends defined using the mgraph custom data source.
- [IV4-126,SQ-469]: Added a feature to `vdsconfig` command that allows to export a single topology (with related contexts). Topology name should be specified in the format "source_context->target_context". Example command: `./vdsconfig.sh resource-export -name "ou=some,o=context->o=another_context."
- [IV4-127,SQ-474]: Improved the privileges for the Global Identity Viewer so that a user, which is a member of a group which has the "globalidviewer-read" VdPrivilege assigned, cannot access the Main Control Panel.
- [IV4-131,SQ-496]: Made an improvement so that attributes in the sync pipeline logs are now masked based on the Attribute Handlings setting in Control Panel > Settings > Server Frontend. 
- [IV4-136,SQ-492]: Added support for application/json content type for all SCIM endpoints.
- [IV4-151,SQ-540]: Made an improvement so the title rows in the Main Control Panel are visible all of the time.
- [IV4-162]: Added support to show the bind context for all LDAP operation requests and responses in the vds_server_access.log when enableAccessLoggingWithWhoDidThat is set to true in ZooKeeper (at /radiantone/<version>/<clusterName>/config/vds_server.conf) 
- [IV4-178]: Added support for OpenJDK 8u462.
- [IV4-200]: Improved attribute masking functionality in the vds_server logs for queries on the cn=queue naming context.
- [IV4-221, SQ-621]: Made an improvement so that the pipeline default alerts are now generated with a UUID alert ID to prevent alert IDs with too many characters.
- [IV4-237]: Made an improvement so that the default pipeline alerts are created with a filter on the pipeline ID.
- [IV4-252,SQ-567]: Made an improvement so that the Instance Manager allows the ZK password to be passed in as an encrypted value in install.properties.
- [IV4-268,SQ-672]:  Improved attribute masking functionality in InstanceManager logs.
- [IV4-290, SQ-292]: Improved the adap_access.log to respect attribute masking parameter when vdsconfig is called through ADAP.


## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019, 2022

-	Windows Servers Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

-	Oracle Enterprise Linux 7/8/9

For specific hardware requirements of each, please see: [System Requirements](https://developer.radiantlogic.com/idm/v7.4/system-requirements/v74-system-requirements/)


## Security-Vulnerability-Fixes

- [IV4-135]: Updated the Control Panel to serve static resources for the directory browser tab in order for the proper response headers to be included to address CVE-2018-5164.
- [IV4-181]: Upgrade Axios to address CVE-2021-3749, CVE-2025-27152, CVE-2023-45857 and CVE-2024-57965.
- [IV4-185, IV4-218, SQ-630]: Updated the Kafka-Clients library to 3.9.1 to address CVE-2025-27817,CVE-2025-27818, and CVE-2025-27819.
- [IV4-186]: Updated the Commons Beanutils library to 1.11.0 to address CVE-2025-48734.
- [IV4-187]: Updated Commons-Fileupload library to 1.6.0. to address CVE-2025-48976.
- [IV4-191]: Updated Apache CXF libraries to 3.5.11 to address CVE-2025-48795.
- [IV4-192]: Updated Apache CXF libraries to version 3.5.11 to address CVE-2025-23184.
- [IV4-193, IV4-194, IV4-195]: Updated Jetty libraries to version 9.4.57.v20241219 to address CVE-2024-6763,CVE-2024-8184, CVE-2024-13009 and CVE-2024-9823.


## Bug Fixes

- [IV4-66,SQ-395]: Fixed an issue where the underlying backend error message was not propagated to the client when Pass Through Authorization is set on a cached proxy-view.
- [IV4-87]: Fixed an issue where the changes on member-group did not take effect immediately on the group based ACI enforcement.
- [IV4-89]: Fixed the self-signed certificate generation and checking by the ZooKeeper to ignore case sensitivity during the check for erroneous hostnames.
- [IV4-90]: Fixed the broken delete groups button in the Groups Builder Wizard.
- [IV4-92]: Fixed parsing bugs in SCIM patch request handling and improved schema enforcement.
- [IV4-103,IV4-109,SQ-431]: Fixed an issue by introducing a sync state flag to prevent new nodes from publishing and overwriting files on existing nodes.
- [IV4-116,SQ-459]: Fixed an issue where the LDAP Controls were not getting passed to the backend when a persistent cache on a proxy view was used.
- [IV4-120,SQ-470]: Fixed an issue by adding validation to ensure invalid certificates are not able to be imported into the client certificate truststore.
- [IV4-128]: Fixed an issue so that unsaved changes modal should only show up whenever changes in the connection string form have not been saved.
- [IV4-132,SQ-437]: Fixed an issue where password policy related operational attributes were not synchronized proper in persistent cache when they got changed in the backend.
- [IV4-133,SQ-484]: Fixed an issue where Pass-Thru Authorization was not working properly on the cached view of ldap proxies.
- [IV4-144,SQ-495]: Fixed an issue where the ACI performance got degraded for searches on large group entries.
- [IV4-147,SQ-521]: Fixed an issue where the computed attributes button was not working properly on the join wizard. 
- [IV4-149]: Fixed an issue where the confirmation windows were not displayed as expected when the naming context was deactivated.
- [IV4-150,SQ-534]: Fixed an issue by updating the add-aci CLI tool to fail if the base DN search fails for the target DN.
- [IV4-157]: Fixed an issue to properly mask some attribute data in vds_server.log when creating users in Entra ID through a virtual view.
- [IV4-161, SQ-553]: Fixed an issue so that now the sync pipeline script displays build process results upon saving.
- [IV4-177,SQ-594]:  Fixed an issue where the password policy was not working properly for accounts created without password.
- [IV4-209, SQ-609]: Fixed an issue by optimizing adaptive synchronization mode to trigger less changes for repeated attribute values.
- [IV4-213]: Fixed an issue where the Control Panel UI becomes unresponsive when deactivating a proxy naming context.
- [IV4-222,SQ-621]: Fixed an issue that caused the migration tool to crash when alert names were too long.
- [IV4-223]: Fixed an issue where clicking on the "Help" opens the Main Control Panel. The admin portal help link has been updated to point to developer.radiantlogic.com where documentation is located.
- [IV4-228]: Fixed an issue causing the context builder popup dialogs to sometimes malfunction.
- [IV4-253, SQ-453]: Fixed an issue with CRL checking via OCSP when in FIPS-mode. Since the new library is currently being recertified by NIST CMVP for FIPS 140-3, customers can use it at their discretion. ccj-4.0.0-fips.jar is the current, default NIST-certified library for FIPS 140-3 used, and ccj-4.0.1-prevalidation-fips.jar is the newer library that contains the CRL checking via OCSP fix. To use the new ccj-4.0.1-prevalidation-fips.jar library, update the following property in ZooKeeper (at `/radiantone/<version>/<clusterName>/config/vds_server.conf`) to a value of true and restart all RadiantOne services. 
usingPrevalidationFipsJar: true 

- [IV4-272]: Fixed an issue in the schema editor UI where the most recent popup was being opened upon saving the schema.
- [IV4-274, SQ-719]: Fixed an issue by Updating the Salesforce JDBC driver to exit early if not a valid Salesforce JDBC URL to avoid outputting an unrelated log message on test connection failures.
- [IV4-283]: Fixed an issue where the SCIM page incorrectly triggers unsaved changes confirmation without modifications.
- [IV4-289]: Fixed permissions issue for schema manager where certain delegated admin roles weren't being authorized properly.
- [IV4-296]: Fix for the mgraph custom object to use select query when performing one level and subtree searches to ensure all required attribute are retrieved from Entra ID.


## Known Issues/Important Notes

- CRL checking via OCSP when in FIPS-mode does not work and returns this error: javax.net.ssl.SSLHandshakeException: PKIX path validation failed: java.security.cert.CertPathValidatorException  <br> This issue has been fixed in v7.4.18, tracked in release notes item IV4-253. Customers must indicate to use the new library by settings usingPrevalidationFipsJar: true in Zookeeper at `/radiantone/<version>/<clusterName>/config/vds_server.conf`

-If the environment variable RLI_CLI_VERBOSE is set to false, it must be temporarily set to true during product installation or update. Failure to do so may result in an incomplete or failed installation.
After the installation or update completes successfully, the variable may be reverted to false if desired.
If RLI_CLI_VERBOSE is not defined, or is already set to true, no action is required.


For known issues reported after the release, please see the [Radiant Logic Knowledge Base](https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues).  


## Patch Installers

To download the patch, click [here](https://files.radiantlogic.com/receive/?packageCode=IX0qTSRyilShjhpxusLWpUDzzb4rduq2tO9F81NhEt4#keycode=Niad1bODfyRmdW8PlGO-5In0mdRKsa0u6551qXXI1rA)

Once logged in, navigate to: Customer Downloads/update_installers/7.4/<PatchVersion>/

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com.

