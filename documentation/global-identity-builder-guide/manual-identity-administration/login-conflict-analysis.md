---
title: login-conflict-analysis
description: login-conflict-analysis
---
         
# Login Conflict Analysis

A login attribute is one that an application uses to uniquely identify a user that needs to be authenticated. Therefore, the attributes configured as login attributes for the project should be populated and unique across all identities in the global profile view. If a login attribute does not have a value and/or the value is duplicated across multiple global profile identities, those identities are flagged as Login Conflict.

To view all identities with a login conflict, go to the Main Project configuration and select **Edit** > **Login Analysis**. If you disabled the **Automatic Logic Attribute Analysis** in the project properties, you must run the **Login Analysis** from here.

![Login Analysis](./media/image68.png)

Login Analysis

In the example below, a user (`Levi Lee`) in the global profile, has a login conflict (`mail` has been designated as the login attribute) with another global profile entry (`Larry Lee`).

![Example of a Global Profile User with Login Conflict – Duplicate Value](./media/image69.png)

Example of a Global Profile User with Login Conflict – Duplicate Value

As another example, a user (`Harrison Barnes`) in the global profile, has a login conflict (`mail` has been designated as the login attribute) because he has no value for his email address.

![Example of a Global Profile User with Login Conflict – Empty Value](./media/image70.png)

Example of a Global Profile User with Login Conflict – Empty Value

Possible ways to resolve a conflicted identity are:

1. Verify that the Global Profile entry has been correlated properly. If it hasn't, fix your correlation rules, [reset](#remove-identities-from-the-global-profile) and re-upload the identity sources. If correlation logic is insufficient, you can always [manually link](#manual-identity-administration) identities.

>[!important]
>This approach should only be done when [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is not running. When you reset a data source, the identities are removed from the global profile. If the identity is the last reference in the global profile (there are no other users linked to it) it is deleted and the unique identifier (VUID) assigned to the identity is removed. In this case, identities that are uploaded again from the same data source are assigned a new global identifier.

2. Change the attribute mappings that populates the login attribute from one (or more) of the identity sources. Then re-upload the identity sources.  

>[!note]
>This approach should only be done if when [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is not running.

3. Change the data in the identity source so the login attribute pushed to the global profile has a unique value.

>[!note]
>If the [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is running, the connectors should detect and propagate the change to the global profile. If real-time persistent cache refresh is not running, re-upload this source to the global profile.

## Launch Login Analysis

The attribute(s) designated as the Login Attribute(s) in the project configuration is analyzed during uploads. When the [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) process is running, the login analysis is performed for every insert, update and delete operation that is applied to the global profile.

![Login Attribute Configuration](./media/image71.png)

Login Attribute Configuration

During the design phase of your project (while [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is not running), if you have already uploaded identities into the global profile and decide to change the login attribute (to some other attribute already existing in the global profile), you can re-launch the login analysis without having to re-upload the data. To manually launch the login analysis, go to the Main Project configuration and select **Configure** > **Login Analysis**.

>[!important]
>If the new login attribute does not exist in the global profile, you must re-upload the data. In this case, the login analysis is launched automatically so there is no need to manually trigger it.
