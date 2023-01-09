---
keywords:
title: Backup Overview
description: Overview of environment backups
---
# Backup Overview

You can create and restore backups of your environments in Environment Operations Center. Backups are managed within the detailed view of an environment, under the **Backups** tab. This guide provides an overview of the *Backups* screen and its features.

## Getting started

To navigate to the *Backups* tab for a specific environment, select **Backups** from the top navigation in the environment's detailed view.

![image description](images/backups-tab.png)

This brings you to the *Backups* view that provides a chronological overview of all backups that have been performed on the environment.

![image description](images/backups-home.png)

## Review backups

From the *Backups* tab, you can review all backups that have been performed on the environment. For each backup, the backup name, date and time stamp, and version are listed.

![image description](images/backups-titles.png)

Each backup has an **Options** (**...**) menu that allows you to perform actions on the backup. Actions include **Download**, **Restore**, and **Delete**.

![image description](images/backups-options.png)

If you have set a scheduled backup for the environment, a "Scheduled" notification appears at the top of the workspace indicating the frequency and time of the scheduled backup.

![image description](images/backups-scheduled.png)

## Create backups

You can create backups manually or schedule an automated backup workflow. Select the **Backup Now** button to begin the manual backup workflow.

![image description](images/backup-now.png)

Alternatively, you can select the gear icon (![image description](images/gear-icon.png)) to open the *Backup Settings* and schedule an automated backup workflow.

![image description](images/backups-settings.png)

## Read-only mode

If you have read-only access to the environment, you will still be able to view the list of backups that have been performed and the backup schedule if an automated backup has been created. You will not be able to create new backups or modify existing backups.

The **Backup Now** button will be deactivated, the **Backup Settings** icon will be hidden, and the **Options** menu for each backup wil be hidden.

![image description](images/backups-readonly.png)

## Next steps




