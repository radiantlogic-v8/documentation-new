---
title: v7.4.2 Release Notes
description: v7.4.2 Release Notes
---

# RadiantOne v7.4.2 Release Notes

August 11, 2022

These release notes contain important information about improvements and bug fixes for RadiantOne v7.4

These release notes contain the following sections:

[Improvements](#improvements)

[Supported Platforms](#supported-platforms)

[Bug Fixes](#bug-fixes)

[Known Issues](#known-issues)

[How to Report Problems and Provide Feedback](#how-to-report-problems-and-provide-feedback)

## Improvements

-	[VSTS40251]: Added support for using connection pooling to the following connector types: Changelog, Persistent Search, DB Timestamp and DB Changelog. 

-	[VSTS40688, 43722]: Removed Main Control Panel -> Instances tab since new instances are added during the installation process as subclusters. See the RadiantOne Installation Guide.

-	[VSTS41646]: Direct upgrade from RadiantOne FID v7.2 to RadiantOne FID 7.4 is supported. See the following knowledge base article for details: https://support.radiantlogic.com/hc/en-us/articles/7908444062612-RadiantOne-Upgrade-Guide-v7-2-to-v7-4 

-	[VSTS42000]: SCIM2 Groups can now be mapped by assigning the member property (e.g. uniqueMembers) to any "members[type eq ...].value" attribute, on a ResourceType using the core SCIM2 Group Schema as its primary Schema.

-	[VSTS42204]: Added the AD Password filter connector to support synchronizing password changes from Active Directory to other target systems.

-	[VSTS42451]: The Main Control Panel -> Global Sync tab is now restricted to users with the ICS-admin or ICS-operator privilege.  Saving connector properties and starting an upload is now restricted for users with the ICS-operator privilege.

-	[VSTS42640]: Added the ability to apply a RadiantOne patch using command line instead of requiring a web UI. The command is: setup.[bat|sh] --mode update --file <full path to the 7.4 archive>

-	[VSTS42798]: Added Rule-based transformation capability in Global Sync.

-	[VSTS42882]: The property indicating account lockout for a custom password policy is now configurable from the command line tool vdsconfig.

-	[VSTS42886]: Upgraded the logging mechanism from log4j to log4j2 for external ZooKeeper ensemble deployments.

-	[VSTS42986]: Added a new option (--cert-password-encoded or -Q) in the instance manager tool for passing the server certificate password in encrypted format.

-	[VSTS43014]: Improved the server memory monitoring by listening to the garbage collector activity.

-	[VSTS43057]: Added a new property for the changelog capture connector to indicate failback behavior: Switch to Primary Server (in polling intervals in the UI, switchToPrimaryServer property in registry.
<br>The default value of the property is 0. If the property value <=0, no attempt to switch to primary server will done. If the property value = 1, an attempt to switch to primary server will be done every polling interval. If the property value > 1 (10 for example), an attempt to switch to primary server will be done every 10 polling intervals. Because an attempt to connect to primary server is time consuming, the property value should not be too low (1-3). Also, when connector starts (restarts), and the property value >0, an attempt to switch to primary server will be done immediately.

-	[VSTS43122]: Improved setup scripts so they support file paths with spaces in it.

-	[VSTS43124]: Added support for all SCIM reference attributes, instead of just for group members.

-	[VSTS43144]:  Added the capability to capture BindDN for unsuccessful binds in the vds_server logs for auditing purpose when the “enableAccessLoggingWithWhoDidThat”property is enabled.

-	[VSTS43287]:  Improved the detection of similar events in queues to speed up the persistent cache refresh time of frequently modified entries.

-	[VSTS43316]: Upgraded fasterxml, apache commons, derby, jetty and quartz libraries to address the following: CVE-2015-5237, CVE-2017-3164, CVE-2018-1296, CVE-2020-13941,CVE-2021-28165, CVE-2020-27216,CVE-2016-6811,CVE-2019-12401, GHSA-26vr-8j45-3r4w, GHSA-gx2c-fvhc-ph4j, GHSA-7hfm-57qf-j43q, GHSA-f8vc-wfc8-hxqh, GHSA-g3wg-6mcf-8jj6, GHSA-288c-cq4h-88gq, GHSA-57j2-w4cx-62h2, GHSA-9qcf-c26r-x5rf, CVE-2016-3086, CVE-2017-3162, CVE-2021-29943, CVE-2018-8029, GHSA-wrvw-hg22-4m67, CVE-2022-26612, CVE-2019-0193, CVE-2015-1832, CVE-2018-11768, CVE-2018-8009, GHSA-rvwf-54qp-4r6v, CVE-2016-5393, CVE-2020-9492, CVE-2015-0226, CVE-2020-10663, GHSA-grg4-wf29-r9vv, GHSA-8m5h-hrqm-pxm2, CVE-2018-1308, GHSA-xqfj-vm6h-2x34, GHSA-mc84-pj99-q6hh.

-	[VSTS43353]: Added a timeout for 120 seconds for AD Password Filter.

-	[VSTS43369]: Removed the unused apache poi and jsoup dependencies from the admin-portal and control panel project to address CVE-2017-12626

-	[VSTS43405]: Improved the server memory monitoring by listening to the GC activity. 

-	[VSTS43413]: Updated the "Keep track of the user's last successful logon time every" field on the password policy settings page to display as '0s' instead of '0d' when value is 0.

-	[VSTS43454]: Upgraded Spring and Spring Security library versions to address CVE-2022-22950.

-	[VSTS43476]: The AD password filter connector property object name is prefilled with the naming context in Global Sync.

-	[VSTS43524]: Optimized the persistent cache refresh engine to avoid using branch synchronization when an object level sync is sufficient.

-	[VSTS43578]: Added support for asynchronous indexing of backing attributes in HDAP.

-	[VSTS43586]: Allowed certificates can now be added to the trust store for read only and remote read only nodes.

-	[VSTS43639]: Added a download button to the export Login Analysis Results in the Global Identity Builder.

-	[VSTS43656]: Added configurable timeout (default is 60 seconds) in vdsserver.config for the Active Directory password web socket service (for extracting passwords from AD).

-	[VSTS43735]: Added a new property for persistent cache changelog connector to indicate the choice of failover logic: "Failover Algorithm[1-4]".

-	[VSTS43742]: Improved the ability to monitor and alert about number of open file descriptor whenever the socket cannot be created for incoming connections. This improvement is only for Linux platforms.

-	[VSTS43756]: Added logging for the service that is able to get passwords from Active Directory entries (i.e. ADPasswordHash). Log level is configured in <RLi_hOME>\bin\ad_pwd.

-	[VSTS43816]: Improvement to allow a property to be configured for a SCIMv2 backend data source to indicate the URL to be used for the “test connection” operation. By default, the test connection will be against the /ServiceProviderConfig endpoint.

-	[VSTS43891]: Added the ability to log backlink attributes into the changelog (configurable by the setting “Enable changelog” property in the linked attributes setting) to support cache refreshes for users when their memberOf attribute is updated.

-	[VSTS43955]: Improved the installer UI to prevent using underscores in the ZooKeeper hostname or cluster name properties.

-	[VSTS43958]: Added com.rli.util.LegacyUtils class to provide access to older APIs from version 7.2 that are no longer publicly available in version 7.4.

-	[VSTS44037]: Upgraded to OpenJDK updated to 8u345-b01.

## Supported Platforms

RadiantOne is supported on the following 64-bit platforms:

-	Microsoft Windows Server 2008 R2, 2012 R2, 2016, 2019

-	Windows Server Core

-	Red Hat Enterprise Linux v5+

-	Fedora v24+

-	CentOS v7+

-	SUSE Linux Enterprise v11+

-	Ubuntu 16+

For specific hardware requirements of each, please see the RadiantOne System Requirements located in the Radiant Logic online knowledge base.

## Bug Fixes

-	[VSTS42429]: Fixed an issue with the runtime preview in Context Builder -> View Designer for views based on the default scimclient2 custom data source.

-	[VSTS42761]: Fixed an issue where after installing a sub cluster (shards or instances) in same box), the cluster tab was absent from the Main Control Panel. 

-	[VSTS42913]: Fixed an issue where the destination objects and object attributes were not properly loaded on the Global Sync mappings transformation page.

-	[VSTS42974]: Disabled directory traversal for static resources for Control Panel endpoints (e.g. /ldabrowser, /public, /branded).

-	[VSTS42975]: Custom error pages shown for invalid resources instead of the default ones which reveal information about the system.

-	[VSTS42977]: Fixed the incorrect initialization of compound objects when the merged object names contain a hyphen.

-	[VSTS43078]: Fixed a problem with attributes associated with an external join not being returned properly for virtual views.

-	[VSTS43081]:  Fixed an issue where some password policy attributes were not defined in the schema, resulting in unnecessary error messages when the command line tool vdsconfig was used to update the password policy.

-	[VSTS43082]: Streamlined the password policy update process of the command line tool vdsconfig, so that all properties should remain consistent with the given arguments from the input.

-	[VSTS43104]:  Fixed a problem returning “null” when configuring a real-time persistent cache refresh on a virtual that contains a join to an HDAP store using a scope of one. Joins using base and sub scopes work fine.

-	[VSTS43146]: Fixed an issue where the reporting feature in the control panel generated empty PDFs due to improperly detecting RLI_HOME. 

-	[VSTS43156]: Fixed an issue where the setting "password never expires" of custom password policy was not overriding the default password policy's setting.

-	[VSTS43278]: Fixed an issue with the agent orchestrator that could lead to the agent in charge of the real-time persistent cache refresh timing out when one or more nodes in the cluster are down.

-	[VSTS43282]: Fixed an issue with establishing a connection to PingOne using the scimclient custom data source.

-	[VSTS43294]: Fixed an issue where the runtime preview in Context Builder -> Directory Browser was not working properly for virtual views containing recursive merge links. 

-	[VSTS43302]: Fixed an issue causing a partial persistent cache refresh intermittently when joined objects in the virtual view contain a many-to-1 relationship.

-	[VSTS43350]: Removed sensitive information from certificate import and audit report error messages

-	[VSTS43351]: Added separate logs for each RadiantOne instance so that Windows services associated with each instance don’t have a conflict.

-	[VSTS43352]: Fixed an issue where ACI's attribute target with a large list of attributes could cause a stack overflow.

-	[VSTS43354]: Fixed an issue where the Instance Manager Utility was not using the correct instance name parameter when applying updates.

-	[VSTS43356]: Fixed a problem with Identity Data Analysis wizard not supporting attributes containing folded binary fields. 

-	[VSTS43364]: Fixed a problem with intermittent bind failures during concurrent Binds, caused from using custom authentication logic.

-	[VSTS43371]: Fixed an issue with the Control Panel where “invalid credentials” is seen on the Directory Browser tab when the admin user logged into Control Panel with MFA using a pin code (validated by a custom authentication provider).

-	[VSTS43374]:  Upgraded libs to WSS 2.2.7 and xmlsec 2.1.7 and refactored existing classes to resolve issues with the RadiantOne SAML Attribute Service interfering with ADAP tokens.

-	[VSTS43421]: Fixed an issue with the global sync event detection process not working properly when the source was a proxy view of a RadiantOne Universal Directory (HAD) store.

-	[VSTS43444]: Fixed an issue where the ‘Destination DN Expression’ field was no longer editable in the Global Sync pipeline mappings. 

-	[VSTS43498]: Fix to properly load the object classes and attributes for the Attribute Mappings step in Global Sync transformation configuration.

-	[VSTS43520]: Fixed an issue when trying to edit JSON attribute values from the Directory Browser tab, the UI did not display the attribute value correctly.

-	[VSTS43522]: Fixed a bug in the ScriptHelper.lookupDN_Base(String dn) utility method that was causing this method to throw NPEs after upgrading from v7.2 to v7.4.

-	[VSTS43523]: Fixed the loading of data sources from \vds\vds_server\datasources folder so that only the custom.xml, database.xml, ldap.xml will be loaded.

-	[VSTS43576]: Fixed an issue with changing the RadiantOne server SSL certificate from InstanceManager command line utility behaving differently than changing it from the Server Control Panel.

-	[VSTS43577]: Fixed the ImportLdifChanges option in the ldif-utils utility because it was not preserving the original attribute case.

-	[VSTS43581]: Fixed an issue seen when creating a view on an LDAP backend with an empty base DN configured in the data source which was causing searches and other LDAP operations to fail.

-	[VSTS43585]:  Fixed an issue where the value of attribute acilocation was not properly generated after migrating ACI from eDirectory.

-	[VSTS43616]: Fixed a problem seen when using an | (OR) operator to create a filter between a main attribute and a JSON attribute which was causing the query to fail.

-	[VSTS43621]: Fixed a problem with the database timestamp capture connector handling database table names containing a hyphen.

-	[VSTS43632]: Fixed a problem with uploading entries into an Azure AD target using the mgraph custom data source.

-	[VSTS43675]: Fixed an issue with the RadiantOne SCIMv2 interface because it was not handling the encoding and decoding of “+” characters or spaces properly in the URL. 

-	[VSTS43678]: Fixed an issue where the RadiantOne CIMv2 interface was not resolving resource types correctly for group members.

-	[VSTS43730]: Fixed an issue with custom object classes not appearing in the object mapping step in the Context Builder -> Schema Manager.

-	[VSTS43732]: Fixed an issue where the RadiantOne SCIM server was not returning formatted JSON error responses per the SCIM specification. The fix also ensures the service responds with appropriate 501 errors in response to unimplemented "me" endpoints correctly. 

-	[VSTS43781]: Fixed a problem with the database (changelog type) connector not properly creating the RLI_CON schema. 

-	[VSTS43808]: Fixed an issue where the “save as” view file name window does not close at the end of the hierarchy builder process in the Context Builder -> View Designer. 

-	[VSTS43822]: Fixed an issue when converting a data type for database backends by adding support for sysname data types. 

-	[VSTS43890]: Fixed an issue with the RadiantOne SAML attribute service not working with the internal SSL connection after hardening the RadiantOne service and disabling the non-SSL ports.

-	[VSTS43897]: Fixed an issue where the modify/add/delete right-click operations on the Main Control Panel -> Directory Browser tab were not working properly when multiple search tabs were open.

-	[VSTS43938]:  Fixed an issue with untaring the Linux installers. The full installer archive zip/tar.gz file is no longer signed to prevent errors during unzipping.  

-	[VSTS43942]: Fixed a problem of invalid token/access errors when accessing the Main Control Panel- -> Directory Browser tab after the super user (e.g. cn=directory manager) credentials have been updated.

-	[VSTS44023]: Fixed a problem with extracting the schema from a Teradata database using a JDBC driver that was resulting in “Failed in getTableList: java.lang.NullPointerException” and “[SQLState HY000] Invalid connection parameter name includeSynonyms” error messages during extraction.

-	[VSTS44029]: Fix to properly support Dynamic Groups to authenticate Delegated Administrators into the Control Panel.

-	[VSTS44055]: Fixed a problem with the “custom” project classpath missing libraries. 

-	[VSTS44065]: Fixed a problem with database data source settings not being shown properly on follower nodes.

-	[VSTS44081]: Fixed a problem with certificate manager to properly display certificates associated with aliases containing spaces in the name. 

## Known Issues

-	The following options have been removed from Context Builder-Schema Manager: Default Attribute Mapping editor, and Load LDAP Schema (for mappings)

-	The following options have been removed from Context Builder-View Designer: 

Default Views Generator, Sentence View tab, Verb parameter, Add to Context Catalog button, Virtual Tree Generation, and Data Source Management. 

-	The SCIMv1 API to RadiantOne has been deprecated. Only SCIMv2 is supported. 

-	SCIMv2 URLs have changed between v7.3 and v7.4. Please reference the Web  Services API Guide in v7.4 for examples on querying RadiantOne via SCIMv2.

-	The installation process has changed. There are no longer .exe and .bin installer files. A zip file is provided for Windows, and a tar file for Linux. After the files are extracted to the location where you want RadiantOne to be installed, you can use either a web-based install (use \radiantone\vds\bin\setup.bat/.sh) or install-sample.properties with Instance Manager to install in a silent mode. See the RadiantOne Installation Guide for details.

-	RadiantOne-specific environment variables used/set during installation are no longer used. You will not have or need RLI_HOME or RLI_JAVA_HOME.

For known issues reported after the release, please see the Radiant Logic Knowledge Base:

https://support.radiantlogic.com/hc/en-us/categories/4412501931540-Known-Issues 

## How to Report Problems and Provide Feedback

Feedback and problems can be reported from the Support Center/Knowledge Base accessible from: https://support.radiantlogic.com 

If you do not have a user ID and password to access the site, please contact:

support@radiantlogic.com
