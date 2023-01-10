---
keywords:
title: Environments Overview
description: Overview of the Environments home screen user interface
---
# Environments Overview

This guide provides an overview of the *Environments* home screen and its features. To navigate to the *Environments* home screen, select **Environments** in the left navigation.

![image description](images/env-left-nav.png)

The *Environments* home screen provides an overview of all your organization's available environments. Each environment is listed by row, including its name, type, status, and version.

![image description](images/environment-row.png)

A quick start button labeled **New Environment** is available to begin creating a new environment from the home screen. Each environment has its own **Options** menu (**...**) that allows you to perform various operations on the selected environment.

![image description](images/newenv-options.png)

## Environment details

To access further details about an environment, select the environment you wish to view. 

![image description](images/env-name.png)

This brings you to the environment's *Overview* screen, where you can view further information about a given environment, such as node status or connections, and perform monitoring and updating actions.

> **Note:** To learn more about the environment *Overview* features, review the [Environment Details](environments/environment-details/environment-details-ui.md) guide.

![image description](images/env-details-home.png)
  
## Environment type

The environment **Type** indicates whether the environment is configured as a "Production or "Non-production" environment. "Production" environments are for production purposes, and "Non-production" environments are for development and testing.

> **Note:** Only one production environment can be created per Environment Operations Center instance, per region.

![image description](images/env-type.png)

## Environment status

The environment **Status** indicates the current state of the environment. Statuses automatically change as operations are performed on an environment or if any errors have occurred. Environment statuses include:

- Operational: Indicates all FID and Zookeeper nodes are running.
- Warning: There are nodes not running, but the minimum number of nodes required for an environment to operate are running.
- Outage: The minimum number of nodes required for an environment to operate are not running.
- Update failed: An attempt to update the environment failed.
- Creation failed: An attempt to create a new environment failed.
- Import failed: An attempt to import a configuration file failed.
- Updating: The environment is currently updating (this can take up to 1 hour).
- Creating: The environment is currently being created (this can take up to 1 hour).

![image description](images/env-status.png)

## Environment version

**Version** indicates the current version of the environment. The version number is set by the environment administrator during environment setup. If the version number no longer matches the current version of Environment Operations Center **(confirming this behavior with Prashanth)**, an "Update Now" notification is displayed next to the version number prompting you to update the environment. 

To learn more about updating an environment, review the [update an environment](update-an-environment.md) guide.

![image description](images/env-version.png)

## Options Menu

To view a list of operations that can be performed on a given environment, select the ellipsis in the environment row (**...**) to expand the **Options** menu. Options include:

- **View details**: takes you to an environment's *Overview* screen where you can view further details about the environment. To learn more about the environment *Overview*, review the [environment overview guide](../environment-details/environment-details-ui.md).
- **Update**: opens the dialog to begin the update an environment workflow. For more information on updating an environment, review the [update an environment](update-an-environment.md) guide.
- **Import configuration**: opens the dialog to being the workflow to import a configuration file to the environment. To learn more about importing configuration files, review the [import a configuration file](import-configuration-file.md) guide.
- **View logs**: takes you to an environment's *Logs* screen where you can view log files for a given date range. To learn how to review logs, visit the environment details [logs](../environment-details/environment-logs.md) guide.
- **Delete**: opens the dialog to being the workflow to delete an environment. For information on deleting an environment, review the [delete and environment](delete-an-environment.md) guide.

![image description](images/options-expanded.png)

## New environment

The **New Environment** button allows you to quickly start creating a new environment from the home screen. For details on how to create a new environment, review the guide on [creating a new environment](create-an-environment.md).

![image description](images/new-env-button.png)

## Read-only access

Depending on your role, your administrator may set your access permissions to read-only for certain environments. If you have read-only access:

- You will not be able to create new environments and the **New Environment** button will be deactivated.
- Certain environments will be hidden if you have not been assigned either read-only or editing permissions.
- You will not be able to edit or update the environments that you have read-only access to and the **Options** menu (**...**) will no longer be visible next to the environment. You can still view the details for these environments by selecting the environment name to navigate to their respective "Overview" screens.
- An administrator can assign editing permission to you for specific environments. This allows you to edit, update, or delete the environments they have specified, while others remain hidden or read-only.

![image description](images/read-only.png)

## Next Steps

After reading this guide you should have an understanding of how to navigate the *Environments* home screen and its main features. To begin setting up a new environment, review the documentation on [creating a new environment](create-an-environment.md).
