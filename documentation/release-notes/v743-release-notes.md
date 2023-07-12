---
title: v7.4.3 Release Notes
description: v7.4.3 Release Notes
---

RadiantOne v7.4.3 Release Notes

November 16, 2022

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4

These release notes contain the following sections: 

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS40206]: Improved the custom limits settings to avoid confusion by removing the Time Limit and Look Through Limit properties.

-	[VSTS42795]: Improved the subcluster description screen for the web-based installer to classify the two options as instance or shard.

-	[VSTS42960]: To reduce security risks, disabled HTTP trace by default for Jetty service installed with external Zookeeper.

-	[VSTS42981]: Added support for OIDC (JWT) token authentication for ADAP.

-	[VSTS43574]: Improvement for the RadiantOne audit report generation process so that it prints the progress of processing the entries and generating the report. 

-	[VSTS43893]: Improvement to add a “primary” sub-attribute to the “emails” attribute when extracting the schema for SCIMv2 backends when the schema contains an “emails-primarytype” attribute. 

-	[VSTS43918]: Improvement to reduce the memory and CPU usage required to convert large dynamic groups to static when refreshing the persistent cache.

-	[VSTS43919]: Added support for Kafka queues as capture and apply components in Global Sync module.

-	[VSTS43970/44478]: Added support for retrieving user and entitlement data from Saviynt as a backend data source. A custom data source named saviynt is included in the RadiantOne installation.

-	[VSTS43974]: Introduced a privileged group (cn=PrivilegedPasswordPolicyGroup,ou=globalgroups,cn=config) that bypasses password policies but does not have other delegated admin abilities. 

-	[VSTS44057]: Improvement to the Main Control Panel -> Directory Browser so that it properly displays attributes with special characters.

-	[VSTS44092]: Added an option to be able to exclude pwdLastLogonTime changes from changelog so that the logging is not overwhelmed. This setting is enforced globally and impacts all password policies. To enable, in Zookeeper, set /radiantone/<Config_Version>/<RadiantOne_ClusterName>/config/vds_server.conf: "skipLoggingIntoChangelogForPwdLastLogonTime" : "true"

-	[VSTS44108]: Improvement to support mutual authentication between RadiantOne and SCIM backends. HTTPS based client connections for SCIMv2 backends now support mutual authentication and will automatically authenticate themselves using the configured certificate for the node they're running on.

-	[VSTS44117]: Improved the last display page of the web installation UX to redirect properly instead of displaying a “page can’t be reached” message.

-	[VSTS44277]: Improvement to include the Event ID and Event Type attributes to all source attribute dropdown selectors in Global Sync.

-	[VSTS44313]: Improvement to allow for granular control on what specific operational attributes are hidden (for non-directory administrator users). This is configurable from Main Control Panel -> Settings -> Server Front End -> Attributes Handling -> Hide operational attributes.

-	[VSTS44332]: Improvement to enforce granular precedence among specific locations within the same naming context for custom limits. The deepest level in the tree will take precedence over parent custom limits.

-	[VSTS44370]: Improvement to support certificate authentication when accessing Azure AD as a backend. This is applicable to the mgraph custom data source. PFX and PEM certificates are supported for authenticating against Azure AD.

-	[VSTS44450]: OpenJDK Update for jdk8u352-b08.

-	[VSTS44509]: Improvement to offer a timeout setting related to generating the transformation jar for Global Sync. Default is 30 seconds and is configurable in the syncPiplineJarRegenTimeoutMs property in vds_server.conf.

## Supported Platforms

RadiantOne supports the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Server Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+
For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base.

## Bug Fixes

-	[VSTS43357]: Fixed a problem with connecting to Oracle cloud via SCIM as a backend. The oracle cloud data source must be modified to include the property: oauth_scope with a value: urn:opc:idm:__myscopes__
Do not include the “username” or “password” properties in the data source.

-	[VSTS43579]: Reduced security risks by adding missing security headers and removing deprecated ones.

-	[VSTS43746]: Fixed an issue with SCIMv2 (frontend) quick start configuration not working. 

-	[VSTS43973]: Fixed an issue where the RadiantOne SAML attribute service did not work when RadiantOne FID was configured to run in FIPS-mode.

-	[VSTS43975]: Fixed filtering excluded attributes for the changelog connector to ensure operational attributes like pwdFailureTime are updated in persistent cache.

-	[VSTS43995]: Fix to have object class and attribute names displayed with correct case on the LDAP schema configuration page in the Main Control Panel.

-	[VSTS44043]: Fixed an issue with replace PATCH operations for canonical attributes (like email) for SCIMv2 backends.

-	[VSTS44099]: Fixed an issue where meta-prefixed attributes from SCIMv2 backends were returned in the virtual entries whether they were configured/mapped in the ORX/DVX or not.

-	[VSTS44106]: Fixed an issue where inter-cluster replication did not function properly when the operational attributes were configured to be hidden. 

-	[VSTS44120]: Fixed an issue where JDK debugging information about SSL handshaking traffic was not propagated into the RadiantOne FID server log.

-	[VSTS44126]: Fix so that object classes load properly in the rules-based transformation screen in Global Sync when the source is an Active Directory backend.

-	[VSTS44136]: Fixed an issue where empty attributes were showing up in virtual entries returned from a virtualized CSV file. This fix only works specifically for the CSV JDBC driver (https://github.com/simoc/csvjdbc) and not any other CSV drivers. Each JDBC driver may treat the parsing of empty values a bit differently.

-	[VSTS44161]: Fixed an issue in the Global Sync rules-based topology where in certain types of virtual views the list of attributes for a target object class were not correctly loaded and was showing a * symbol instead.

-	[VSTS44164]: Fixed an issue with RadiantOne Universal Directory (HDAP) stores that were converted from a persistent cache of Active Directory not having the correct connector type associated with them when they were used in a Global Sync pipeline.

-	[VSTS44178]: Fixed an issue of duplicate object classes showing in the source and target drop-down lists when rules-based transformation is used in Global Sync when the source or target views have multiple content nodes defined. 

-	[VSTS44179]: Fixed an issue when rules-based transformation is used in Global Sync and the source virtual view has container and content nodes. The object class associated with the container level is now properly shown.

-	[VSTS44187]: Fixed an issue with the migration tool v2.1.2 export process generating an empty file.

-	[VSTS44202]: Fixed an issue where the content node mapped attributes in Main Control Panel -> Directory Namespace tab were not saved properly.

-	[VSTS44207]: Fixed an issue with the "Keep track of user's last successful logon time every" setting in password policy not getting saved or loaded properly.

-	[VSTS44210]: Fixed an issue in Global Sync where a failed message (due to an error unrelated to communication) was not put in the dead letter queue and was instead being retried indefinitely.

-	[VSTS44242]: Fixed an issue where variables used in Identity Linkage for Global Sync, rules-based transformation were not generating proper code.

-	[VSTS44244]: Fixed an issue with advanced conditions on attribute mappings used in rules-based transformation not saving properly.

-	[VSTS44248]: Fixed an issue where the updatable property for attributes associated with a content node in Context Builder was not being saved properly.

-	[VSTS44250]: Fixed an issue where guest users were not properly created in Azure AD backends using the mgraph custom data source.

-	[VSTS44255]: Fixed an issue where the attributes list in a virtual view created in Context Builder was getting cleared when editing and saving a content node from Main Control Panel -> Directory Namespace.

-	[VSTS44263]: Fixed an issue with the query text not displaying properly on the attributes tab for a selected content node.

-	[VSTS44264]: Fixed an issue where the user-defined binary attributes specified in a custom schema might experience incorrect binary values within the exported LDIF file for replication.

-	[VSTS44275]: Fixed an issue with non-string attribute types not being correctly translated or updated for SCIMv2 backends. 

-	[VSTS44276]: Fixed an issue with backlink computation causing a loop when dynamic and nested (cyclic) groups are involved which was causing stability issues in the RadiantOne FID service.

-	[VSTS44281]: Fixed an issue with dynamic groups not being calculated properly when the memberURL attribute contains unsupported characters.

-	[VSTS44291]: Fixed an issue with Context Builder displaying connection string passwords in the edit connection string dialog windows.

-	[VSTS44294]: Fixed an issue with the Main Control Panel -> Replication monitoring tab not working properly when the replicated store name contains a space.

-	[VSTS44297]: Fixed issues seen when defining a new password policy where the “Accounts may be locked out due to login failures” was automatically enabled and the interface was displaying negative values for the account activity properties.

-	[VSTS44302]: Fixed a problem with the mgraph custom data source that was causing group members (and other reference attributes like “owner”) to not be included when groups were added into Azure AD.

-	[VSTS44303]: Fixed issues seen with the "Restrictions on Using Accountname or Username" and "Update stored passwords to stronger encryption after successful bind" properties for password policies not being properly editable.

-	[VSTS44312]: Fixed an issue where the schema manager base DN field was not editable when extracting schemas from Novell eDirectory backends. 

-	[VSTS44348]: Fixed an issue where the attribute uniqueness constraint during a move/modRDN was preventing the new RDN value from being enforced.

-	[VSTS44375]: Fixed an issue with persistent cache configuration (requested attributes and refresh dependencies) when unauthorized characters are part of the backend table’s metadata.

-	[VSTS44390]: Fixed an issue with the backlink attribute optimization options not being saved correctly on the Main Control Panel -> Directory Namespace tab.

-	[VSTS44410]: Fixed Global Sync UX to allow user-defined functions to be available in all mapping transformation function dialog windows.

-	[VSTS44413]: Upgraded to org.apache.commons:commons-text:1.10.0 to address CVE-2022-42889.

-	[VSTS44419]: Fixed an issue with Main Control Panel -> Directory Browser search result page not properly displaying the options to modify and delete attributes.

-	[VSTS44459]: Fixed an issue with the HDAP Trigger capture connector in Global Sync not including object class and attribute information that is required to properly handle move and delete operations in a target data store.

-	[VSTS44473]: Fixed an issue where importing data sources fails when migrating from v7.4 to v7.4 with the migration tool 2.1.3.

-	[VSTS44485/44522]: Fixed an issue with enable/disable referral chasing not working.

-	[VSTS44504]: Fixed a problem in Global Sync where attribute mapping rules were not saved properly if they were using the buildExpression function.

-	[VSTS44532]: Fixed a problem with remapped attributes in a virtual view not being applied or saved properly. Also fixed a problem with reflecting the attribute remapping in the query text displayed below the attribute table.

-	[VSTS44540]: Fixed a problem with defining Special Attribute Handling -> Dynamic Groups to properly define an LDAP URL when a container node is selected as the dynamic group location.

-	[VSTS44558]: Fixed an issue where the Global Identity Viewer couldn’t load any Global Identity Builder projects due to requests being blocked by the CSP header.

-	[VSTS44567]: Fixed a problem in Context Builder –> View Designer where changing the RDN prefix for a container or content node type was causing subsequent actions to fail with a “The given node doesn’t exist” error.

-	[VSTS44571]: Fixed a problem in Context Builder during runtime preview for a virtual view containing recursive relationships from a database backend.

## Known Issues

Related to [VSTS44450]: OpenJDK Update for jdk8u352 included in this patch release, there is a known issue when RadiantOne is configured for FIPS-mode. To avoid the issue, you must disable TLS 1.3 and enable TLS 1.2. This can be done from RadiantOne Main Control Panel > Settings > Security > SSL.  Click CHANGE next to Enabled SSL Protocols. Uncheck TLS 1.3 and check at a minimum TLS v1.2. Save and restart the RadiantOne service.
 
For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact: support@radiantlogic.com

