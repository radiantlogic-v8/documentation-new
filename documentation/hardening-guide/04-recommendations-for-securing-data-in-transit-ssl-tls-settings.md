---
title: Hardening Guide
description: Hardening Guide
---

# Chapter 4: Recommendations for Securing Data in Transit - SSL/TLS Settings

By default, only SSL-enabled endpoints are accessible to the RadiantOne Service.

## Configure SSL Protocols Allowed for RadiantOne

You can limit the SSL protocols supported in RadiantOne from the Main Control Panel > Settings Tab > Security section > SSL sub-section. Click **Change** next to Enabled SSL Protocols. Select the protocols to support and click OK. Restart the RadiantOne service on all nodes.

>[!note] 
>Only enable the SSL protocols that comply with your company’s security policy.**


## Use Strong Cipher Suites and Disable Weak Ones

1. Open the Main Control Panel.
2. On the Settings Tab > Security section > SSL sub-section, click on the CHANGE button next to Supported Ciphers Suites. Enable only the desired cipher suites.
3. Click SAVE.
4. Restart the RadiantOne service. If deployed in a cluster, restart it on all nodes.


## Advise Application Owners to use the Latest Java Patches

Java patches are currently released quarterly by OpenJDK:
https://wiki.openjdk.java.net/display/jdk8u/Main

Radiant Logic releases patches for RadiantOne approximately one week after OpenJDK releases to ensure support for the latest Java patch is included.

It is highly advised that all client applications connecting to RadiantOne via LDAPS or HTTPS have the latest Java patch in order to reduce the risk of security breaches. This is to ensure the latest bugs and security vulnerabilities have been addressed, and that clients don’t attempt to negotiate obsolete, unsafe or disabled ciphers.

Although you can configure the SSL ciphers and protocols enabled in RadiantOne, it is not advised to enable less secure settings solely to accommodate client applications running older
versions of Java.

## Configure SSL/TLS for Backend Connections

If RadiantOne is connecting to backends over a network connection that is considered unsecure, it is recommended that you configure the connection to use SSL/TLS.

If the backend server uses a certificate issued by a trusted Certificate Authority, then all you need to do is enter the SSL port and check the SSL checkbox when you define the data source.
For database backends, just enter the SSL port in the URL as there is no SSL checkbox.

If the server you are connecting to uses a self-signed certificate, or signed by a Certificate Authority not known by RadiantOne, then this certificate must be imported into the client truststore. Import client certificates into the RadiantOne truststore from the Main Control Panel > Settings Tab > Security section > Client Certificate Truststore. RadiantOne dynamically loads client certificates from here meaning certificates can be added at any time without requiring a restart.

For more information on SSL/TLS support, please see the RadiantOne System Administration Guide.
