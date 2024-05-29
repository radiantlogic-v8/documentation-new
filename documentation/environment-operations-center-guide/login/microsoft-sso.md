## Microsoft SSO

This guide describes the following topics required to configure Microsoft SSO.

- [Registering Your Application in Azure AD](#registering-your-application-in-azure-ad)

- [Creating a Secret for Authentication](#creating-a-secret-for-authentication)

- [Assigning API Permissions](#assigning-api-permissions)

- [Implementation and Testing](#implementation-and-testing)

### Registering Your Application in Azure AD

This section describes how to establish your application as a recognized entity in Azure AD to facilitate secure interactions.

1. Using an administrative account, log into the Azure AD portal.

1. In the navigation pane on the left, select **App registrations**. 

    ![image](images/app-registrations.png)

1. At the top of the page, click **New Registration**.

1. Enter a descriptive name that helps identify the application within your organization. 

    ![](images/register-application.png)

1. In the Supported Account Types section, select one of the following options.

    - **Single Tenant** - limits access to users within the organization.

    - **Multitenant** - allows users from any Azure AD directory to access the application.

1. From the Select A Platform drop-down menu, select **Web**. 

1. Next to the Select A Platform menu, specify a URI to which Azure AD will send authentication responses. 

1. Click **Register**. 

1. Make note of the Application ID for future reference. 

### Creating a Secret for Authentication

This section describes how to generate a secret key that your application uses to authenticate itself with Azure AD. 

1. In the Azure AD portal, navigate to **Manage > Certificates & Secrets**. 

    ![](images/certificates-secrets.png)

1. On the Client Secret tab, click **New Client Secret**. The Add a Client Secret window displays. 

    ![](images/add-client-secret.png)

1. Provide a meaningful description for the secret, i.e. "Production Key 2024". 

1. Select an option from the **Expires** drop-down menu. 


1. Note the value displayed on the Client Secrets tab. 

    ![](images/client-secrets.png)

### Assigning API Permissions

This section describes how to specify which resources your application can access and which actions it can perform in Azure AD.

1. In the Azure AD Portal, navigate to **Manage > API Permissions**.

    ![](images/api-permissions.png)

1. Click **Add a Permission**. 

1. Select an API and click **Delegated Permissions**. 

    ![](images/request-api-permissions.png)

1. Add permissions as needed. 

    >[!warning] These permissions must align with the functionality your application requires. 

1. To apply these permissions across all users in your directory, click **Grant admin consent for [your directory]"**. 

1. Click **Yes**. 

    ![](images/configured-permissions.png)

### Implementation and Testing

The section describes how to integrate and verify that SSO via Azure AD is functioning correctly in your application. 

1. In your application authentication settings, input the Application (Client) ID and the Client Secret. 

1. Configure the authentication library or framework you are using (such as Microsoft's Identity platform libraries) to interact with Azure AD using these credentials.

1. Implement a login feature where users are redirected to Azure AD for authentication.

1. Verify that after successful authentication, Azure AD redirects users back to your application's specified redirect URI.

    >[!note] Your application should handle this response to authenticate the user internally.

1. After implementation, monitor the integration closely for any performance issues or errors.

1. Review logs and user feedback to identify and troubleshoot any potential problems in the SSO process.