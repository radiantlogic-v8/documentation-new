---
keywords:
title: Admin Overview
description: Overview of the Admin home screen user interface
---
# Admin Overview

This guide provides an overview of the *Admin* home screen and its features. From the *Admin* screen, you can access tabs to manage your account settings, Environment Operation Center users, environment alerts and integrations, and monitor cluster health.

All Env Ops Center users can access the **Admin** screen, but view and edit permissions will differ depending on a user's assigned role. For details on role-based permissions, see the [role-based permissions](role-based-permission/role-based-permissions.md) guide.

## Getting started

To navigate to the *Admin* screen, select **Admin** (![image description](images/icon-admin.png)) located at the bottom of the left navigation.

![image description](images/overview-select-admin.png)

## Top navigation

A navigation bar is located at the top of the *Admin* home screen and is visible from all tabs in the *Admin* view. The top navigation allows you to access several account and user management tools through the following tabs:

- Users
- Alerts
- Clusters
- Authentication
- Integrations
- Backups

![image description](images/overview-top-navigation.png)

### Users

The *Users* tab allows you to manage all users within your Environment Operation Center instance. From here you can view a user's name, email address, and status.

For details on managing Environment Operation Center users, including their roles and permissions, see the [user management](...) guide.

![image description](images/overview-user-tab.png)

### Alerts

From the *Alerts* tab you can monitor and create alerts for your environments. The main *Alerts* screen displays all of your current alerts including their notification channel, a time and date stamp of the last update to the alert, and the severity status.

For more information on alert management, see the [alert management](...) guide.

![image description](images/overview-alerts-tab.png)

### Clusters

The *Clusters* tab allows you to monitor cluster health. The *Clusters* screen displays your cluster, the region of that cluster, its number of nodes, Kubernetes version, and current status.

For details on monitoring clusters, see the guide on [cluster monitoring](...).

![image description](images/overview-clusters-tab.png)

### Authentication

The *Authentication* tab allows you to manage Environment Operation Center authentication methods. From the main *Authentication* screen you can view current authentication providers, the provider type, and the status of the authentication method.

For details on managing authentication providers, see the [authentication](...) guide.

![image description](images/overview-auth-tab.png)

### Integrations

From the *Integrations* tab you can manage your connections to external applications to send alerts from Environment Operations Center. The *Integrations* tab displays the integration "Label", indicating the integrations purpose, the "Integration", indicating the external application, and the "Channel" that is used within the external application integration.

For details on managing integrations, see the [managing integrations](integrations/manage-integrations.md) guide.

![image description](images/overview-integration-tab.png)

### Backups

The admin *Backups* tab provides similar functionality as an environment's *Backups* tab. You cannot create or scheduled environment backups from the admin section, but you can delete or restore backups. From the admin *Backups* tab you can also recover deleted backups, which you cannot do from an environment's *Backups* tab. 

For details on managing environment backups see the [environment backup](../environments/backup-and-restore/backup-restore-overview.md) guide. To learn how to recover a deleted backup, see the [recover a backup](backups/recover-backups.md) guide.

![image description](images/overview-backups-tab.png)

## Next steps

After reading this guide you should be able to navigate the *Admin* home screen and understand its main features including the top navigation. For details on updating your account settings, review the [account settings](account-settings/update-account.md) guide. To learn how to create a new user, review the [create a new user](user-management/create-user.md) guide.
