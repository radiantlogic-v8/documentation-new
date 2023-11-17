---
title: Database Data Sources
description: Details about how to configure database data sources.
---

## Database Data Sources Introduction

A database data source represents a connection to a SQL/JDBC-accessible backend.

The following JDBC drivers are installed with RadiantOne: JDBC-ODBC Bridge from Sun, Oracle (thin), Oracle oci, Microsoft SQL Server, HSQL, MariaDB (used for MySQL as well), IBM DB2, Sybase, and Derby.

You have the option to use one of the above drivers, however, it is recommended that you use the driver that was delivered with the database that you want to connect to. To add a JDBC driver, you must make sure that the driver libraries are added in the <RLI_HOME>/lib/jdbc directory.

>[!warning] Updating to a different DB2 driver may require more than just replacing the existing driver files in the <RLI_HOME>/lib/jdbc directory if the name or license has changed. Please consult the Radiant Logic knowledge base for additional details.

![Database Data Sources](Media/Image3.72.jpg)

Figure 12: Database Data Sources

## Add a Database Data Source

1.	In the Main Control Panel, go to > Settings Tab > Server Backend section > DB Data Sources sub-section.

2.	Click **Add**.

3.	Enter a unique data source name (do not use spaces in the name) along with the connection information to reach your backend server. You can select a Data Source Type from the drop-down list and the driver class name and URL syntax is populated for you. You can then just modify the needed parameters in the URL and enter the required user/password. 

    >[!note] A secure connection can be made to the database if the JDBC driver supports it. If the server you are connecting to uses a certificate issued by a trusted Certificate Authority, then all you need to do during the creation of the data source is enter the SSL port in the appropriate location of the URL. If the server you are connecting to uses a self-signed certificate, then this certificate must be imported into the [RadiantOne client trust store](06-security#client-certificates-default-java-truststore).

4.	Click **Test Connection**.

5.	Click **Save**.

## Edit a Database Data Source

To update the connection information associated with a data source, select the configured data source and click **Edit**. After editing the information, click **Test Connection** and then save the updated information.

## Delete a Database Data Source

To delete a data source, select the configured data source and click **Delete**. After deleting any data source, save your changes.

## Adding a New Database Driver

A list of drivers appears in the drop-down list box when you are defining a database data source. Only the drivers that are shown in green were installed with RadiantOne. The other driver names/syntaxes that appear in the drop-down list have been provided to save time. If you would like to use one of these drivers or to include a new JDBC driver, install the driver files in the <RLI_HOME>/lib/jdbc directory. Restart the RadiantOne service and any open tools. During the creation of the database data source, if your driver type is listed in the drop-down list, select it and the syntax for the driver class name and URL is populated for you. Update the URL with the connection details for your database. If the drop-down list does not include your database driver type, you can leave this blank and manually type in the data source name, driver class name, driver URL, user and password.

This information is saved in a file so you do not have to re-enter the same connection parameters every time you extract a schema from the same type of database. The name of the file is jdbcxml.xml, and it can be found in the directory <RLI_HOME>\<instance_name>.

## Configure Database Failover Servers

If the primary backend is not available, RadiantOne attempts to connect to a failover server that is configured for the data source.

>[!warning] If you have not defined data sources for your failover servers, you must do so before performing the following steps.

1.	In the Main Control Panel, go to > Settings Tab > Server Backend section.

2.	Select the DB Data Sources section and on the right side, select the data source you want to configure a failover server for and click **Edit**.

3.	In the Failover section, select the data source that represents the failover database from the drop-down list.

4.	Save the configuration when you are finished.

