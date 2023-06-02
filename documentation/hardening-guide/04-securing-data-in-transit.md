---
title: Hardening Guide
description: Hardening Guide
---

# Recommendations for Securing Data in Transit - SSL/TLS Settings

RadiantOne supports SSL/TLS and StartTLS to encrypt communication with clients and for communication to backend services.

## Configure SSL/TLS for Accessing RadiantOne

During the RadiantOne installation, a self-signed certificate is generated for SSL/TLS access to RadiantOne. This certificate is also used for HTTPS access to the Control Panels. It is recommended to replace the default self-signed certificate with a CA-signed certificate that complies with your corporate security policy. Please see the RadiantOne System Administration Guide for more information.

Below is a high-level architecture diagram depicting the communication between the different layers (clients to RadiantOne and RadiantOne to backend data sources). This provides a glimpse of the different certificates, keystores and truststores involved. All components at the RadiantOne layer are installed on the same server.

![An image showing the ](Media/Image4.1.jpg)

## Forbid Access to RadiantOne on the Non-SSL Port

If SSL has been enabled for RadiantOne and you want to forbid access on the non-SSL port, follow the steps below.

>[!warning]
>If you have not enabled SSL for RadiantOne and set a value of 0 for the standard port, the RadiantOne service does not start at all. Therefore, be sure to enable the SSL port before setting the standard port to 0.

1. Stop the RadiantOne service (from the Dashboard tab in the Main Control Panel or as a service if it is installed as a service). If running in a cluster, shutdown the RadiantOne  service on all nodes starting with the follower/follower-only nodes and stopping the leader node last. View the leader/follower status of each node from the Main Control Panel dashboard tab. Take note of the current leader node (noted with the yellow-colored triangle).
2. Go to the Settings tab > Server Front End > Administration section.
3. On the right side, enter a value of 0 (zero) in the LDAP Port field.
4. Click **Save**.
5. On the Settings tab, navigate to Security > SSL.
6. In the Inter Nodes Communication section, check the option to Always use SSL.
7. Click **Save**.
8. Go to the Settings tab > Server Front End > Administration and set the Admin HTTP port to 0.
9. Click **Save**.
10. Go to the Settings tab > Server Front End > Other Protocols section.
11. On the right side, enter a value of 0 (zero) in the HTTP port field.
12. Click **Save**.
13. On the Settings Tab, navigate to Server Backend > Internal Connections (requires [Expert Mode](00-preface.md#expert-mode)).
14. Check the Use SSL checkbox and click Save.
15. Start the RadiantOne service from the Dashboard tab (or start the service if you have configured it to run as a service). Start the RadiantOne service on all nodes if running in a cluster, starting with the previous leader node first (you took note of this in step 1 above).
16. On the Settings tab, navigate to Server Backend -> LDAP Data Sources.
17. On the right, select the vdsha data source and click EDIT.
18. Change the port to the SSL port and check the SSL checkbox.
19. If RadiantOne is deployed in a cluster, the failover servers associated with the vdsha data source must have the port updated also. In the Failover LDAP Servers section, select a failover server and click Edit. Check the SSL checkbox, enter the SSL port and click OK.
20. Click **Save**.
21. Select the replicationjournal data source and click EDIT.
22. Change the port to the SSL port and check the SSL checkbox.
23. If RadiantOne is deployed in a cluster, the failover servers associated with the replicationjournal data source must have the port updated also. In the Failover LDAP Servers section, select a failover server and click Edit. Check the SSL checkbox, enter the SSL port and click **OK**.
24. If the replicationjournal data source points to a remote cluster, to support SSL access, the remote RadiantOne node’s public key certificate must be signed by a known/trusted CA or imported into the Main Control Panel > Settings > Security > Client Certificate Truststore.
25. Click Save.

If you use the Main Control Panel, Directory Browser tab to manage entries, you can have connection problems if you turn off the non-SSL port and your browser (client) doesn’t trust the RadiantOne server certificate. The Directory Browser tab accesses the RadiantOne service via the REST web service ports. If the non-SSL port is off, it must use the HTTPS port.

If you are using a self-signed server certificate, you must install/trust the RadiantOne server certificate into your Internet browser. This can be done with the steps below.

>[!note]
>This is also applicable if you are simply accessing the Control Panel via the HTTPS port (e.g. 7171) even if the non-SSL is still available. This is because when you access the Main Control Panel via HTTPS, it connects to the RadiantOne service on the HTTPS web service port (https://rliserver:8090) and this requires the browser to trust the RadiantOne node’s server certificate. The [diagram](04-recommendations-for-securing-data-in-transit-ssl-tls-settings.md) shown at the beginning of this chapter depicts the different certificates, keystores and truststores in the architecture and is helpful to understand where certificates need to be imported.

1. Open your Internet Browser (as an administrator, in order to install the RadiantOne server certificate when prompted) and navigate to RadiantOne on the HTTPS port (e.g. https://radiantoneserver:8090)
2. The browser should warn you about the certificate. Select to continue/proceed.
3. Click on the "Certificate Error" red area in the address bar, to show information about the certificate.

    ![An image showing the certificate error](Media/Image4.2.jpg)

4. You should have the option to install it, which you should do, in Trusted Root Certificates.

    ![An image showing the trusted root certificates](Media/Image4.3.jpg)

5. Restart your browser after installing the certificate.

6. If your browser does not have the option to install it, you can export the certificate and then import it directly in your browser settings. Below is an example for Google Chrome.
7. Click the Certificate Information link.

    ![An image showing the certificate information link](Media/Image4.4.jpg)

8. On the Details tab, click Copy to File.
9. Click Next in the Certificate Export Wizard.
10. Choose DER encoded binary and click Next. Enter a file name (e.g. jetty.cer) and click Next.
11. Click Finish and then click OK.
12. Go to your Internet browser settings. The example below shows the Google Chrome browser settings.

    ![An image showing the Settings option](Media/Image4.5.jpg)

13. Under settings, click Show Advanced Settings.
14. Click Manage Certificates in the HTTPS/SSL section.

    ![An image showing the Manage Certificates button](Media/Image4.6.jpg)

15. On the Trusted Root Certification Authorities tab, click **Import**.
16. Click **Next** in the Certificate Import Wizard.
17. Click **Browse** to navigate to the certificate file you exported above.
18. Click **Next**.
19. Click **Next**.
20. Click **Finish**.
21. Click **OK** to exit the confirmation.
22. Click **Close** to close the certificate window.

Restart your browser and then go to the Main Control Panel again on the HTTPS port. You
should not see the certificate warning anymore.

## Configure SSL Protocols Allowed for RadiantOne

You can limit the SSL protocols supported in RadiantOne from the Main Control Panel > Settings Tab > Security section > SSL sub-section. Click **Change** next to Enabled SSL Protocols. Select the protocols to support and click OK. Restart the RadiantOne service on all nodes.

>[!note]
>Only enable the SSL protocols that comply with your company’s security policy.

## Use Strong Cipher Suites and Disable Weak Ones

If you are running Java v1.8.0_151 or above, you can use strong cipher suites with the following steps. To check your version of Java, open a command prompt, navigate to <RLI_HOME>/jdk/jre/bin and run java -version. An example is shown below.

![An image showing checking the version of Java](Media/Image4.7.jpg)

1. Add crypto.policy=unlimited in <RLI_HOME>/jdk/jre/lib/security/java.security file. The value might already be in the file. If it is, just uncomment it.
2. Restart Control Panel (Jetty server) and the RadiantOne service. If deployed in a cluster, restart it on all nodes.
3. Open the Main Control Panel.
4. On the Settings Tab > Security section > SSL sub-section, click on the CHANGE button next to Supported Ciphers Suites. Enable only the desired cipher suites.
5. Click SAVE.
6. Restart the RadiantOne service. If deployed in a cluster, restart it on all nodes.

If you are running a Java version prior to Java v1.8.0_151, you can install stronger cipher suites with the following steps.

1. Download the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy files from Oracle, applicable to the Java version used in RadiantOne. To determine the version of Java used in your RadiantOne build, navigate from command line to <RLI_HOME>/jdk/jre/bin and execute: java -version.
2. Extract jce\local_policy.jar and jce\US_export_policy.jar from the archive to the folder <RLI_JAVA_HOME>\lib\security, overwriting the files already present in the directory.
3. Restart Control Panel (Jetty server) and the RadiantOne service. If deployed in a cluster, restart it on all nodes.
4. Open the Main Control Panel.
5. On the Settings Tab -> Security section -> SSL sub-section, click on the CHANGE button next to Supported Ciphers Suites. Enable only the desired cipher suites.
6. Click SAVE.
7. Restart the RadiantOne service. If deployed in a cluster, restart it on all nodes.

## Turn Off Non-SSL (HTTP) Port for Web Service Requests

To only support HTTPS access to the RadiantOne web services (ADAP, SCIMv1/v2...etc.), set the HTTP port to zero and restart FID.

![An image showing the ](Media/Image4.8.jpg)

## Turn Off Non-SSL (HTTP) Port for Control Panel

To only support HTTPS access to the Control Panels, edit
<RLI_HOME>\vds_server\conf\jetty\config.properties and set: jetty.ssl.force=true

Restart Jetty (which hosts the Control Panel applications). You can force Jetty to stop by running %RLI_HOME%\bin\StopWebAppServer.bat (StopWebAppServer.sh on Linux). Jetty restarts when you launch the Main Control Panel. Or, if you’ve configured it to run as a service
at the level of the operating system, restart it from there.

>[!note]
>If RadiantOne is installed on Windows platforms, edit the Control Panel shortcuts (typically on the desktop and from the Start menu > All Programs > RadiantOne > Control Panel). Change the default target from:
C:\radiantone\vds\bin\openControlPanel.bat vds_server http
><br> To the following target:
C:\radiantone\vds\bin\openControlPanel.bat vds_server https

By default, Jetty leverages the same SSL settings as the RadiantOne service.

>[!note]
>To force Jetty to use its own SSL configurations instead of the same as
used by the RadiantOne service, edit
<RLI_HOME>\vds_server\conf\jetty\config.properties and set:
useVDSSSLConfig=false

Since Jetty uses the same server keystore as the RadiantOne sevice (jetty.ssl.keystore.location=<RLI_HOME>/vds_server/conf/rli.keystore), this server certificate must be trusted by your Internet Browser if you need to access the Control Panel via HTTPS. If you have replaced the default self-signed certificate with one signed by a Certificate Authority that is trusted by your client browser, you should be able to access the Control Panels via the SSL port without problems (e.g. https://radiantoneserver:7171). If you are using a self-signed certificate, you must install/trust the server certificate into your Internet browser. This can be done with the steps below.

1. Open your Internet Browser (as an administrator, in order to install the RadiantOne server certificate when prompted) and navigate to the Main Control Panel on the HTTPS port (e.g. https://radiantoneserver:7171)
2. The browser should warn you about the certificate. Select to continue/proceed.
3. Click on the "Certificate Error" red area in the address bar, to show information about the certificate. You should have the option to install it, which you should do, in Trusted Root  Certificates.
4. If your browser does not have the option to install it, you can export the certificate and then import it directly in your browser settings. Below is an example for Google Chrome.
5. Click the Certificate Information link.

    ![An image showing the certificate information link](Media/Image4.9.jpg)

6. On the Details tab, click Copy to File.
7. Click Next in the Certificate Export Wizard.
8. Choose DER encoded binary and click Next. Enter a file name (e.g. jetty.cer) and click Next.
9. Click Finish and then click OK.
10. Go to your Internet browser settings. The example below shows the Google Chrome browser settings.

    ![An image showing the Settings option](Media/Image4.10.jpg)

11. Under settings, click Show Advanced Settings.
12. Click Manage Certificates in the HTTPS/SSL section.
13. On the Trusted Root Certification Authorities tab, click Import.
14. Click Next in the Certificate Import Wizard.
15. Click Browse to navigate to the certificate file you exported above.
16. Click Next.
17. Click Next.
18. Click Finish.
19. Click OK to exit the confirmation.
20. Click Close to close the certificate window.
21. Restart your browser and then go to the Main Control Panel again on the HTTPS port. You should not see the certificate warning anymore.

## Configure SSL Protocols Allowed for Control Panels

To configure the SSL protocols to allow in your environment for the Jetty web server that hosts the Main and Server Control Panels, edit: <RLI_HOME>/vds_server/conf/jetty/config.properties.

Set the value for jetty.ssl.protocols to the ones you want to support. The default server socket protocols allowed in Java 8 are: SSLv2Hello, TLSv1, TLSv1.1, and TLSv1.2

For example, if jetty.ssl.protocols=TLSv1.2 is set, the following cipher suites are enabled:

`Enabled protocol: TLSv1.2`
<br> `Enabled cipher suite: TLS_RSA_WITH_AES_128_CBC_SHA256`
<br> `Enabled cipher suite: SSL_RSA_WITH_3DES_EDE_CBC_SHA`

Restart Jetty after making changes to config.properties.

## Advise Application Owners to use the Latest Java Patches

Java patches are currently released quarterly by OpenJDK:
https://wiki.openjdk.java.net/display/jdk8u/Main

Radiant Logic releases patches for RadiantOne approximately one week after OpenJDK releases to ensure support for the latest Java patch is included.

It is highly advised that all client applications connecting to RadiantOne via LDAPS or HTTPS have the latest Java patch in order to reduce the risk of security breaches. This is to ensure the latest bugs and security vulnerabilities have been addressed, and that clients don’t attempt to negotiate obsolete, unsafe or disabled ciphers.

Although you can configure the SSL ciphers and protocols enabled in RadiantOne, it is not advised to enable less secure settings solely to accommodate client applications running older versions of Java.

## Enable SSL Communication Between Cluster Nodes

If you are deploying RadiantOne in a cluster, all nodes must be able to communicate with each other. This is required for block replication (replicating data in RadiantOne Universal Directory stores and Persistent Cache) which uses HTTP/HTTPS and redirecting write operations to the leader node which uses LDAP/LDAPS. To force the usage of SSL communication between cluster nodes, choose the Always use SSL option from the Main Control Panel > Settings Tab > Security section > SSL sub-section.

>[!note]
>Forcing the use of SSL slows down the communication speed between nodes.**

## Configure SSL/TLS for Backend Connections

If RadiantOne is connecting to backends over a network connection that is considered unsecure, it is recommended that you configure the connection to use SSL/TLS.

If the backend server uses a certificate issued by a trusted Certificate Authority, then all you need to do is enter the SSL port and check the SSL checkbox when you define the data source.
For database backends, just enter the SSL port in the URL as there is no SSL checkbox.

If the server you are connecting to uses a self-signed certificate, or signed by a Certificate Authority not known by RadiantOne, then this certificate must be imported into the client truststore. Import client certificates into the RadiantOne truststore from the Main Control Panel > Settings Tab > Security section > Client Certificate Truststore. RadiantOne dynamically loads client certificates from here meaning certificates can be added at any time without requiring a restart.

For more information on SSL/TLS support, please see the RadiantOne System Administration Guide.

## Enable FIPS Mode

For details on deploying RadiantOne in FIPS-mode, to ensure all cryptographic operations are performed using a FIPS 140-2 certified module, see the RadiantOneFIPS_Mode Guide.