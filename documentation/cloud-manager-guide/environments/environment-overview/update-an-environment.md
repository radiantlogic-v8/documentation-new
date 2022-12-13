---
keywords:
title: Update an Environment
description: Steps to update an existing environment
---
# Update an Environment

When version updates are applied to your Cloud Manager instance, your environments are not automatically updated (**This still needs to be confirmed/there may be other update conditions and requirements**). You can update your environments from the *Environments* home screen or you can update a specific environment from it's *Overview* screen. This guide outlines the steps required to update your environments from the *Environments* home screen. For details on updating an environment from its detailed view, review the environment details guide on [updating an environment](../environment-details/update-environment.md)

> **Note:** Before getting started, make sure you have your current version of of Cloud Manager and the required number of FID nodes to display for each environment that requires updating.

## Managing environment updates

When an environment requires updating, an **Update Now** message appears next to the environment's version number.

![image description](environments/environment-overview/images/update-now-notification.png)

### Begin update

There are two ways to begin the environment update workflow from the home screen, either from the **Options** menu (**...**) or by selecting the **Update Now** message.

To update using the **Options** menu, locate the environment you would like to update and select the corresponding ellipsis (**...**) to display the environment's **Options** menu. From the menu, select **Update** to open the **Update Environment** dialog box.

![image description](environments/environment-overview/images/update-options-menu.png)

Alternatively, you can locate the environment you would like to update and directly select the **Update Now** message located next to the environment's version number. This will also open the **Update Environment** dialog box.

![image description](environments/environment-overview/images/update-select-updatenow.png)

### Update version number and nodes

Once you have started the environment update workflow, a dialog box appears containing the fields required to update the environment version and number of FID nodes. To update your environment, you must provide the correct version number that corresponds with your current version number of Cloud Manager and the number of FID nodes to display.

To update your version number, select the correct number from the **Version** drop down menu. Your currently installed version number is displayed just above the dropdown menu for reference.

![image description](environments/environment-overview/images/update-select-version.png)

To set the number of FID nodes to display for the environment, use the provided slider to increase or decrease the quantity. Alternatively, you can select either the minus (**-**) or plus (**+**) sign on either side of the slider to increase or decrease the number of FID nodes to display.

![image description](environments/environment-overview/images/update-node-slider.png)

Once you have set the correct version number and number of FID nodes, select **Update** to begin updating the environment.

![image description](environments/environment-overview/images/update-env-button.png)

To quit the update and return to the main *Environments* screen, select **Cancel**.

### Environment update confirmation

After selecting **Update** you will return to the main *Environments* screen. The status of the environment being updated will display as "Updating".

![image description](environments/environment-overview/images/update-updating-status.png)

If the environment updates successfully, you will receive a success notification and the environment's status will change to "Operational".

![image description](environments/environment-overview/images/update-successful.png)

If the environment update is unsuccessful, you will receive an error notification and the environment's status will change to "Update Failed".

![image description](environments/environment-overview/images/update-failed.png)

## Next steps

After reading this guide you should have an understanding of the steps required to update an environment, including updating the version number and number of FID nodes to display. To learn how to import a configuration file to an existing environment, review the guide on [importing a configuration file](import-configuration-file.md).
