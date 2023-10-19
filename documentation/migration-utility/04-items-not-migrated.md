---
title: Migration Utility
description: Migration Utility
---

The items outlined below are not migrated by the utility and must be manually taken care of in the target environment.

-	License keys – licenses are machine-dependent and not copied/migrated from the source environment to the target environment. Copy your RadiantOne license key into <RLI_HOME>/vds_server. 

-	Server certificates – generate and/or update the server certificate on the target server. 

-	The ZooKeeper client password – the password defined during install on the target environment is not overwritten with the password from the source environment.

-	The RadiantOne Super User (e.g. cn=directory manager) password – the password defined during install on the target environment is not overwritten with the password from the source environment.

-	Installing servers to run as services – configure all needed services (FID, Jetty…etc.) to startup automatically in the target environment.

-	Custom JAR files – if you are using your own custom jar files (e.g. in scripting logic, JDBC drivers), copy these files to the target environment.

-	Jetty configurations – any custom jetty configuration must be made in the target environment.

-	Persistent caches should be initialized in the target environment.

-	If the RadiantOne version/build on the source environment is not the exact same as in the target environment (e.g. v7.4.0 -> v7.4.1), then the custom scripts (e.g. for accessing custom backends, interception scripts, or transformation scripts in Global Sync), anything located in <RLI_HOME>/vds_server/custom, is not migrated. You must manually copy these files to the target environment and then rebuild the jars in the target environment (C:\radiantone\vds\vds_server\custom>c:\radiantone\vds\ant\bin\ant.bat buildjars). If the source and target RadiantOne versions are exactly the same, then the custom folder is migrated. A backup copy of the custom folder is made in <RLI_HOME>/vds_server/custom.yyyyMMdd-HHmmss/ prior to migrating. 

-	<RLI_HOME>/vds_server/conf/ldapschema_01.ldif is not migrated since the target schema file might have a newer definition (if the target environment is a newer version of RadiantOne). If you have manually customized the ldapschema_01.ldif file in your source environment, make those same modifications in the target environment.
