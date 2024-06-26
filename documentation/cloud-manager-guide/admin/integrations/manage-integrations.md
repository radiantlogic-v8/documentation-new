---
keywords:
title: Manage Integrations
description: Manage integrations
---
# Manage Integrations

External communication channels can be integrated with Environment Operations Center to receive alerts or notifications about changes of state. From the *Integrations* tab in the Admin section, Administrators can add, edit, or delete integrations. This guide outlines the required steps to manage communication channel integrations.

## Getting started

The *Integrations* tab provides an overview of existing integrations and lists the label, integration type, and channel for each integration. 

![image description](images/home.png)

## Configure a new integration

To add a new integration, select **New Integration** which opens the *Integration Setup* dialog. To complete the integration setup, you must provide an integration type and configuration details.

![image description](images/new-int.png)

### Integration type

Select an **Integration Type** from the available channels listed and select **Next** to continue.

![image description](images/type.png)

### Configuration Details

The required configuration details will differ depending on the type of configuration selected. For Slack specifically, the integration name, slack workspace, channel, and your email are required.

Complete the required configuration fields and select **Create** to finish setting up the new integration.

![image description](images/config.png)

If the integration is successfully created, you will receive a confirmation message and the integration will be added to the list of integrations on the *Integrations* tab.

[!info] For the integration to become active, you will need to configure the applicable alerts to send to the channel. See the [alert management](../alert-management/alert-management-overview.md) guide to learn how to set up alerts to send via the integration.

![image description](images/success.png)

## Edit an integration

Each integration listed on the *Integrations* tab has an **Options** (**...**) dropdown menu. From the dropdown, select **Edit** to begin editing the integration.

![image description](images/edit.png)

The workflow to edit an integration is the same as the *New Integration* workflow. You can select a new integration type and add the required configuration details. Or, you can keep the same integration type and proceed to adjust the configuration details.

Select **Create** to update the integration (**confirming with RL if there will be a separate edit integration dialog and a different name for the button**).

![image description](images/edit-config.png)

If the integration successfully updates, you will receive a confirmation message and the details will update on the *Integrations* tab.

![image description](images/edited.png)

## Delete an integration

To delete an integration, select **Delete** from the the **Options** (**...**) menu.

![image description](images/delete.png)

A message will display to confirm that you would like to delete the selected integration. Select **Delete** to delete the integration.

![image description](images/confirm-delete.png)

The integration will be removed from the *Integrations* tab and alerts will no longer be sent to the communication channel.

![image description](images/deleted.png)

## Next steps

You should now have an understanding of the steps to add integrations to receive Env Ops Center alerts in external channels. To learn how to create alerts to send to the configured channels, see the [alert management](../alert-management/alert-management-overview.md) guide.

