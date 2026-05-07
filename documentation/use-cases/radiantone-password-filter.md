---
title: RadiantOne Password Filter
description: This document provides implementation details for RadiantOne Password Filter. 
---

## Overview

Password synchronization across multiple systems is challenging because different data sources encrypt and store passwords in different ways. To simplify this, RadiantOne provides a Password Filter that captures password changes on your on-premises Active Directory (AD) domain controllers the moment they occur and securely forwards them to RadiantOne Identity Data Management.

Identity Data Management then propagates the updated password to other connected directories, keeping credentials consistent and secure across your integrated environment.

This guide covers configuring the synchronization pipeline (including LDAP proxies, data sources, and rule-based transformations), installing and registering the Password Filter service on an Active Directory domain controller, and validating end-to-end password synchronization.

> [!note] The Password Filter captures a password only when it is first set or reset for AD users. Existing passwords that have not been changed since the filter was installed are not captured until the next time they are set or reset.

In the scenario covered in this document:

- A password gets set or reset in the source **Active Directory** (AD 1).
- The RadiantOne Password Filter captures the password change detail in **RadiantOne Identity Data Management.**
- RadiantOne updates the user's password in the destination **Active Directory** (AD 2).
- After successful synchronization, the user can log in to both Active Directory environments using the same new password.

> [!note] While this document focuses on syncing passwords between two Active Directories, you can also use this filter to sync passwords between AD and any other LDAP directory target.

## Prerequisites

Before configuring the Password Filter, an administrator should have the following data sources already in place in RadiantOne:

### Environment requirements

1. [SDC Client](../../eoc/latest/secure-data-connector/configure-sdc-service/) v1.2.2 or higher.
2. Windows x64
3. .NET Framework 4.7.2 or higher
4. Ensure that you have access to the Password Filter Service (MSI package) from RadiantOne.
5. There is no option in the MSI installer's UI to configure an HTTP(S) proxy for Identity Data Management. If you need Identity Data Management's outbound requests to go through a proxy server, you must set it up manually after the installation is complete. To do so, edit the `appsettings.json` configuration file under installed location of Password Filter Service and add or modify the `Iddm:Proxy` section as shown below:

```json
{
  "Iddm": {
    "Proxy": {
      "Address": "http://proxy.example.com:8080",
      "Username": "...",
      "Password": "..."
    }
  }
}
```

### SSL Certificate

1. **Add your server's SSL certificate** to the Identity Data Management Certificate Truststore. This allows Radiant One Identity Data Management to establish a trusted LDAPS connection to your AD.

> **Note:** If your AD server's SSL certificate is issued by a well-known public Certificate Authority (CA) that is already included in IDDM's default truststore, you can skip this step as the certificate will be trusted automatically. Import is only required for self-signed certificates or certificates issued by a private/internal CA.

### Data Sources

1. Create a data source that points to your source Active Directory in RadiantOne using SSL.

   **Example:**

   ![Data source connection settings](Media/01-data-source-connection.png)

   | Field | Value |
   |-------|-------|
   | HOST | ec2-54-201-18-118.us-west-2.compute.amazonaws.com |
   | PORT | 636 |
   | SSL | YES |

2. Create an LDAP proxy to connect to your source Active Directory (for example, `o=src`).

   **General Settings Example:**

   ![LDAP proxy general settings](Media/02-ldap-proxy-general.jpg)

   | Field | Value |
   |-------|-------|
   | TYPE | LDAP Backend |
   | NAMING CONTEXT | ou=src |
   | REMOTE BASE DN | OU=activedirectory_hash_pwd,DC=t1,DC=f4,DC=rli |
   | DATA SOURCE | ad_source |
   | HOST | 35.91.133.128 |
   | PORT | 636 |

3. Repeat steps 1 and 2 for the destination source. Create a data source that connects to your destination Active Directory Server using an SSL connection. Then, create an LDAP proxy pointing to Active Directory Server 2 (for example, **o=dst**).

## Initial Sync Pipeline Configuration

1. Create a [synchronization pipeline](https://docs.radiantlogic.com) that syncs the two data sources in RadiantOne classic control panel from `o=src` to `o=dst` using **Rule-Based** mode.

   ![Configure Pipeline – Capture configuration](Media/03-configure-pipeline-capture.jpg)

2. In the Capture Configuration page, click on the Password Filter Configuration feature and select the **Enable Password Filter** option.

   ![Enable Password Filter checkbox](Media/04-enable-password-filter.png)

3. Click on the **Manage Password Filters** setting and click the **Register New Password Filter** option.

4. Enter a name for the filter and click **Register**. A window with additional details about the filter will appear. Copy the values of **ID**, **Token**, and **Target Endpoint** shown in this window as you will need the information for a later step.

   > **Note:** The token is only visible now and will not be accessible once you close this dialog. Please copy and store it securely.

   ![New Password Filter Registration Completed dialog](Media/05-password-filter-registration-completed.png)

   The registration window contains the following fields:

   - **Name** (e.g., `some_name`)
   - **ID** (with COPY button)
   - **Token** (with COPY button)
   - **Target Endpoint** (with COPY button)

## Install the Password Filter Service on Active Directory

Perform these steps on your AD server 1:

1. Launch the installer by running the MSI package.
2. On the Welcome screen, click **Next** to proceed.
3. Choose the install folder (or confirm the default) and click **Next**.
4. On the Service configuration screen, fill in the settings the service will use at runtime:
5. **Target Endpoint**: the RadiantOne endpoint URL the filter will send events to (written as `Iddm:TargetEndpoint` in `appsettings.json`).
6. **Token**: the authentication token used to authorize requests.
7. **ID**: the instance or client identifier that tags requests from this machine (`Iddm:Id`).
8. **Log Level**: the verbosity of the Serilog output, e.g. Information, Debug, or Error (`Serilog:MinimumLevel`).
9. **Log file path**: the full path to the rolling log file written by the Serilog file sink (`path`).
10. Review the summary, click **Install**, then **Finish** when the copy completes. If prompted, reboot the machine so LSASS can load the newly installed password filter DLL.

These values map to the following keys in the generated `appsettings.json` configuration file:

| Dialog Field | appsettings.json Key |
|--------------|----------------------|
| Target Endpoint | Iddm:TargetEndpoint |
| Token | Iddm:Token |
| ID | Iddm:Id |
| Log Level | Serilog:MinimumLevel |
| Log file path | Serilog file sink path |

1. Return to the RadiantOne admin console.
2. Close the **New Password Filter Registration Completed** dialog if open.
3. In the Password Filter list, select the newly registered filter.
4. Click **Save** to persist the changes.

## Pipeline Transformation Configuration

1. Click on the **Transformation** section of the synchronization pipeline. In the Transformation tab, create a rule set with rules for both **Insert** and **Password Update**. Start by creating the Insert rule set. This rule ensures that users added to one Active Directory are also created in another Active Directory.

   It defines how user records are synchronized and is optional for password synchronization. The Password Update rule set, however, is required to ensure password changes are properly synchronized. This is covered in step 4.

   **Rule Set Basic Information:**

   ![Insert rule set – Basic Information](Media/06-insert-rule-set-basic-info.jpg)

   | Field | Value |
   |-------|-------|
   | Rule Set Name | insert_rule_set |
   | Source ObjectClass | user |
   | Target ObjectClass | user |
   | Description | (optional) |

2. Complete all initial details for the insert rule such as the rule name, description and identity linkage.

   ![Insert rule – Basic Information tab](Media/07-insert-rule-basic-info.png)

   | Field | Value |
   |-------|-------|
   | Rule Name | insert_rule |
   | Description | (optional) |
   | Identity Linkage | cn=cn |
   | Require Approvals | (optional) |

   Specify a condition for the insert rule. For example, *"If source event equals inserted entry."*

   ![Insert rule – Conditions tab](Media/08-insert-rule-conditions.png)

   Define the target attribute mappings and any attributes that need to be linked.

   **Example — Target Attribute Mappings (`user_insert_mapping`):**

   ![Target Attribute Mappings for insert rule](Media/09-insert-rule-target-attribute-mappings.png)

   | Target Attribute | Operation Type | Input Values |
   |------------------|----------------|--------------|
   | cn | Replace value(s) | cn |
   | givenName | Replace value(s) | givenName |
   | sAMAccountName | Replace value(s) | sAMAccountName |
   | userAccountControl | Replace value(s) | userAccountControl |

   > ***Note: Do not enable Adaptive mode. Leave adaptive mode disabled.***

3. Save the configured insert rule.

4. Next, create an update rule to synchronize password changes. Note that this step is important as it is the rule that enables password synchronization.

   Provide basic details such as the rule name and description, then set "user" as the value for both `sourceobjectclass` and `targetobjectclass`.

   ![Update rule set (adrule) – Basic Information](Media/10-update-rule-set-basic-info.png)

   | Field | Value |
   |-------|-------|
   | Rule Set Name | adrule |
   | Source ObjectClass | user |
   | Target ObjectClass | user |
   | Description | (optional) |

5. Click on the **Rules** tab and add a new rule (for example: `update_rule`). In the identity linkage field, enter `cn=cn`.

6. Click on the **Conditions** tab and add *"if source event equals updated entry"* condition.

   ![Update rule – Conditions tab](Media/11-update-rule-conditions.png)

7. Navigate to the **Actions** tab and configure the attributes to be synchronized during update operations.

8. Add the `unicodePwd` field to the mappings and, under replace values, select `unicodePwd`. This field is necessary for syncing password updates.

   ![Update rule – Actions tab with unicodePwd mapping](Media/12-update-rule-actions-unicodepwd.png)

   **Actions Settings:**

   | Field | Value |
   |-------|-------|
   | Target Event Type | Update Entry |
   | Use Adaptive Mode | (unchecked) |

   **Target Attribute Mappings (`update mappings`):**

   | Target Attribute | Operation Type | Input Values |
   |------------------|----------------|--------------|
   | unicodePwd | Replace value(s) | unicodePwd |

   > ***Note: Do not enable Adaptive mode. Keep it disabled.***

9. Save the configured update rule.

## How the Password Filter Works During Password Changes

### End-to-End Flow

Once installed and configured:

1. A user on Active Directory 1 changes their password (via Ctrl+Alt+Del, a password reset tool, etc.).
2. The `ChangePasswordFilter_x64` DLL on the domain controller captures the password change and passes it to the RadiantOne Password Filter Windows service (`RadiantOnePasswordFilter`).
3. The service forwards the password to RadiantOne IDDM via the configured Target Endpoint, authenticated with the provided Token and ID.
4. RadiantOne processes the password update through the sync pipeline using the `password_update_rule` rule set (described below).
5. The pipeline writes the new `unicodePwd` value to Active Directory 2.
6. The user can now authenticate using the new password against both the source context (`o=src`) and the destination context (`o=dst`).

## Validating That Password Sync Works

Use the following steps to confirm end-to-end behavior after setup is complete.

1. On AD Server 1, choose a test user. Ensure that the user account is activated.
2. Change the test user's password to a new password in Active Directory 1 (right-click the user → **Reset Password**).

   ![Reset Password context menu in Active Directory](Media/13-reset-password-context-menu.jpg)

3. In RadiantOne, use the **Test Authentication** option to authenticate against the **source context** (`o=src`) using the test user's DN and the new password.

   ![Test Authentication option in the Directory Browser](Media/14-test-authentication-directory-browser.png)

   You should see a message that indicates that the **authentication was successful**.

4. Authenticate the same user in the **destination context** (`o=dst`) using the **same new password**. You should again see **authentication success**. This confirms that the password was synchronized to AD2.
