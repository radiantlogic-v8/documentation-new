---
title: CFS
description: Step-by-step guide to installing and configuring CFS
---

# Getting Started

This guide explains how to install and configure Cloud Federation Service (CFS), prepare the RadiantOne Federated Identity Service (FID) identity store, and create your first tenant. It also introduces key federation concepts and covers CFS Proxy deployment, Active Directory authentication with RadiantOne Trust Connector (RTC), RTC load balancing, and certificate configuration.

Before you begin, install and configure RadiantOne Federated Identity Service (FID) on a separate server. If you have not completed this step, follow the FID installation and configuration documentation.

CFS supports multiple independent tenants, each with its own users, groups, and applications. For example, you can create separate tenants for your sales and engineering teams so that each team can access the applications it needs. The examples in this guide use the sample directory data included with a basic FID installation to introduce CFS concepts and demonstrate the configuration process.


## Prerequisites

This section describes the prerequisites for installing the Cloud Federation Service (CFS) and Radiant Trust Connectors (RTCs). CFS does not have to be installed on a FID server; however, the FID server must be accessible to the server that CFS is installed on.

### CFS Requirements

Windows users without administrator privileges may launch the CFS installer; however, administrator credentials are required to complete the CFS installation. You are prompted to enter the administrator credentials during installation. SSL must be enabled on the FID prior to installing CFS.

Supported Operating Systems:

-   Windows Server 2016
-   Windows Server 2019

Minimum Hardware Requirements:

-   Memory: 4 GB minimum
-   Disk Space: 750 MB
-   CPU: Intel Pentium 2.4 GHz or equivalent, 2-4 cores

Supported Applications:

A list of supported applications is available in the CFS System Administrator dashboard. Refer to Applications > Web Gallery Node in the [system dashboard](04-user-roles#applications) for more information.

Firewall Ports:

_CFS Master_ and _CFS Proxy API_ must access RadiantOne FID on the configured LDAP SSL port which by default is 636. This port must be opened between the CFS and FID machines. Client browsers must access _CFS Master_ or _CFS Proxy_ on HTTPS port 443. _CFS Proxy_ must be able to communicate with the _CFS Proxy API_ on HTTPS port 443. SMTP is used to send automated emails from CFS. Please make sure the CFS machine can access your SMTP server through the configured port.

Identity Store (FID) Version:

CFS v3.16.2 supports FID v7.1.14 and later, with the exception of:

-   v7.2.20
-   v7.2.21
-   v7.2.22

### Other Microsoft Requirements

-   Web Server IIS 7.5 or higher. (Server Manager > Roles > Web Server (IIS))
-   CFS Version **3.16.2** requires .NET Framework 4.8
    -   If your server doesn't have access to the Internet, you can download the [.NET Framework 4.8 (Offline Installer)](https://go.microsoft.com/fwlink/?linkid=2088631).
    -   If your server does have access to the Internet, you can download the .NET Framework 4.8 (Web Installer)
-   Older versions of CFS only require .NET Framework 4.6.2
    -   If you server doesn't have access to the Internet, you can download the [.NET Framework 4.6.2 (Offline Installer)](https://dotnet.microsoft.com/en-us/download/dotnet-framework/thank-you/net48-web-installer).
    -   This version of the .NET Framework requires to have the Windows Update KB2919355. Make sure your Windows Server is up to date on the Windows Update.
-   ASP.NET v4.6 (Server Manager > Roles > Web Server (IIS) > Web Server > Web Server > Application Development > ASP.NET 4.6)
-   HTTP Activation (Server Manager > Features > .NET Framework 4.6 Features > WCF Services > HTTP Activation)
-   PowerShell 4.0
    -   [What's New in Windows PowerShell](https://technet.microsoft.com/library/hh857339.aspx)
    -   [Download Windows Management Framework 4.0](https://www.microsoft.com/en-us/download/details.aspx?id=40855)
-   RTC only:
    -   Windows Authentication (Server Manager > Roles > Web Server (IIS) > Web Server > Security > Windows Authentication)

### Preparing the Identity Store

The identity store used by CFS is the RadiantOne FID. The FID provides the identity integration layer and the storage for self-registered users.

FID is configured outside of CFS and must be installed/configured prior to installing CFS. When you configure FID, keep the following requirements in mind. The CFS default configuration expects the following (although, you can customize the expected object classes and attributes in the schema settings when you configure the tenant):

-   User entries in FID have the object Class: _inetOrgPerson_
-   User entries in FID have the attributes: _uid_, _mail_, _sn_, _givenName_ and _displayName_
-   Group entries in FID have the object Class: _groupOfUniqueNames_
-   Group entries in FID have the attribute: _uniqueMember_
-   Prior to creating your identity store, all user accounts that are to assume the role of CFS tenant administrator must have an entry in FID in the directory branch of users configured for the tenant. The email address associated with the user account is required when selecting a tenant administrator in CFS.

Depending on the CFS features you plan to use, you must have some attributes available in FID:

-   If you are planning on allowing users to log in (or register) to CFS with a social network account, then the user entries in FID must support the following writable (and searchable) attributes: _SocialFacebookLink_, _SocialGitHubLink_, _SocialGoogleLink_, _SocialInstagramLink_, _SocialLinkedInLink_, _SocialMicrosoftAccountLink_, _SocialPayPalLink_, _SocialTwitterLink_, _SocialWordPressLink_, and _SocialYahooLink_.
-   If you are planning on allowing users to self-register on your CFS portal, then the user entries in FID must support the writable attribute: _IsSelfRegistered_
-   If you are planning on allowing users to reset their passwords by answering challenge questions, then the user entries in FID must support the following writable attributes: _challengeQuestion1_ - _challengeQuestion10_ (e.g. _challengeQuestion1_, _challengeQuestion2_, _challengeQuestion3_ etc...), _challengeAnswer1_ - _challengeAnswer10_ (e.g. _challengeAnswer1_, _challengeAnswer2_, _challengeAnswer3_ etc...)
-   If you are planning on allowing users to reset their passwords, then the user entries in FID must support the writable attribute: _userPassword_.
-   If you are planning to allow users to log in to CFS with two-step verification, then the user entries in FID must support the following writable attributes: _totpSecret_ and _totpSecretNotValidated_
-   A CFS HelpDesk User or Tenant Administrator can lock and lockout user accounts, therefore, the user entries in FID must support a writable attribute: _nsAccountLock_

If the user or group entries integrated by FID originate from a backend store other than the local HDAP storage in FID, the easiest way to extend these entries with the writable attributes mentioned above is by configuring an Extended External Join on your FID virtual view (be sure to mark these attributes as **UPDATEABLE** and **SEARCHABLE** ). For details on configuring extended joins, please see the FID System Admin Guide. Extended joins alleviate the need to extend the schemas of the backend sources in order to support the writable attributes required by CFS. The lifecycle of these extension attributes is managed by and maintained in FID and FID joins this information to the relevant user/group entries when needed.

### Next Steps

After reviewing the prerequisites, continue with the following steps:

1. Learn the key [federation concepts](#concepts).
2. Install and configure [RadiantOne CFS Master](#radiantone-cfs-master).
3. Create your [first tenant](#first-tenant).


## Concepts

### Identity Providers

Identity Provider is the term used to describe any mechanism or system that handles authentication of users, and provides claims about those users to CFS. There are five types of identity providers/authentication systems supported in CFS:

-   Password/Login (Forms Based Authentication)
-   Certificate/PIV card Authentication
-   Social Networks (e.g. Facebook, Twitter...)
-   Trusted Identity Providers (e.g. AD FS, OpenAM...)
-   Active Directory (Radiant Trust Connectors)

![identity providers](media/identity-providers.png)

### Applications

Application is the term used for relying parties/service providers that trust CFS as the identity provider. The CFS System Administrator must enable the applications that tenants can make available through their portals.

The term "Application" can also refer to other Security Token Service's (STS) such as AD FS or OpenAM, which act as Relying Parties to the CFS, accepting claims from CFS and in turn relaying them to service providers which accept them as true statements about an authenticated user. With this approach, enterprises with pre-existing STS's such as OpenAM or AD FS can integrate with CFS to expand their supported applications and extend access to new user populations.

![](media/applications.png)

### Identity Store

An identity store is the user repository used to uniquely identify people for authentication and retrieving profile attributes and groups to package inside tokens. The identity store used by CFS is FID. For more details, please see [Preparing the Identity Store](#preparing-the-identity-store).

### Tenant

CFS supports a multitenancy architecture allowing each configured tenant to manage their own groups, users, identity providers (authentication systems), applications and portal. Each tenant is totally independent and cannot access resources managed by other tenants.

The CFS system administrator configures all tenants and then the designated tenant administrator can configure the groups, users, identity providers and applications applicable for their portal. See the [Tenant Administrator Guide](04-user-roles#tenant-administrator) for configuration details.

### Web Gallery

The web gallery contains all applications that CFS provides a configuration template for. The CFS system administrator must retrieve any applications they want to allow tenants to use in their portal from the web gallery. After an application is installed, it is displayed in the Applications, Available section.

![web gallery](media/web-gallery.png)

### Comparable Federation Terms

Some federation terms have different names across the industry. The chart below is a quick reference guide to various terminology used across prominent federation technologies.

![federation terms](media/federation-terms.png)

### IDP-Initiated SSO

Once CFS has been configured by the CFS system Administrator and the Tenant Administrator has configured their portal, users can log in to the portal and access applications.

When a user accesses the tenant portal, they choose the method with which they want to be authenticated. If they are logged into an Active Directory domain that has been configured by the tenant administrator as supported by the portal, the user is automatically be logged in (no login screen appears). For all other users, the configured login methods are shown.

![](media/idp-initiated-sso1.png)

Once logged in, the user is shown a list of applications they are authorized by CFS to access. By clicking on the icon representing the application, the user is automatically signed in.

![](media/idp-initiated-sso2.png)

For more details, please see the portal user guide.

### RP-Initiated SSO


A user can navigate directly to an application, rather than first going to the portal site. If the user has been previously authenticated by CFS, the user gains access to the application without having to re-authenticate.

If the user has not been authenticated by CFS, they are redirected to the portal login page to authenticate. (If the user is logged in to their AD domain, they are automatically authenticated by CFS, and are redirected to their chosen application, not the CFS login page). Once the user authenticates using one of the enabled methods for the site, they are automatically redirected to the application they were attempting to access. This flow is depicted in the diagram below.

![](media/rp-initiated-sso.png)

Step(s) Flow description:

1.  Browser sends a GET request to application. Because the user has not been authenticated, browser is redirected to the CFS login page.
2.  Browser sends a GET request to CFS to connect to the server.
3.  CFS Portal site
    1.  User chooses to be authenticated using Form Based Authentication, and enters their credentials, which are sent to CFS in a POST. The POST also tells CFS which Application the user wants to access.
    2.  CFS delegates the user authentication to FID, using a "super" filter which combines the filters for FID, for the FBA, and for the application the user is attempting to access.
    3.  If the user can be authenticated, CFS generates and sends an application-specific token to the browser.
4.  The browser sends a POST containing the token to the application, application redirects the browser to the default access page defined in CFS.
5.  The browser requests the page, the Application sends back the page.

### Circle of Trust

Circle of Trust (COT) is one of the methods available for CFS to authorize access to relying parties. The criteria that qualifies a user to be a member of the circle of trust is based on IP Address or DNS. Each IP Address/DNS is associated with a "location" (e.g. Headquarters, BuildingA, BuildingB) and this rule is evaluated when the user logs into CFS. The user can be authorized to access a relying party if their IP address or DNS is indicated in the Circle of Trust rule associated with the relying party.

### Level of Assurance

Level of Assurance (LOA) is one of the methods available for CFS to authorize access to relying parties and is modeled on the FICAM Trust Framework leveraged by the United States Government. A Level of Assurance is assigned to each identity provider/authentication method (e.g. Forms-Based, Certificate authentication, Active Directory) and describes the degree of certainty and confidence that the user has presented a valid identifier that refers to his or her identity. CFS offers four levels of assurance: **Little**, **Some**, **High** and **Very High**.

Levels of Assurance are also assigned to relying parties. A user can be authorized to access a relying party if the Level of Assurance (LOA) associated with the identity provider/authentication method they authenticated with is equivalent to or more secure than the level assigned to the relying party.

### Next Steps

Now you know the basic concepts of federation, follow the steps.

## RadiantOne CFS Master

The RadiantOne CFS and Radiant Trust Connector (RTC) install files are available via an FTP site.

>[!note] Contact support@radiantlogic.com for access information.

Once you get access to the site, you will find a folder name "installers" that contains all the executable and their relative msi files. Ensure you run the .exe files directly from this folder, as each executable has dependencies on its corresponding .msi file and on ExeRunner.exe. Running them from another location may break these dependencies and result in installation failures. 

### FID LDAPs Certificate

Installing the FID Certificate on the CFS Server allows CFS to communicate with the FID over an SSL connection. CFS requires an SSL connection.

1.  On the **FID Server**, navigate to `%RLI_HOME%/vds_server/conf` and copy the file `rli.cer` on the desktop of the **CFS Master** machine. 
   
    ![](media/fid-cert-1.png)

1.  Right-click that certificate and select "Install Certificate".

1.  Change the Store Location to the "Local Machine" radio button and select "Next". (You need Administrator credentials to complete this step.)

1.  Select the "Place all certificates in the following store" radio button and then select "Browse...". 
   
    ![](media/fid-cert-2.png)

1.  Select "Trusted Root Certificate Authorities" and then select "OK", then "Next" and on the "Completing the Certificate Import Wizard" select Finish. You will see a successful import, as below. 
   
![](media/fid-cert-3.png)

### Installing CFS Master

The CFS installer automatically installs all the required components (including the monitoring console), makes the necessary configurations, and creates a new web site in IIS. Please follow the following steps to install CFS Master.

1.  Log in to the Windows Server machine where you want to install CFS. You do not require Administrator privileges, but Administrator credentials are required to complete the installation CFS process.
2.  Double click the executable `Radiant Logic, Inc. - Cloud Federation Service - <version #>.exe` downloaded from the FTP site. The CFS installer launches.
3.  Click the **I agree to the license terms and conditions** check box and click Install. 
   
   ![](media/master-1.png)

4.  When asked if you want to allow CFS to make changes to the computer, click Yes. If prompted, enter an administrator password. 
   
   ![](media/master-2.png)

5.  The setup then configures your machine with all the required features and components (Microsoft IIS, ASP.NET...). ![](media/master-3.png)

6.  On the **Welcome to Cloud Federation Service** screen, click Next. ![](media/master-4.png)

7.  On the **Select the features you want to install** screen, you can choose the CFS features (or components) to install or not.
    1.  The System Dashboard web site allows you to configure the tenants, packages (applications and themes) and other CFS features. You should install this feature at least once in your IIS Web Farm. ![](media/master-5.png)
    2.  If you do not want to install this feature, click on the name and select **Entire feature will be unavailable**.
    3.  The CFS Proxy Web API is the web site that CFS Proxy use as a backend. You can either install all the components on the same machine or install this CFS Proxy Web API on a separate machine for better performance. ![](media/master-6.png)
8.  On the **Federated Identity Service Configuration** you have to enter the information to use to connect to FID. ![](media/master-7.png)
    1.  This is the connection to the FID that CFS points to for authenticating users, retrieving attributes and store its configuration. Since CFS only connects to FID over SSL (and the FQDN of the FID machine is the subject in the self-generated certificate), you must enter the FQDN for the host. To make sure you have the correct address for your FID, open the SSL certificate and use the issuer property for the host.
    2.  The FID SSL certificate must be trusted on the CFS machine (in the Computer certificate store, Trusted Root Certificates).
    3.  If the certificate is not trusted on your server, it should open itself for you to put it in your certificate store. ![](media/master-8.png)
    4.  To update the FID Certificate used for the SSL communications, please refer to the FID documentation.
9.  On the **Ready to install Cloud Federation Service** click Install. ![](media/master-9.png)
10.   The install should take a few minutes. ![](media/master-10.png)
11.   Once the install is complete, click Finish. ![](media/master-11.png)
12.  If an error happened during the installation, a link should display on the next screen to see the logs. ![](media/master-12.png)

### Uninstalling CFS Master

1.  To uninstall CFS Master, go to the Windows Control Panel, select Programs, Uninstall a program. In the list of applications installed, select Cloud Federation Service and click Uninstall.

2.  Click Uninstall.
   
    ![](media/uninstall-1.png)
    
3.  Let the setup uninstall the RTC. 
   
    ![](media/uninstall-2.png)
    
4.  The setup has successfuly uninstalled the RTC. 
   
    ![](media/uninstall-3.png)



### Next Steps

Now you have installed and configure RadiantOne CFS, follow the steps.

-   Create the [first tenant](#first-tenant).


## First Tenant

After your installation has completed, open your web browser. In the address bar enter the address of your CFS: `[https://<CFS_SERVER>/system/](https://<CFS_SERVER>/system/)`

![](media/first-tenant1.png)

>[!note] Select "Continue to this website (not recommended)". The reason this appears is because CFS is hosted on Microsoft's IIS Web Server and installs a self-signed certificate during installation that is not trusted by your machine. There are instructions on how to correct this in the [Microsoft IIS](05-deployment#change-the-ssl-certificate) section.

### Installation Wizard

The Global Administration Page takes some time to load for the first time, but when it does, it should look something like this.

![](media/first-tenant2.png)

Log into the console using the super user information you identified in both the installation of FID and the installation of CFS. This is cn=directory manager by default, and a password that you created. Click "Start the configuration".

![](media/first-tenant3.png)

For this guide, we accept the defaults on Step 1 of the Configuration Page. If you later want to install a CFS Proxy, you can do so by following the steps at [CFS Proxy](#radiantone-cfs-proxy).

![](media/first-tenant4.png)

For this guide, we decline setting up the SMTP server on Step 2 of the Configuration Page. If you later want to set up the SMTP server, you can do so by following the steps in the [System Administrator Guide](04-user-roles#smtp).

![](media/first-tenant5.png)

To understand what applications and options are available to us during the configuration of CFS, we download the themes and applications during Step 3 of the Configuration.

![](media/first-tenant6.png)

Once this process has completed, you are at the end of the configuration process and can navigate to the CFS System Dashboard.

![](media/first-tenant7.png)

### System Dashboard

At this point, you are logged in as the Directory Manager and able to configure CFS at the Global Level. That means that you won't be able to directly give users access to applications, but you can create Tenants and give Tenant Administrators the ability to make Applications available to the users. Click **Tenants** on the left hand side of the page and select "New Tenant". In the name field, you are asked for a name. This is arbitrary. For our tenant, we call it "Accounting". The Identifier is automatically generated.

![](media/first-tenant8.png)

Switch over to the Locations Tab. These fields deal with entries in the FID. Since we are configuring the Accounting Tenant right now, we indicate the naming context that holds our accounting division, both groups and users in FID. Also, we create two new groups in FID to be our Helpdesk and Administrators group for this tenant. To do this, bring up your FID Control Panel and navigate to the Directory Browser.

![](media/first-tenant9.png)

Expand ou=Accounting,o=companydirectory. Right click on ou=Accounting then select "Add"" and "New Group". In the resulting pop up window, enter CFS Admins in the Group Name field. In my example, I have selected object classe groupOfUniqueNames.

![](media/first-tenant10.png)

Repeat this process for another group and call it CFS Helpdesk. When complete, your namespace should look similar to this.

![](media/first-tenant11.png)

Before we leave the FID Control Panel, we need to ensure that we know the password for the user that we designate as the Tenant Administrator. To do this, select uid=Aaron\_Medler in the Directory Browser. In the attributes pane on the right, double click **userPassword**. Erase what is there and enter a password of your choice. While there, also take note of Aaron Medler's email address. You need it in a later step.

Now that your Admin and Helpdesk groups are created, you can go back to your CFS Administration Console. We left off at the locations tab. Under the fields on this tab now, you can fill them in to match the namespace that you were just working with on the FID. For this example, it would look like what is shown below:

![](media/first-tenant12.png)

Lastly, select the Schema tab. This defines what the users, groups, and some attributes are that CFS should look for in this tenant when requesting information from the FID. By default, it uses a traditional LDAP schema with inetOrgPerson as the User Object Class and groupOfUniqueNames as the Group Object Class. Our users in our People DN do not have a displayName attribute populated, though, so we will change the value in the Display Name field to cn. When this tab is completed, click **Save** at the bottom of the pane.

![](media/first-tenant13.png)

The first time you configure a Tenant and click Save, you are asked for the email address of the Tenant Administrator. Enter Aaron Medler's email address and click "Check!" to make sure that you have entered it correctly. Then click Save.

![](media/first-tenant14.png)

Once complete, you are taken to the Registered Tenants Tab and you will see the Tenant that you just added.

![](media/first-tenant15.png)

Now, log out of the control panel by clicking the arrow in the top right next to the Welcome, Directory Manager message and select "Logout". You are taken back to the login screen. This, however, is the login screen for global administrators, not for tenant administrators.

### Tenant Portal

Use the address bar in your browser to navigate to `[https://<CFS_SERVER>/cfs/](https://<CFS_SERVER>/cfs/)`

The login page looks near identical to the one for global administration, except it is now asking for an email address instead of a login and has the option to recover your password if you have forgotten it. Log in here with Aaron Medler's email address and the password that you created for his account.

![](media/first-tenant16.png)

The screen that you are taken to is the default portal for all the users of that Tenant. However, since Aaron Medler is an administrator, he has an additional option on the left side. Select Administration on the bottom of the left option pane.

![](media/first-tenant17.png)

Here, you are able to administer your Tenant, as described in the [Tenant Administration](04-user-roles#tenant-administrator) portion of this documentation.

### Next Steps

Now you have installed and configure RadiantOne CFS and created your first tenant you can follow the guide.

-   Install and configure [CFS Proxy](#radiantone-cfs-proxy).
-   Install and configure [RTC](#radiantone-trust-connector).
-   Configure the different [Certificates](#certificates).

## RadiantOne CFS Proxy

The CFS Proxy allows external users to access CFS while protecting the identities stored in FID from external attacks by removing the direct link between CFS (in the DMZ) and FID. A CFS proxy may connect to only one master CFS Proxy Web API. The CFS Proxy could also point to a load balancer which distributes traffic to multiple CFS Proxy Web API if needed.

![](media/figure-proxy.png)

Internal users still use the CFS Master directly to access applications. Only internal users have access to CFS's administration panels. External users exchange information with the CFS Proxy. This server contacts a CFS Proxy Web API server located inside the corporate network through REST calls over HTTPS. Then, the CFS Proxy Web API server contacts FID to get the information needed.

### Create a CFS Proxy

You must have installed a CFS Master with the System Dashboard in order to add a CFS Proxy in the system.

Log in as **cn=Directory Manager** into the System Dashboard at the address `[https://<CFS_ADDRESS>/system/](https://<CFS_ADDRESS>/system/)`

![](media/proxy-1.png)

Navigate to **Dashboard | Servers** and click **new Proxy server**.

![](media/proxy-2.png)

Keep the next screen on hand; you need to get the **id** and **secret** keys for the next step.

![](media/proxy-3.png)

>[!note] Make sure you have installed a CFS Proxy Web API in your network in order for the CFS Proxy to communicate with FID. Follow the steps of the [RadiantOne CFS Master](#radiantone-cfs-master) to install the CFS Proxy Web API.

### Installing CFS Proxy

The CFS Proxy installer automatically installs all the required components (including the monitoring console), makes the necessary configurations, and creates a new web site in IIS. Please follow the following steps to install CFS Proxy.

Log in to the Windows Server machine where you want to install CFS Proxy. You do not require Administrator privileges, but Administrator credentials are required to complete the installation CFS process.

Double click the executable `Radiant Logic, Inc. - Cloud Federation Service Proxy - <version#>.exe` downloaded from the FTP site. The CFS installer launches.

Click the **I agree to the license terms and conditions** check box and click Install.

![](media/proxy-4.png)

When asked if you want to allow CFS to make changes to the computer, click Yes. If prompted, enter an administrator password. The setup then configures your machine with all the required features and components (Microsoft IIS, ASP.NET...).

![](media/proxy-5.png)

On the **Welcome to Cloud Federation Service Proxy** screen, click Next.

![](media/proxy-6.png)

On the **Cloud Federation Service - Proxy Configuration** you have to enter the information to use to connect to CFS Proxy Web API.

![](media/proxy-7.png)

-   The URL must be something like: `[https://<CFS_SERVER>/api/](https://<CFS_SERVER>/api/)`
-   Use the keys you have created at the previous step in the System Dashboard.
-   Make sure the HTTPS connection has a valid SSL certificate otherwise the connection does not work.

On the **Ready to install Cloud Federation Service Proxy** click Install.

![](media/proxy-8.png)

The install should take a few minutes.

![](media/proxy-9.png)

Once the install is complete, click Finish.

![](media/proxy-10.png)

>[!note] If an error happened during the installation, a link should display on the next screen to see the logs.

![](media/proxy-11.png)

### Uninstalling CFS Proxy

1.  To uninstall CFS Proxy, go to the Windows Control Panel, select Programs, Uninstall a program. In the list of applications installed, select Cloud Federation Service Proxy and click Uninstall.
2.  Click Uninstall. 
   
   ![](media/uninstall4.png)
    
3.  Let the setup uninstall the CFS Proxy. ![](media/uninstall5.png)
    
4.  The setup has successfuly uninstalled the CFS Proxy. ![](media/uninstall6.png)
    
### Next Steps

Now you have installed and configure RadiantOne CFS Proxy, you can follow the guide.

-   Install and configure [RTC](#radiantone-trust-connector).
-   Configure the different [Certificates](#certificates).

## RadiantOne Trust Connector

Install an RTC for each Active Directory forest you want to use as an Authentication System within CFS. If you do not want to support Active Directory (NTLM/Kerberos) authentication, then you do not need to install an RTC. It is advised that the default self-signed certificate for each RTC be replaced with a certificate designated exclusively for use by that RTC. Also, make sure the name you are using to access this RTC through the web browser is the FQDN of the machine, otherwise the kerberos token is not be sent to the server and the end user is prompted for his/her credentials. The same is true if the SSL certificate is not valid.

### Installing the RTC

1.  Double click `Radiant Logic, Inc. CFS Radiant Trust Connector - <version#>.exe`.
2.  Check the **I agree to the license terms and conditions** check box and click Install.
3.  When asked if you want to allow the installer to make changes to the computer, click Yes. If prompted, enter an administrator password.
4.  Follow the installer instructions. The installer automatically configures the RTC in IIS.
5.  Click Finish to exit the installer.

![](media/rtc-0.png)

### Configuring the RTC Behind a Load Balancer

This section describes how to run two RadiantOne Trust Connector (RTC) servers behind an AWS Network Load Balancer (NLB), with Cloud Federation Service (CFS) accepting the sign-in.

The load balancer sits in front of RTC only. CFS remains on the first server and is still opened at its existing address, `<cfs-fqdn>`. Placing CFS behind a load balancer is a separate topic and is not covered here.

Browsers sign in to RTC through a single DNS name, and the load balancer forwards those connections to either RTC server.

#### Placeholders Used in This Section

Replace the following placeholders with the values for your environment.

| Placeholder | Description | Example |
| --- | --- | --- |
| `<dns-domain>` | Active Directory DNS domain | `corp.example.com` |
| `<netbios>` | Active Directory NetBIOS name | `CORP` |
| `<rtc-fqdn>` | DNS name that browsers use for RTC | `rtc.corp.example.com` |
| `<cfs-fqdn>` | Existing DNS name used to open CFS | `cfs.corp.example.com` |
| `<rtc-host>` | Host label of `<rtc-fqdn>` | `rtc` |
| `<nlb-private-ip>` | Each private IPv4 address of the load balancer | |
| `<rtc-server-1-ip>` | Private IPv4 address of the first RTC server | |
| `<domain-controller-ip>` | Private IPv4 address of a domain controller | |
| `<vpc-cidr>` | IPv4 CIDR of the VPC | |
| `<aws-region>` | AWS region of the servers | |
| `<nlb-dns-name>` | DNS name that AWS assigns to the load balancer | |

This section uses the suggested resource names `svc-rtc`, `rtc-nlb`, and `rtc-443`. You can use different names.

#### Deployment Overview

When you complete this section, the deployment looks like this:

| Item | Value |
| --- | --- |
| Domain | `<dns-domain>` |
| RTC address | `<rtc-fqdn>` |
| CFS address | `<cfs-fqdn>` on RTC server 1 |
| Load balancer | Internal Network Load Balancer `rtc-nlb`, TCP 443 |
| Load balancer address | `<nlb-private-ip>` |
| Target group | `rtc-443` |
| RTC server 1 | CFS and RTC |
| RTC server 2 | RTC only |
| Service account | `<netbios>\svc-rtc` |
| Kerberos name | `HTTP/<rtc-fqdn>` |
| CFS endpoint | `https://<rtc-fqdn>/rtc/RadiantTrustedConnector.svc/WSFed` |

```
Browser (domain user)
    |
    |  https://<rtc-fqdn>
    v
DNS A record  <rtc-fqdn>  ->  <nlb-private-ip>
    |
    v
Internal Network Load Balancer  (TCP 443, TLS passed through)
    |
    +-- RTC server 1   CFS + RTC
    +-- RTC server 2   RTC
```

Keep the following in mind:

- TLS terminates on each Windows server; the load balancer does not decrypt it.
- Both servers share one Kerberos service account, one HTTPS certificate, and one token-signing certificate.
- Each domain-joined computer must be able to reach a domain controller.
- Users must sign in with a domain account. A local server administrator cannot obtain a Kerberos ticket.
- The clocks on the domain controllers and both RTC servers must be within five minutes of each other. If they are further apart, Kerberos fails before the request reaches IIS.

#### Step 1: Configure Active Directory

On a domain controller:

1. Create a service account named `svc-rtc`, or reuse an existing one. The account must be enabled, have a known password, and use AES Kerberos encryption.
2. Register a single service principal name (SPN) on that account. The SPN is the name the browser uses, and it is held by the shared service account:
   - Create one SPN, `HTTP/<rtc-fqdn>`, on `svc-rtc`.
   - The load balancer's AWS DNS name must not have an SPN.
   - `setspn -Q HTTP/<rtc-fqdn>` must list only `svc-rtc`.
   - `<rtc-fqdn>` must not be the computer name of either RTC server.

   ```
   Enable-ADAccount svc-rtc
   Set-ADUser svc-rtc -KerberosEncryptionType AES128,AES256 -PasswordNeverExpires $true
   setspn -S HTTP/<rtc-fqdn> svc-rtc
   setspn -Q HTTP/<rtc-fqdn>
   ```

   >[!note] If you set `KerberosEncryptionType` to AES on an account that already has a password, reset the password so that the AES keys are created.

   `setspn -Q` must list only `svc-rtc`. `setspn` cannot find a disabled account until the account is enabled. Leave Kerberos delegation unset. RTC reads the Windows identity and signs its own token; it does not forward the user's Kerberos ticket.

3. Create a DNS A record for `<rtc-fqdn>`. While you test the first server, point the record at `<rtc-server-1-ip>`. After the load balancer is in place, point it at `<nlb-private-ip>`.

   ```
   Add-DnsServerResourceRecordA -Name "<rtc-host>" -ZoneName "<dns-domain>" -IPv4Address "<rtc-server-1-ip>"
   ```

   >[!warning] Use an A record, not a CNAME. A CNAME can cause Windows to request a ticket for the load balancer's AWS DNS name, which does not match `HTTP/<rtc-fqdn>`.

#### Step 2: Prepare the Certificates

This deployment requires two different certificates.

##### HTTPS Certificate

The HTTPS certificate secures the browser connection. It must include both of these names:

- `<rtc-fqdn>`
- `<cfs-fqdn>`

The second name keeps the existing CFS address working. Bind the certificate to port 443 on every RTC server. Browsers that sign in must trust the certificate. Store it in **Local Computer > Personal** on each RTC server, and in **Trusted Root Certification Authorities** on any computer that must trust a certificate you issued yourself.

>[!note] The HTTPS certificate is not the certificate configured on the CFS Active Directory connector.

##### Token-Signing Certificate

RTC signs the WS-Federation token with the certificate that the RTC installer creates. When the installer generates this certificate, its subject is:

`CN=RadiantOne Trust Connector certificate`

On each server, the installer stores the certificate in the RTC `Web.config` file and places the public certificate in **Local Computer > Trusted Root Certification Authorities**. CFS must be given this public certificate. You cannot use the HTTPS certificate for this purpose.

During the first setup, CFS does not yet have this certificate, so there is no **Current Certificate** thumbprint to match. Export the installer certificate from server 1 and upload the `.cer` file. **Current Certificate** should then show it.

Later, **Trusted Root** can contain more than one certificate with this subject. In that case, export the certificate whose thumbprint matches **Current Certificate**.

#### Step 3: Configure the First RTC Server

Install CFS and RTC on the first Windows server. RTC uses the following IIS layout:

- Site: `CFS Website`
- Application: `/rtc`
- Physical path: `C:\inetpub\wwwroot\CFS Web Site\rtc`
- Application pool: `RadiantOne Trust Connector`

Before you install RTC, install the following Windows features. `Web-Mgmt-Console` provides IIS Manager, and `NET-WCF-HTTP-Activation45` registers the handler for `.svc` files.

```
Install-WindowsFeature Web-Server, Web-WebServer, Web-Mgmt-Console, Web-Windows-Auth, Web-Asp-Net45, NET-Framework-45-ASPNET, NET-WCF-HTTP-Activation45 -IncludeManagementTools
```

##### Configure the Application Pool

Configure the application pool to run as `<netbios>\svc-rtc`, with **Load User Profile** enabled. The account must be a member of the local `IIS_IUSRS` group and have the **Log on as a service** right. If that right or the pool password is missing, IIS returns HTTP 503.

>[!warning] The `appcmd` command below passes the `svc-rtc` password on the command line, where it can be saved in PowerShell history. If the password must not appear in that history, set the identity in IIS Manager instead.

```
$pwd = Read-Host "svc-rtc password"
& "$env:windir\system32\inetsrv\appcmd.exe" set apppool "RadiantOne Trust Connector" "/processModel.identityType:SpecificUser" "/processModel.userName:<netbios>\svc-rtc" "/processModel.password:$pwd" "/processModel.loadUserProfile:true"
& "$env:windir\system32\inetsrv\appcmd.exe" start apppool "RadiantOne Trust Connector"
```

Before you rely on a load-balancer health check, open **Application Pools** and confirm that `RadiantOne Trust Connector` is **Started**. The TCP health check can remain **Healthy** while this pool is stopped, and IIS then returns HTTP 503.

##### Enable Windows Authentication

Leave anonymous authentication enabled. Enable Windows authentication for `/rtc` and configure IIS to decrypt the Kerberos ticket with the application pool account:

```
Import-Module WebAdministration
$site = "IIS:\Sites\CFS Website\rtc"
$filter = "system.webServer/security/authentication/windowsAuthentication"
& "$env:windir\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/security/authentication/windowsAuthentication
Set-WebConfigurationProperty -PSPath $site -Filter $filter -Name enabled -Value $true
Set-WebConfigurationProperty -PSPath $site -Filter $filter -Name useAppPoolCredentials -Value $true
Set-WebConfigurationProperty -PSPath $site -Filter $filter -Name useKernelMode -Value $true
```

`useAppPoolCredentials` is required because the Kerberos ticket is encrypted for `svc-rtc`, which holds `HTTP/<rtc-fqdn>`.

##### Bind the HTTPS Certificate

Bind the HTTPS certificate that contains `<rtc-fqdn>` to `CFS Website` on port 443.

##### Check Ticket Issuance

From a domain-joined computer, request a ticket before you open a browser:

```
C:\Windows\System32\klist.exe get HTTP/<rtc-fqdn>
```

A successful result shows `Server: HTTP/<rtc-fqdn>`.

This command only tests ticket issuance. The ticket remains in the cache, so a later `klist` can show it even when the browser signed in with NTLM. Negotiate falls back to NTLM when the SPN is wrong, and IIS also returns 200 for a domain account with NTLM. An NTLM fallback hides an SPN problem until another client fails. The checks in [Step 8: Confirm the Sign-in](#step-8-confirm-the-sign-in) provide the proof, and they begin by closing the browser and purging this ticket.

To test `https://<rtc-fqdn>` in a browser on the RTC server itself, add the following value and then run `iisreset`. This value is needed only for that local test:

```
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "BackConnectionHostNames" -PropertyType MultiString -Value "<rtc-fqdn>" -Force
```

#### Step 4: Configure Browsers

Users must open `https://<rtc-fqdn>`. An IP address, the computer name of either server, or the load balancer's AWS DNS name does not match `HTTP/<rtc-fqdn>`.

The sign-in flow works as follows:

1. CFS sends the browser to `https://<rtc-fqdn>/rtc/RadiantTrustedConnector.svc/WSFed`.
2. That page loads a test image from `https://<rtc-fqdn>/rtc/IntegAccess/RTCService.svc/TestAccess_<guid>.bmp`.
3. If the image loads, the browser continues to `https://<rtc-fqdn>/rtc/IntegAccess/RTCService.svc/WSFed`, which performs Windows authentication and issues the token. If the image fails to load, RTC takes the `NotAuth` path and returns an unauthenticated token.

Edge and Chrome do not show a credential prompt for the test image, so automatic logon must already be allowed for `<rtc-fqdn>`. A credential prompt on `https://<rtc-fqdn>/rtc/IntegAccess/RTCService.svc` only proves that a navigation can authenticate. CFS sign-in depends on the image request, which does not prompt.

Keep JavaScript enabled. The handoff is performed by a script on that page.

##### Windows, Microsoft Edge, and Chrome

1. Open **Control Panel > Internet Options > Security > Local intranet > Sites > Advanced**, and add `https://<rtc-fqdn>`.
2. Return to **Local intranet** and click **Custom level**. Under **User Authentication > Logon**, select **Automatic logon only in Intranet zone**.
3. Open **Internet Options > Advanced > Security**, and select **Enable Integrated Windows Authentication**. Restart the browser.
4. On managed browsers, add `<rtc-fqdn>` to the Edge and Chrome `AuthServerAllowlist` policy.

>[!warning] The `AuthServerAllowlist` policy replaces the browser's integrated authentication server list. A value that contains only `<rtc-fqdn>` turns off integrated authentication for every other host. Include the hosts that already rely on integrated authentication, along with `<rtc-fqdn>`.

##### Firefox

Firefox does not use Internet Options. Add `https://<rtc-fqdn>` to the existing values of `network.negotiate-auth.trusted-uris` and `network.automatic-ntlm-auth.trusted-uris`.

>[!warning] Do not replace either preference with only `https://<rtc-fqdn>`. Doing so removes integrated authentication for the hosts that were already listed.

#### Step 5: Configure the CFS Active Directory Connector

In CFS Admin, navigate to **Authentication > Active Directory** and edit the connector. Set the following fields:

| Field | Value |
| --- | --- |
| Endpoint | `https://<rtc-fqdn>/rtc/RadiantTrustedConnector.svc/WSFed` |
| Active Directory domains | `<dns-domain>` |
| Certificate | Public certificate of the RTC token-signing certificate |

During the first setup, export the installer certificate from server 1. Trusted Root usually contains one certificate with this subject:

```
Get-ChildItem Cert:\LocalMachine\Root |
  Where-Object { $_.Subject -eq "CN=RadiantOne Trust Connector certificate" } |
  ForEach-Object { Export-Certificate -Cert $_ -FilePath C:\rtc-signing.cer -Force }
```

Upload `C:\rtc-signing.cer` under **Change the Certificate** and save. **Current Certificate** should then show that certificate.

If Trusted Root contains more than one certificate with that subject, export only the certificate whose thumbprint appears in **Current Certificate**. The command above writes every match to the same file, so only the last certificate in the store remains.

```
Get-ChildItem Cert:\LocalMachine\Root |
  Where-Object { $_.Thumbprint -eq "<thumbprint>" } |
  ForEach-Object { Export-Certificate -Cert $_ -FilePath C:\rtc-signing.cer -Force }
```

Do not use **Update from Metadata**. After this change, signing in to CFS redirects the browser to `<rtc-fqdn>` and then returns the user to CFS.

#### Step 6: Configure the Load Balancer

Create the load balancer in `<aws-region>`, in the same VPC as the RTC servers (`<vpc-cidr>`).

##### Create the Target Group

In the EC2 console, under **Load Balancing**, create a target group with the following settings:

| Setting | Value |
| --- | --- |
| Target type | Instances |
| Name | `rtc-443` |
| Protocol | TCP |
| Port | 443 |
| Health check | TCP |

Register the first RTC server on port 443.

The TCP health check confirms that port 443 accepts a connection. Before you treat **Healthy** as a working RTC, confirm that the `RadiantOne Trust Connector` application pool is **Started**. The target remains **Healthy** while that pool is stopped, and IIS then returns HTTP 503.

##### Create the Network Load Balancer

Create a Network Load Balancer with the following settings:

| Setting | Value |
| --- | --- |
| Name | `rtc-nlb` |
| Scheme | Internal |
| Listener | TCP 443 |
| Forward to | `rtc-443` |
| Subnets | The Availability Zone of each RTC server |

AWS assigns a private IPv4 address in each enabled zone. The console label **Assigned by AWS** refers to the allocation method. To read the addresses, resolve `<nlb-dns-name>` from a computer in the VPC:

```
Resolve-DnsName <nlb-dns-name>
```

Each A record returned is an `<nlb-private-ip>`.

If the RTC servers are in different Availability Zones, enable each of those zones on the load balancer and turn on **Cross-zone load balancing**. A target in a zone that is not enabled stays in the **Unused** state. With cross-zone load balancing, sign-in still works when one zone is unavailable, because a remaining load balancer address can reach the RTC servers in the other zone.

##### Configure Security Groups

| Resource | Rule |
| --- | --- |
| `rtc-nlb` | Inbound TCP 443 from `<vpc-cidr>` |
| Each RTC instance | Inbound TCP 443 from the clients that sign in |
| Each RTC instance | Inbound TCP 443 from the load balancer private addresses, or from the subnets those addresses belong to |

Keep the following in mind when you set these rules:

- Client traffic arrives with the client address, because this load balancer preserves it. A rule that allows only the load balancer security group causes client timeouts.
- Health checks come from the load balancer node addresses. A target whose security group allows only the client range stays unhealthy, because those packets do not come from the clients.
- The load balancer drops connections when its own security group does not allow port 443.
- The load balancer does not respond to ping, so a failed ping does not indicate a problem.

Before you change DNS, confirm the path. Run the following command for each `<nlb-private-ip>`:

```
Test-NetConnection <nlb-private-ip> -Port 443
```

`TcpTestSucceeded` must be `True`.

##### Switch DNS to the Load Balancer

If the load balancer has one private address, point the existing A record at that address:

```
$rec = Get-DnsServerResourceRecord -ZoneName "<dns-domain>" -Name "<rtc-host>" -RRType A
$new = $rec.Clone()
$new.RecordData.IPv4Address = [ipaddress]"<nlb-private-ip>"
Set-DnsServerResourceRecord -ZoneName "<dns-domain>" -OldInputObject $rec -NewInputObject $new
```

If the servers are in more than one Availability Zone, `<rtc-fqdn>` needs one A record for each load balancer private address. The SPN remains `HTTP/<rtc-fqdn>`. A single A record that points to one private IP fails when that zone is unavailable, even if the other RTC server is running.

Replace the existing `<rtc-server-1-ip>` record with the first load balancer address; the script above performs this replacement. Do not include the RTC server address in the set, or some clients bypass the load balancer. Then add one A record for each additional load balancer address:

```
Add-DnsServerResourceRecordA -Name "<rtc-host>" -ZoneName "<dns-domain>" -IPv4Address "<nlb-private-ip>"
```

`Resolve-DnsName <rtc-fqdn>` should list only the load balancer addresses. Sign in to CFS again. The browser still uses `https://<rtc-fqdn>`, and CFS still uses the same endpoint and signing certificate.

#### Step 7: Configure the Second RTC Server

Launch a Windows server in the same VPC and security group as the first RTC server. Join it to `<dns-domain>`, using `<domain-controller-ip>` as its DNS server. After the restart, sign in with a domain account.

Install the same Windows features listed for the first server, and then install RTC with the same RadiantOne Trust Connector installer.

##### Use the Same Token-Signing Certificate

On the first server, export the signing certificate from the RTC configuration by running the script below in Windows PowerShell 5.1 (`powershell.exe`). PowerShell 7 cannot deserialize the `Web.config` value. Because the installer protects this value with the machine, copying `Web.config` to the new server does not work.

When the installer generates the certificate, it stores an empty `password` value. Unprotect `password` only when the value is not empty. An empty value is not protected data, and attempting to unprotect it stops the script before it writes the PFX. If a password-protected PFX was imported during installation, the non-empty value unprotects to the password that `X509Certificate2` needs.

```
Add-Type -AssemblyName System.Security
$entropy = [byte[]](5,1,7,5,3)
function Unprotect-Rtc([string]$cipher) {
  $protected = [Convert]::FromBase64String($cipher)
  $clear = [System.Security.Cryptography.ProtectedData]::Unprotect($protected, $entropy, 'LocalMachine')
  $ms = New-Object System.IO.MemoryStream(,$clear)
  $formatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
  return $formatter.Deserialize($ms)
}
[xml]$cfg = Get-Content "C:\inetpub\wwwroot\CFS Web Site\rtc\Web.config"
$certB64 = Unprotect-Rtc (($cfg.configuration.appSettings.add | Where-Object key -eq "certificate").value)
$passwordSetting = ($cfg.configuration.appSettings.add | Where-Object key -eq "password").value
if ([string]::IsNullOrEmpty($passwordSetting)) {
  $storedPassword = ""
} else {
  $storedPassword = Unprotect-Rtc $passwordSetting
}
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(
  [Convert]::FromBase64String($certB64), $storedPassword, "Exportable")
$secure = Read-Host -AsSecureString "PFX password"
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try {
  $plain = [Runtime.InteropServices.Marshal]::PtrToStringUni($bstr)
  [IO.File]::WriteAllBytes("C:\rtc-signing-protected.pfx", $cert.Export("Pkcs12", $plain))
}
finally {
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
}
```

Also export the HTTPS certificate from **Local Computer > Personal** on the first server. Copy both PFX files to the new server.

On the second server:

1. In IIS Manager, select the `/rtc` application and open **RadiantOne Trust Connector > Change the certificate**. Select the signing certificate PFX. This writes a new machine-protected value into that server's `Web.config`.
2. Import the HTTPS PFX and bind it to port 443.
3. Apply the same application pool identity and Windows authentication settings used on the first server. The pool must remain **Started**.

##### Register the Second Server

In target group `rtc-443`, register the new instance on port 443. Enable its Availability Zone on `rtc-nlb` and leave cross-zone load balancing on. The target changes from **Unused** to **Healthy**.

With only the new server registered, a CFS sign-in through `https://<rtc-fqdn>` must succeed, and the [Kerberos checks](#step-8-confirm-the-sign-in) must pass. Afterward, register the original server again. Both targets should show **Healthy**.

After that sign-in succeeds, delete both PFX files from both servers.

#### Step 8: Confirm the Sign-in

CFS is configured with `RadiantTrustedConnector.svc/WSFed`, while the completed sign-in appears in the IIS log as `RTCService.svc/WSFed`. These are different steps of the same login.

After the ticket issuance test, close the browser, purge the client cache, and then sign in, in that order. The ticket from `klist get` is still cached, and a later `klist` would show it even if the browser used NTLM. A browser left open can keep the connection it already authenticated; after a purge, that session might not request a new ticket, so `klist` stays empty even though the sign-in worked.

##### Verify the Client Ticket

1. Close the browser, and then run:

   ```
   C:\Windows\System32\klist.exe purge
   ```

2. Sign in to CFS.
3. On the client, run:

   ```
   C:\Windows\System32\klist.exe
   ```

A ticket for `HTTP/<rtc-fqdn>` with a start time that matches the sign-in is the client-side proof. IIS also returns 200 with the domain account for NTLM, so the account name in the log is not enough on its own.

##### Verify the Server Logon Event

On the RTC server that handled the request, a single security log event 4624 must contain all of the following:

- The account is the domain user who signed in.
- **Logon Type** is 3.
- **Authentication Package** is Kerberos.

If that field shows **NTLM**, Negotiate fell back and the SPN setup is still broken.

In the command below, replace `<sign-in-account>` with the account name only, such as `jsmith`. Event 4624 stores this value in **Account Name** under **New Logon**. `CORP\jsmith` does not match, and the resulting empty output then looks like an auditing problem. The command prints the time, the account, and the authentication package.

```
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624; StartTime=(Get-Date).AddMinutes(-15)} |
  Where-Object {
    $_.Message -match 'Logon Type:\s+3' -and
    $_.Message -match 'Authentication Package:\s+Kerberos' -and
    $_.Message -match 'Account Name:\s+<sign-in-account>(\s|$)'
  } |
  ForEach-Object {
    $account = if ($_.Message -match '(?s)New Logon:.*?Account Name:\s+(\S+)') { $Matches[1] } else { "" }
    $package = if ($_.Message -match 'Authentication Package:\s+(\S+)') { $Matches[1] } else { "" }
    "{0}  {1}  {2}" -f $_.TimeCreated, $account, $package
  }
```

An empty result is ambiguous. Confirm that success auditing for logon events is enabled, and then sign in again.

##### Verify the IIS Logs

CFS logs show the redirect to `<rtc-fqdn>`, but not which RTC server handled it. Read the IIS log on each server:

```
$env:COMPUTERNAME
$log = Get-ChildItem C:\inetpub\logs\LogFiles -Recurse -Filter *.log |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1
Select-String -Path $log.FullName -Pattern "RTCService.svc/WSFed" |
  Select-Object -Last 5 | ForEach-Object Line
```

A completed sign-in is a line that contains the domain account, `RTCService.svc/WSFed`, and status `200`, together with the Kerberos ticket and Kerberos logon described above.

Close the browser between attempts, because a single browser session can keep using the same load balancer connection. Each server should show completed sign-ins. To check one server on its own, deregister the other target, sign in once, and then register it again.

>[!note] A single sign-in can involve both servers. RTC begins by requesting a test image from `IntegAccess`, and the token request that follows can be sent on a different connection. Either server can complete that sequence because both share `svc-rtc` and the same signing certificate.

### Verifying the RTC Configuration

Verify that the RTC is configured correctly. Check if you can access the RTC site:

1.  Open the IIS Manager.
2.  Expand the CFS Website application and select the Web Application **rtc**. ![](media/rtc-1.png)
3.  In the right panel, click **browse \*:443 (https)**. ![](media/rtc-2.png)
4.  If there is a Certificate Error warning, select "Continue to this website". ![](media/rtc-3.png)
    
    >[!note] This warning is displayed if you have not yet installed a trusted SSL certificate in IIS. You should replace the default certificate installed by the CFS installer with a new one designated specifically for use by CFS. This certificate should be issued by a Certificate Authority. For instructions on how to change the certificate in IIS, refer to [Adding a Certificate](02-getting-started#adding-a-certificate-to-use-with-an-rtc) to use with an RTC.
    
5.  You should now be at the Radiant Trust Connector site.

![](media/rtc-4.png)

### Adding a Certificate to Use with an RTC

When deploying in a production environment, you should replace the certificate with a certificate issued by a Certificate Authority. This section describes the method for replacing the certificate to use with the RTC.

To add a certificate to use with an RTC:

1.  Open the IIS Manager.
2.  Expand the CFS Website application and select the Web Application **rtc**.
3.  In the list of features, click **Radiant Trust Connector**. ![](media/rtc-5.png)
4.  The default (self-generated) certificate is displayed. ![](media/rtc-6.png)
5.  In the Actions panel, click **Change the certificate**.
6.  Click the browse ("...") button next to the Certificate file (.pfx) field. ![](media/rtc-7.png)
7.  Select a .pfx file and click OK.
8.  Enter the password of your pfx file.
9.  Click OK to close the Change the certificate window.

### Uninstalling an RTC

1.  To uninstall an RTC, go to the Windows Control Panel, select Programs, Uninstall a program. In the list of applications installed, select RadiantOne Trust Connector and click Uninstall.
2.  Click Uninstall. ![](media/rtcuninstall-1.png)
    
3.  Let the setup uninstall the RTC. ![](media/rtcuninstallrtc2.png)
    
4.  The setup has successfuly uninstalled the RTC. ![](media/rtcuninstall-3.png)
    
### Next Steps

Now you have installed and configure RadiantOne RTC, you can follow the guide.

-   Configure the different [Certificates](#certificates).

## Certificates

There are five areas where certificates are involved in the CFS architecture to handle SSL/TLS server security, token signing and verification of SSO. These areas are described below.

Best practices for certificates suggest that you should use a certificate for one, and only one usage (no sharing).

-   At least one for each IIS website endpoint (or use a wildcard certificate) as they are accessed over HTTPS. These certificates must be setup in IIS and the subject of the certificate must be the fully qualified domain name of the endpoint:
-   For example you can have one for CFS: [https://cfs.radiantlogic.com](https://cfs.radiantlogic.com) and you can have one for the RTC on the local domain: [https://rtc.radiantlogic.com](https://rtc.radiantlogic.com). In this case you need two SSL certificate, one for each URL, or a wildcard certificate ( [https://\*.radiantlogic.com](https://*.radiantlogic.com) ) which is a little bit more expensive, but easier to use for more complex scenarios.
-   For applications/relying parties there are two options. For each tenant created in CFS, a certificate is auto-generated. This certificate can be used by all applications configured for the tenant (they would all share this same one). Or you can decide to not use this general default one and have one dedicated certificate for each trusted application/relying party (e.g. SharePoint, Salesforce…etc.). Whether you use the default, shared certificate or apply your own dedicated certificate, CFS uses the full certificate to build the signature of the token. CFS sends the signed token to the application (via a re-direct through the browser) and because the application has the same certificate (but only the public key) it can validate the incoming message has really come from CFS.
-   One for each trusted authentication system/identity provider (e.g. Azure, RSA, ADFS…etc.). CFS needs only the public key certificate because it checks the signature of the token that is sent by the Identity Provider.
-   One for each application RTC (you need one RTC per Active Directory domain/forest). RTC uses the full certificate to build the signature of the token. RTC sends the signed token to CFS (via a re-direct through the client browser) and because CFS has the same certificate (but only the public key) it can validate the incoming message has really come from the RTC.
-   If you are deploying CFS Proxy, the IIS server (where the CFS proxy is installed) has an SSL certificate. Also, the CFS proxy machine must trust the SSL certificates used by all the CFS sites that it is sitting in front of.

>[!note] If you need to load balance multiple CFS servers, you need to have the SSL certificate on every machine plus all the certificates used by CFS must be available and trusted on every machine.

Once you have configured your certificates, you can view them by navigating to **Administration > Dashboard > Certificates** page. The certificates are grouped by:

- Tenant
- Application
- Identity Provider

You can also [enable and manage certificate rollovers](./certificate-rollover.md) using the UI or command line. 

### Applications / Relying Parties

CFS uses a certificate to build the signature of the tokens it generates for applications. CFS sends a signed token to the application (through the browser) and because the application has the same certificate (but only the public key) it can validate the incoming message has come from CFS. There are two options for the certificate that is used by applications:

-   Use the default tenant certificate generated by CFS
-   Use your own dedicated certificate

A mix of both could also be used meaning some applications could use the default while others have a dedicated one. These options are depicted in the diagram below.

![](media/getting-started-certificates-1.png)

By default, CFS generates a unique full certificate for each tenant. This certificate is stored in the FID at: ou=<tenant\_name>,ou=tenants,ou=cfs,cn=config and the certificate contains both the private and public keys. Every application configured for a given tenant can share this same certificate. This is the default behavior. If you choose to use the default certificate generated by CFS, the certificate containing the public key can be retrieved from the Dashboard section -> “Certificates” node in the Tenant Administration Dashboard. This certificate must be installed in all applications that should trust CFS as the identity provider. The installation of the certificate one the application is not handled in the CFS configuration dashboard (see example in screen shot below).

![](media/getting-started-certificates-2.png)

Generally it is best practice to have a dedicated certificate for each application as opposed to sharing one certificate across all applications for a given tenant. In this case, CFS uses the dedicated certificate to build the signature, and when the application receives the token, it can validate that it really came from CFS because it has the corresponding public key. If you choose to use a dedicated certificate for the application, you have two options:

-   Upload a certificate that contains both the private and public keys. This certificate is stored in the FID entry associated with the application located at: ou=<application\_uniqueID>,ou=applications,ou=<tenant\_name>,ou=tenants,ou=cfs,cn=config. This option is less secure than #2 (below) because the whole certificate (containing the private and public keys) must travel between CFS and FID (even though this communication would flow over SSL).
-   Upload a certificate that contains the public key only. This certificate is stored in the FID entry associated with the application located at: ou=<application\_uniqueID>,ou=applications,ou=<tenant\_name>,ou=tenants,ou=cfs,cn=config. This option is more secure than #1 (above) because only the public key is stored in FID. However, if you choose this option, you must also install and trust the full certificate in all CFS instances. This certificate (public and private keys) must be stored in the Windows vault where the CFS in running. This is additional configuration that you must manually setup.

### Authentication Systems

The identity providers (AKA: Authentication Systems) configured in CFS need only the public key configured because CFS checks the signature of the token that is sent by the Identity Provider.

![](media/getting-started-certificates-3.png)

### Radiant Trust Connectors (RTC)

When you install a RTC, because it is installed on IIS Web Server, and because we use https to communicate with the RTC, the installer generates a self-signed certificate and installs it in IIS. This certificate should be replaced with a “legit” CA-issued certificate. This certificate contains the private key. When you request a certificate from a CA, it is important to note that the subject of the certificate should be the FQDN of the machine where the it is used (e.g. s-se14-ad.seradiant.com). To check the certificate used by IIS where the RTC is installed, go into IIS Manager, select the root of IIS and on the right, double-click "Server Certificates" (screen shots below based on Windows Server 2012 OS).

![](media/getting-started-certificates-4.png)

All certificates to be used by the web sites/applications hosted on this IIS should be imported here. In the screen shot below, you can see the default “auto-generated” one from the RTC installer and another one which represents the “valid”/CA-signed one.

![](media/getting-started-certificates-5.png)

Now, to check the one associated with the CFS website/RTC application, click on CFS Website and on the far right, click on Bindings…

![](media/getting-started-certificates-6.png)

Select https, port 443 in the list and click Edit. In the SSL certificate drop-down list, the certificate shown here is the SSL certificate that is used by IIS. Best practice is to indicate the hostname of the machine. See the example shown below.

![](media/getting-started-certificates-7.png)

The RTC also needs a certificate to communicate with CFS (via a re-direct through the client browser). This certificate is generated by the RTC installer (and generally is replaced with a valid “CA-signed” one for production environments). It must contain the private key of the certificate. The public key for this certificate is used when you configure the RTC in CFS. There are two ways to get this certificate:

1.  If you are on the machine where IIS/RTC are installed, from the IIS Manager go to CFS Website and click the RTC application.

    ![](media/getting-started-certificates-8.png)

2. On the right, double-click the Radiant Trust Connector icon. On the far right, click View the Certificate.

    ![](media/getting-started-certificates-9.png)

3. On the Details tab, click Copy to File.

    ![](media/getting-started-certificates-10.png)

4. Go through the “Certificate Export Wizard” and save the file (.cer or .der are fine) somewhere. This file must be copied over to the CFS machine (you need to access it when configuring the RTC in the CFS tenant dashboard). When you configure a RTC (Active Directory option) as an Authentication System in the Tenant Administration Dashboard, you’ll need to provide a certificate for this RTC (the one you copied from the RTC machine). This certificate (public key) is stored in FID.

    ![](media/getting-started-certificates-11.png)

5.  If you are NOT on the machine where IIS/RTC are installed (can’t access IIS Manager), you can just navigate to the RTC URL: e.g. [`https://<domain>/rtc/`](https://<domain>/rtc/) from a web browser and then click the FederationMetadata.xml link.

    ![](media/getting-started-certificates-12.png)

6. Copy the value for the <X509Certificate> and paste it into a text editor (e.g. Notepad).

    ![](media/getting-started-certificates-13.png)

7. Save the file as a certificate (.cer or .der extension). If using a Notepad editor, be sure to enclose the file name in double-quotes to avoid it having a .txt additional extension.

    ![](media/getting-started-certificates-14.png)

8. This file must be copied over to the CFS machine (you need to access it when configuring the RTC in the CFS tenant dashboard). When you configure a RTC (Active Directory option) as an Authentication System in the Tenant Administration Dashboard, you’ll need to provide a certificate for this RTC (the one you saved from the RTC metadata file). This certificate (public key) is stored in FID.


