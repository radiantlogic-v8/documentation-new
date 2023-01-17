---
keywords:
title: Schedule Automated Environment Backups
description: How to schedule environment backups
---
# Schedule Automated Environment Backups

This guide provides an overview of the steps required to schedule automated backups for a specific environment. For details on manually creating backups, see the [create a backup](create-backup.md) guide.

## Getting started

From the *Backups* screen, select the **Backup Settings** icon (![image description](images/gear-icon.png)) to navigate to the *Backup Settings* screen.

![image description](images/schedule-select-backupsettings.png)

The *Backup Settings* view contains all of the fields required to create a scheduled backup.

![image description](images/schedule-backupsettings.png)

## Backup settings

To create a scheduled backup, you must complete the sections outlined on the *Backup Settings* screen. This includes, "Data retention policy", "Schedule", and "Destination".

### Data retention policy

The data retention policy specifies when to delete previously created backups. To set the retention period for your scheduled backups, select a time period from the dropdown menu.

Scheduled backups can be stored for 30, 60, or 90 days, or the the maximum retention period of 6 months. 

![image description](images/schedule-retention-dropdown.png)

### Schedule

In the "Schedule" section you will set the frequency of backups. For example, a backup could be created every minute, every hour, every day, once a week, and so on.

The backup frequency is set using Cron Expression. If you are unfamiliar with Cron Expression, hover over the question mark icon (![image description](images/info-icon.png)) to reveal an info box outlining the specifications for Cron Expression and a few examples.

![image description](images/schedule-cronexpression.png)

To set the backup frequency, use the appropriate Cron Expression syntax in the spaces provided to set the frequency for the environment backup to run.

![image description](images/schedule-fields.png)

### Destination

In the "Destination" section, the destination is automatically set to the AWS-S3-Bucket associated with your Environment Operations Center instance.

Once you have completed all required sections, select **Save** to create the scheduled environment backup.

![image description](images/schedule-save-settings.png)

## Confirmation

Once you have saved the environment backup settings, you will return to the *Backups* tab. If the scheduled backup was successfully created you will receive a confirmation message.

Select **Dismiss** to close the confirmation message.

![image description](images/schedule-success.png)

If the scheduled backup could not be created, you will receive an error message indicating that creating the scheduled backup failed.

Select **Dismiss** to close the error message and proceed to try creating the scheduled backup again.

![image description](images/schedule-error.png)

## Next steps

After reading this guide you should have an understanding of the steps required to schedule automated environment backups. To learn how to restore an environment to a previously backed up version, review the guide on [restoring an environment backup](restore-backup.md).
