---
keywords:
title: Create a User
description: Learn how to create new users and assign roles in Environment Operations Center. What a user can view and which actions they can perform are dependent on their assigned role. User roles include Tenant Administrator, Environment Administrator, and Environment User
---
# Create a User

This guide outlines the required steps to create new users and assign roles in Environment Operations Center. What a user can view and which actions they can perform are dependent on their assigned role. User roles include Tenant Administrator, Environment Administrator, and Environment User. For details on permissions for each role, see the [role-based permissions](../role-based-permission/role-based-permissions.md) guide.

## Getting started

Select **Admin** from the left navigation to access the *Admin* home screen and *Users* tab.

![image description](images/admin-section.png)

To create a new user, select the **New User** button on the *Users* tab.

![image description](images/create-button.png)

The *New User* form contains all of the required input fields to create a new user. Within the form you will provide the user's details and assign their role and environments. All fields must be completed in both sections to create a new user.

![image description](images/create-user.png)

## User details

In the *User Details* section you must provide the new user's first name, last name, email, activate if you want the user to be a local user, an email for notifications, and set the status to active/inactive in the corresponding fields.
Set the user's status by adjusting the *Status* toggle to "Active".

![image description](images/create-user-details.png)

All the fields in the *User Details* section are required and must be completed to submit the form. If a field is missing information, you will not be able to select the **Save** button. Hovering over the **Save** button will display a reminder that the form must be complete to create the user.

![image description](images/create-save-disabled.png)

Once you have completed the *User Details* section, you can proceed to the *Role* and *Role Details* section to assign the user a role and one or more environments.

## Roles

An user can assume two roles, either a **TENANT ADMIN** or an **ENVIRONMENT CREATOR**. These roles can be enabled/disabled using the toggle buttons

![image description](images/roles.png)

## Role details

In the *Role Details* section you can assign roles and environments to the user. A user can be assigned to more than one role, but can only hold one role per environment. For example, a user may be assigned Tenant Administrator to environments "A" and "B", and also be assigned as an Environment User for environments "C" and "D". The user holds two different roles, but the environment assignments for each role are unique.

See the [role based permission](../role-based-permission/role-based-permissions.md) guide for further details on role definitions and permission details.

To assign the user a role, select the *Role* field to expand the role dropdown. From the list, select the role that is best suited for the user.

![image description](images/create-role.png)

To assign an environment, select the *Environment* field to expand the environment dropdown. From the list of environments, select one or more environments to assign the user to.

![image description](images/create-env.png)

A user can be assigned to multiple environments for their given role. Continue selecting environments from the dropdown list until you have assigned all required environments to the user. Select the arrow (arrow icon) in the *Environment* field to close the dropdown list. (**confirming dropdown multi-selection functionality**).

![image description](images/create-multiple-envs.png)

Once you have completed the *Role* and *Environment* fields, select the checkmark button to set the user's role and environment assignment. For details on assigning multiple roles and special cases concerning role assignments, see the [role based permissions](../role-based-permission/role-based-permissions.md) guide.

![image description](images/create-select-checkmark.png)

To edit the *Role Details* section after you have set the assignment, select the **Options** (**...**) button located next to the user's role and environment assignment. This will expand a dropdown menu listing the options to **Edit** or **Delete** the role and environment assignment.

![image description](images/create-options.png)

Once you have completed the *User Details* and *Role Details* sections, select **Save** to create the new user. They will receive an email notification at the email address associated with their user account confirming their user creation and the link to the EOC.

![image description](images/create-save.png)

To exit out of the *Create User* form without creating a new user, select **Cancel**.

![image description](images/create-cancel.png)

You will receive a confirmation message notifying you that all the current form details will be lost. Select **Confirm** to continue and exit the *Create User* form without saving the current user details.

If you wish to return to the *Create User* form to continue creating the new user, select **Cancel**.

![image description](images/create-confirm-cancel.png)

## Confirmation

After completing the *Create User* form and selecting **Save**, you will be directed to the *Users* tab where you will receive a success message indicating the user has been successfully created and they will appear in the list of users. The new user will receive a confirmation email notification at the specified address containing their new account information and login details.

![image description](images/create-success.png)

If an error occurs and the user is not successfully created, please double check the email address provided for any case sensitivities.
If the error in creating an user still persisits, conatct Radiant logic Support for assistance.


## Next Steps

After reading this guide you should have an understanding of the steps required to create a user in Environment Operations Center. For details on editing an existing user, see the [edit a user](edit-user.md) guide.
