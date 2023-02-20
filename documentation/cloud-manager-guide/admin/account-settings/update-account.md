---
keywords:
title: Account Settings
description: Overview of the Account Settings tab
---
# Account Settings

This guide provides an overview of how to update your account settings and manage your API tokens.

## Getting started

From any section or tab in Environment Operations Center, your account avatar will be visible in the upper right corner of the screen. To access your account settings, select the avatar icon to expand the account dropdown menu. From the dropdown menu, select **Account Settings** to open the *Account Settings* screen.

![image description](images/account-select-settings.png)

## Account settings

From the *Account Settings* screen you can update your user details including your first name, last name, email address associated with the account, and your profile image. 

### Update user details

To update your first name, last name, or email address, enter your information in the spaces provided and select **Save** to update.

![image description](images/account-userdetails.png)

### Update profile image

To update your profile image, select "Edit Avatar"... 

> **(RL QUESTION: does this open a drag and drop screen or just opens the user's local file system to upload, and are there any image size limits**).

![image description](images/account-edit-avatar.png)

## Manage API tokens

> **(RL QUESTION: Define API token purpose/use)**

### Create an API token

To create a new API token, select the **Generate** (![image description](images/icon-generate.png)) button located just above the *API token* input field. This will generate a unique API token that populates in the *API token* input field.

![image description](images/account-select-generate.png)

Set the API token expiration date by selecting a duration from the *Expiration Date* dropdown menu and select **Save** to create the new API token.

![image description](images/account-expiration-dropdown.png)

You will receive a warning when your API token is close to expiring. A warning is displayed in your *Account Settings* next to the *Expiration Date* dropdown.

[!warning] API token expiry cannot be extended. Once a token has expired, a new token must be generated.

![image description](images/account-expiration-warning.png)

> **(RL QUESTION re: expiration details - why the time period matters, why user would select certain dates, etc.)**

### Copy an API token

To copy the API token, select the **Copy to Clipboard** icon (![image description](images/icon-copy.png)) located next to the *API Token* input field and proceed to save or use the token as needed.

![image description](images/account-select-copy.png)

### Delete an API token

Only one API token can be created at a time. If you need to create a new API token but one already exists, you must first delete the current token.

You can delete the API token by selecting the trash bin icon (![image description](images/icon-delete.png)) located next to the *API Token* input field.

[!warning] Deleting an API token is a permanent action and cannot be undone.

![image description](images/account-select-delete.png)

A confirmation message will appear to verify that you would like to delete the API token and reminding you that a new API token will need to be generated for future calls. Select **Confirm** to delete the token.

![image description](images/account-confirm-delete.png)

If the token is successfully deleted you will receive a confirmation message and the *API token* field will be empty.

![image description](images/account-delete-success.png)

You can proceed to generate a new token or exit out of *Account Settings* without generating a new token by selecting **Save**.

## Next steps

After reading this guide you should have an understanding of how to update your account settings and manage your API tokens. For details on managing Environment Operations Center users, see the [create a new user](../user-management/create-user.md) or [edit an existing user](../user-management/edit-user.md) guides.
