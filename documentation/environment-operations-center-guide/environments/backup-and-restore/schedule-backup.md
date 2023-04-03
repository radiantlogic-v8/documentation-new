---
keywords:
title: Schedule Automated Environment Backups
description: How to schedule environment backups
---
# Schedule Automated Environment Backups

This guide provides an overview of the steps required to schedule automated backups for a specific environment. For details on manually creating backups, see the [create a backup](create-backup.md) guide.

## Getting started

From the *Backups* tab, select the gear icon (![image description](images/gear-icon.png)) to navigate to the *Backup Settings* screen.

![image description](images/backup-button.png)

The *Backup Settings* view contains all of the fields required to create a scheduled backup.

![image description](images/backup-settings.png)

## Backup settings

To create a scheduled backup, you must complete the sections outlined on the *Backup Settings* screen. This includes "Data retention policy" and "Schedule".

### Data retention policy

The data retention policy specifies when to delete previously created backups. To set the retention period for your scheduled backups, select a time period from the dropdown menu.

Scheduled backups can be stored for 30, 60, or 90 days, or the the maximum retention period of 6 months. 

![image description](images/retention-period.png)

### Schedule

In the "Schedule" section you will set the frequency, period, and start time for the scheduled backup to run.

To set the frequency, select the dropdown menu and select a frequency from the list. A backup can be scheduled to run daily, weekly, or monthly.

![image description](images/backup-frequency.png)

To set the backup period, select the dropdown menu and select a number of days from the list. 

![image description](images/backup-period.png)

To set the backup start date, select the dropdown menu and select a week day from the list.

![images description](images/backup-day.png)

To set the backup start time, select the dropdown menu and select a time from the list. Once all fields are complete, select **Save** to create the scheduled backup.

![image description](images/backup-time.png)

## Confirmation

Once you have saved the environment backup settings, you will return to the *Backups* tab. If the scheduled backup was successfully created you will receive a confirmation message. Select **Dismiss** to close the confirmation message.

![image description](images/schedule-success.png)

If the scheduled backup could not be created, you will receive an error message indicating that creating the scheduled backup failed. Select **Dismiss** to close the error message and proceed to try creating the scheduled backup again.

![image description](images/schedule-failed.png)

## Next steps

After reading this guide you should have an understanding of the steps required to schedule automated environment backups. To learn how to restore an environment to a previously backed up version, review the guide on [restoring an environment backup](restore-backup.md).
