---
keywords:
title: Getting Started
description: Getting started
---
# Getting Started

This guide provides an overview of the Environment Operations Center *Overview* screen and how to navigate the application user interface.

## Overview

After logging in to the Environment Operations Center, the *Overview* screen appears. This is the Env Ops Center home screen and provides access to Radiant Logic supporting documentation. This screen also provides a high-level overview of your environments. 

A navigation bar is located to the left and is visible from all screens within Environment Operation Center. You can access your account settings by selecting the avatar in the upper right corner, also visible from all screens in the application.

### Documentation

The Radiant Logic documentation suite contains guides and resources to help your work in RadiantOne and Environment Operations Center.

To access supporting documentation from within Environment Operations Center, select **Access Documentation**.

![image description](images/overview-access-docs.png)

### Environments preview

The *Environments* section on the *Overview* screen allows you to quickly preview your available environments and sort the previews by status.

![image description](images/overview-env-preview.png)

Each environment preview contains the environment name, type, status, number of nodes, and version number.

![image description](images/overview-preview-details.png)

The environments displayed differ depending on your assigned role in Environment Operations Center. The Tenant Administrator environment preview displays all of your organization's environments. Environment Administrators and Environment Users will only be able to preview the environments assigned to them.

For further details on role-based permissions, see the [role-based permissions](../admin/role-based-permission/role-based-permissions.md) guide.

#### Filter environments

A status count displays how many environments have a status of "Critical", "Warning", and "Operational".

![image description](images/overview-status-count.png)

To filter the displayed environments by status, select a status card. For example, selecting "Critical" will update the *Environments* section to only display environments with "Outage" statuses.

![image description](images/overview-filter-by-status.png)

If more than two environments are available to view, you can select **Load More** to load additional environment previews.

![image description](images/overview-load-more.png)

#### Manage environments

Each environment preview contains an **Options** (**...**) menu that allows you to access further details about the environment or delete it. Dropdown menu options include:

- View Details: Navigate to the detailed screen of the environment to view additional information.
- View Logs: Navigate to the logs tab for the environment.
- Delete: Begin the workflow to delete the environment.

To learn more about each of these actions, review the [environment details](../environments/environment-details/environment-overview.md) overview, the [logs](../environments/logging/environment-logs.md) guide, or the guide to [delete an environment](../environments/environment-details/delete-environment.md).

![image description](images/overview-options.png)

## Left navigation

The left navigation contains links to various screens, providing access Environment Operation Center features.

![image description](images/overview-left-nav.png)

### Overview

To navigate to the *Overview* screen, select either **Overview** or the Radiant Logic logo.

![image description](images/overview-nav-overview.png)

### Environments

The main *Environments* screen provides an overview of all the environments you have access to. Select **Environments** to navigate to the *Environments* overview.

To learn more about the *Environments* section, see the [environments overview](../environments/environment-overview/environments-overview.md) guide.

![image description](images/overview-nav-env.png)

### Reporting

The *Reporting* section allows you to run and review various reports for your environments. Select **Reporting** to navigate to the *Reporting* screen.

To learn how to create reports, see the [reporting](../reporting/reporting-overview.md) guide.

![image description](images/overview-nav-report.png)

### Monitoring

The *Monitoring* section provides interactive dashboards where you can review the operating status of various server components for each environment. Select **Monitoring** to navigate to the *Monitoring* section of Environment Operations Center.

For details on monitoring server components, see the [monitoring](../monitoring/monitoring-overview.md) guide.

![image description](images/overview-nav-monitor.png)

### Secure data connectors

You can manage connections to on-premise data connectors in the *Secure Data Connectors* section. Select **Secure Data Connectors** to navigate to the *Secure Data Connectors* screen.

For details on managing data connections, see the [secure data connectors](../secure-data-connectors/data-connectors-overview.md) guide.

![image description](images/overview-nav-connectors.png)

### Admin

From the *Admin* section you can perform various administrative actions in Environment Operations Center. Select **Admin** to navigate to the *Admin* home screen.

For further details on operations available in the *Admin* section, see the [admin overview](../admin/admin-overview.md) guide.

![image description](images/overview-nav-admin.png)

## Account settings

A user avatar is always located in the upper right corner of the Env Ops Center user interface. Select the avatar to expand your account dropdown menu. 

![image description](images/overview-account-icon.png)

The dropdown displays your name, email, and permissions associated with the account. From the dropdown menu you can navigate to your **Account Settings**, access the **Help** center, or **Logout** of Env Ops Center.

For information on managing your account settings, see the [account settings](../admin/account-settings/update-account.md) guide.

![image description](images/overview-account-menu.png)

## Next steps

After reading this guide you should have an understanding of the *Overview* screen components and how to navigate the Environment Operations Center user interface. For more information on environments, see the [environments overview](../environments/environment-overview/environments-overview.md) guide. To learn how to create an environment, see the [create an environment](../environments/environment-overview/create-an-environment.md) guide.
