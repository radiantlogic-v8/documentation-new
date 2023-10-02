---
title: CFS
description: CFS
---

Microsoft AD FS
===============

> Active Directory Federation Services (AD FS) is an enterprise-specific federation solution that many enterprises have implemented for the purpose of enabling Single Sign On for enterprise users. CFS can accept claims from AD FS as proof of authentication for users, and then send claims about those users to CFS-trusting applications.

CFS can redirect authentication requests to AD FS. AD FS authenticates the user and responds to CFS with a token containing the information about the user. In this context, CFS is a relying party to AD FS and must be configured in AD FS with a relying party trust. After configuring AD FS as a trusted identity provider in the Tenant Administration Dashboard, you must go onto AD FS directly and configure CFS for a relying party trust.

In the Tenant Administration Dashboard, navigate to the Authentication section. Select the "Others" node. Then click "New Trusted Identity Provider".

Presentation
------------

*   Enable this authentication system on CFS Master and / or CFS Proxy.
*   Enter a unique name (this name is displayed on the tenant web portal login page, and helps your users recognize AD FS as an available authentication method).
*   Enter a description (_optional_).
*   If you would like to change the color of the banner shown for AD FS on the CFS login page, enter a hex color value or click a color in the Change the Color field.
*   Click the Choose button next to "Change the Logo" and navigate to the file folder containing the .PNG or .JPG logo image.

>[!note] The logo should be a 30 by 30 pixels png image file.

![](media/adfs-1.png)

Configuration
-------------

*   If you have it, enter the Metadata URL provided by AD FS.
*   Enter the EndPoint URL for AD FS.
*   Click the Choose button next to "Change the Certificate" and navigate to the certificate containing the public key corresponding to the certificate installed in AD FS. CFS only needs the public key in order to check the signature of the token received from AD FS.
*   Select a [Level of Assurance (LOA)](02-getting-started#level-of-assurance) from the drop-down menu. When a user authenticates, they get assigned a Level of Assurance that indicates and enforces which applications they are authorized by CFS to access. A user can be authorized to access an application if the LOA associated with the identity provider/authentication method they authenticated to CFS with is equivalent to or more secure than the level assigned to the application. This setting indicates that when a user authenticates to CFS using AD FS, they can access any application that has an LOA set to Some or Little. Users cannot access any application that has an LOA set to High or VeryHigh (see figure below).

![](media/adfs-2.png)

Mappings
--------

You can change the claims rules which are the mappings that define what information CFS should except to receive from the trusted identity provider.

The default mapping indicate the claim that contain the user’s unique identifier. This claim value is used to identify the user that authenticated through AD FS in the CFS identity store. You can edit the default mapping, or add more claims rules, by clicking on "New Mapping". To remove claims rules, click "Delete". For details on defining claims mappings with the wizard or manually, please see the [Tenant Admin Guide](04-user-roles#tenant-administrator).

> **NOTE:** Trusted Identity Provider Authentication Systems are pre-configured with default mappings. You only need to configure claims rules if the default mappings don’t match your requirements.

![](media/adfs-3.png)

>[!note] Click "Save" to save the configuration of your identity provider.

Set Up a Relying Party Trust in AD FS
-------------------------------------

In AD FS, configure a Relying Party Trust for CFS. Check the Microsoft documentation on how to define this. You can retrieve the CFS metadata from the Configuration Tab to help with the information needed for configuring AD FS.

OpenAM
======

OpenAM is a solution that many enterprises have implemented for the purpose of enabling Single Sign On for users. CFS can accept claims from OpenAM as proof of authentication for users, and then send claims about those users to CFS-trusting applications.

CFS can redirect authentication requests to OpenAM. OpenAM authenticates the user and respond to CFS with a token containing the information about the user. In this context, CFS is a relying party to OpenAM and must be configured in OpenAM with a relying party trust. After configuring OpenAM as a trusted identity provider in the Tenant Administration Dashboard, you must go onto OpenAM directly and configure CFS for a relying party trust.

In the Tenant Administration Dashboard, navigate to the Authentication section, “Others” node. Then click "New Trusted Identity Provider".

Presentation
------------

*   Enable this authentication system on CFS Master and / or CFS Proxy.
*   Enter a unique name (this name is displayed on the tenant web portal login page, and helps your users recognize OpenAM as an available authentication method).
*   Enter a description (_optional_).
*   If you would like to change the color of the banner shown for OpenAM on the CFS login page, enter a hex color value or click a color in the Change the Color field.
*   Click the Choose button next to "Change the Logo" and navigate to the file folder containing the .PNG or .JPG logo image.

>[!note] the logo should be a 30 by 30 pixels png image file.

![](media/openam-1.png)

Configuration
-------------

*   If you have it, enter the Metadata URL provided by OpenAM.
*   Enter the EndPoint URL for OpenAM.
*   Click the Choose button next to "Change the Certificate" and navigate to the certificate containing the public key corresponding to the certificate installed in OpenAM. CFS only needs the public key in order to check the signature of the token received from OpenAM.
*   Select a [Level of Assurance (LOA)](02-getting-started#level-of-assurance) from the drop-down menu. When a user authenticates, they get assigned a LOA that indicates and enforces which applications they are authorized by CFS to access. A user can be authorized to access an application if the LOA associated with the identity provider/authentication method they authenticated to CFS with is equivalent to or more secure than the level assigned to the application. This setting indicates that when a user authenticates to CFS using OpenAM, they can access any application that has an LOA set to Some or Little. Users cannot access any application that has an LOA set to High or VeryHigh (see figure below).

![](media/openam-2.png)

Mappings
--------

You can change the claims rules which are the mappings that define what information CFS should except to receive from the trusted identity provider.

The default mapping indicate the claim that contain the user’s unique identifier. This claim value is used to identify the user that authenticated through OpenAM in the CFS identity store. You can edit the default mapping, or add more claims rules, by clicking on "New Mapping". To remove claims rules, click on "Delete". For details on defining claims mappings with the wizard or manually, please see the [Tenant Admin Guide](04-user-roles#tenant-administrator).

>[!note] Trusted Identity Provider Authentication Systems are pre-configured with default mappings. You only need to configure claims rules if the default mappings don’t match your requirements.

![](media/openam-3.png)

Set Up a Relying Party Trust in OpenAM
--------------------------------------

In OpenAM, configure a Relying Party Trust for CFS. Check the OpenAM documentation on how to define this. You can retrieve the CFS metadata from the Configuration Tab to help with the information needed for configuring OpenAM.

RSA SecurID
===========

>[!note] Using RSA SecurID with the RTC is **deprecated**. RadiantOne Trust Connector version 3.7.2 is the last version that provides the RSA component. Please refer to [Login / Password documentation](login-password#rsa-securid) documentation in order to use RSA SecurID.
> 
> RSA SecurID is an authentication system which provides two-factor authentication for a user to a network resource. RadiantOne CFS provides two ways to authenticate users with RSA SecurID.

CFS integrates with RSA SecurID using a custom RTC and an RSA Authentication Agent. Please refer to the [RadiantOne Trust Connector documentation](02-getting-started#radiant-trust-connectors-rtc) to install the RTC. See the RSA documentation to install the RSA Web Agent on the machine where RTC is installed. Follow this documentation to configure it.

Configure RSA Web Agent
-----------------------

*   Open the IIS Manager Console, expand the Application Pools, right-click on the **RadiantOne Trust Connector** 's application pool and click the Advanced Settings menu item.
*   In the General section. choose **Integrated** in the Managed Pipeline Mode field.
*   In the Process Model section and choose **LocalSystem** in the Identity field.
*   Click OK.

![](media/rsa-4.png)

*   Expand the Sites -> CFS Website -> RTC -> RSASecurIDAccess, and double-click the RSA SecurID icon.

![](media/rsa-1.png)

*   Select the Enable RSA SecurID Web Access Authentication checkbox.
*   Leave the Protect This Resource checkbox unchecked.

![](media/rsa-2.png)

*   Expand the RTC tree to the RSASecurIDAccess -> RSA SecurID node, check the Protect This Resource with RSA SecurID checkbox and click the Apply button.

![](mediaa/rsa-3.png)

CFS Configuration
-----------------

*   Log into CFS with your Tenant Administrator account and navigate to Authentication | Others.

![](media/rsa-5.png)

*   If you want to create the Idp manually then click **New Trusted Identity Provider**.
*   Otherwise, click **Have a metadata file?** on top of the screen. If the CFS machine can contact the RTC machine over https (port 443), you can click **URL**. Use the "Content" option if the RTC machine is not accessible from the CFS machine.

![](media/rsa-6.png)

*   Open a new web browser and navigate to the RSA SecurID page of the RTC ( [https://<SERVER\_ADDRESS>/rtc/RSASecurIDAccess/RSASecurID.aspx](https://<SERVER_ADDRESS>/rtc/RSASecurIDAccess/RSASecurID.aspx) ).

![](mediaa/rsa-7.png)

*   If you want to use the "URL option" copy the link **FederationMetadata.xml** and use it in the CFS page. Click the "Import" button.

![](media/rsa-8.png)

*   If you want to use the "Content option", open the link **FederationMetadata.xml**.

![](media/rsa-9.png)

*   And copy the source of the page in the CFS page. Click "Import".

![](mediaa/rsa-10.png)

*   Most of the parameters are pre-filled.

![](mediaa/rsa-11.png)

*   First, in the **Presentation** tab, you can enable this new Identity Provider on CFS Master and / or CFS Proxy.
*   Provide a name that is clear enough for the end users.
*   Enter a description of this identity provider (_optional_).
*   You can also change the color and the logo of the button that will present this idp.

![](media/rsa-12.png)

*   In the **Configuration** tab, make sure the metadata URL is here if you want to be able to update using the metadata file later on.
*   Make sure the endpoint URL is present and looks like [https://<RTC\_SERVER>/rtc/RSASecurIDAccess/RSASecurID.aspx/WSFed](https://<RTC_SERVER>/rtc/RSASecurIDAccess/RSASecurID.aspx/WSFed)
*   Make sure the certificate is still valid. Otherwise you must update it on the RTC.

![](media/rsa-11.png)

*   In the **Mappings** tab, make sure the Attribute corresponds to the attribute available in FID. The value is the identifier provided by the RSA service.

![](media/rsa-13.png)

*   Here is what the login page looks like with this new RSA SecurdID identity provider.

![](media/rsa-14.png)