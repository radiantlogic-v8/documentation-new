---
keywords:
title: Edit a User
description: Edit a user
---
# Edit a User

This guide outlines the steps to edit the details, status, role, and environment assignments for a specific user in Environment Operations Center.

## Getting started

From the *Users* tab in the *Admin* section of Environment Operations Center, there are two ways to begin the workflow to edit a user. You can either select the **Options** (**...**) menu associated with the user or select the user's name to access the *Edit User* screen.

### Edit from options menu

To edit a user from the **Options** (**...**) menu, select **Edit** from the **Options** (**...**) dropdown menu associated with the user.

![image description](images/edit-users-options.png)

This opens the *Edit User* screen where you can update the details and role assignments of a user. 

![image description](images/edit-user-tab.png)

### Edit from user name

To access the *Edit User* screen by directly selecting the user, select the user name from the list of users on the *Admin* *User* tab.

![image description](images/edit-select-username.png)

This brings you to the *Environment Access* tab in a detailed overview of the user. This view lists all the environments and associated roles assigned to the user. From the *Environment Access* tab, select the **Edit User** button to open the *Edit User* screen.

> **(RL QUESTION: Do the other tabs need to be documented as well (VPN, DevSpace, Tokens)??)**

![image description](images/edit-select-edituser.png)

## Update user details

From the *Edit User* screen, you can update a user's first name, last name, and email address in the *User Details* section. Enter the updated information in the associated field provided and select **Save** to update the user's details.

![image description](images/edit-user-details.png)

## Update user status

There are two ways to update the status of a user, either from the **Options** (**...**) menu on the *Admin* *Users* tab or from the *Edit User* screen.

### Update status from options menu

To update a user's status from the *Users* tab, select the **Options** (**...**) menu located next to the user who you would like to deactivate or activate.

![image description](images/edit-option-menu.png)

From the **Options** (**...**) dropdown, select **Deactivate**.

![image description](images/edit-deactivate.png)

You will receive a message requesting confirmation that you would like to deactivate the user. Select **Confirm** to continue and deactivate the user.

![image description](images/edit-deactivate-confirmation.png)

The user's status will change from "Active" to "Inactive"

![image description](images/edit-inactive-status.png)

### Update status from Edit User screen

To update a user's status from the *Edit User* screen, adjust the *Status* toggle in the *User Details* section to the "Active" or "Inactive". Select **Save** to update the user's status.

![image description](images/edit-user-inactive.png)

After selecting save, you will return to the *Users* tab where the user status will update accordingly to the status you selected.

![image description](images/edit-inactive-status.png)

## Update role details

To update the role or environment assignments of a user, from the *Edit User* screen select the **Options** (**...**) menu next to the role and environment pairing to be edited. Select **Edit** from the dropdown to enable editing for the role and environment fields.

![image description](images/edit-roledetails.png)

### Update user role

To update the user role, select the down arrow located in the *Role* field to expand the dropdown menu.

![image description](images/edit-role-arrow.png)

From the list of roles, select the role to assign to the user.

![image description](images/edit-select-role.png)

Select the checkmark icon (check mark icon) to set the new role.

![image description](images/edit-role-checkmark.png)

Select **Save** to update the user role.

![image description](images/edit-save-role.png)

### Update environment assignments

To update environment assignments for a user, select the down arrow located in the *Environment* field to expand the dropdown menu.

![image description](images/edit-env-arrow.png)

To add new environments, select the environments from the dropdown menu. Multiple environments can be assigned to a user for a given role. After you have selected all of the required environment assignments, select the upward arrow in the *Environment* field to close the dropdown.

![image description](images/edit-select-envs.png)

To remove assigned environments, select the **X** located next to the environment name.

![image description](images/edit-delete-envs.png)

Once you have updated the user environment assignments, select the **checkmark** to set the new environment assignments.

![image description](images/edit-env-checkmark.png)

Select **Save** to update the user environment assignments.

![image description](images/edit-save-envs.png)

### Review user roles and environments

You can review the role and environment assignments for a user from the *Environment Access* tab. From the *Users* tab, select the name of a user in order to review the roles and environments assigned to that user.

![image description](images/edit-select-username.png)

The *Environment Access* tab of a user lists the environments they have been assigned to and their role associated with a specific environment. Review this list to ensure all role and environment assignments reflect your updates.

![image description](images/edit-review-details.png)

## Next steps

After reading this guide you should have an understanding of the steps required to edit an existing Environment Operations Center user, including their user details, status, role, and assigned environments. To learn how to delete a user, review the [delete a user](...) guide.
