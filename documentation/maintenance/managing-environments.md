---
title: Managing Environments
description: Learn the basics of restarting, deleting, and backing up environments.
---

## Overview

For SaaS deployments, use the Environment Operations Center to restart the RadiantOne service, delete environments and the applications running in them, and perform backups.

## Restarting Environments

Restarting environments is performed in the Environment Operations Center. In the EOC navigation pane, select Environments. On the Environments page, select an environment and an application. On the application page, click the Power button. For more details, see: [Starting Environments](/../../eoc/latest/environment-overview/stop-and-start-environment#start-environment)

## Deleting Environments

Deleting environments is performed in the Environment Operations Center. From the Environments home screen, locate the environment you would like to delete from the list of environments. Go the specific environment and on the right top corner, select the ellipsis (...), to expand the options available and select DELETE from the list. For more details, see: [Delete an Environment](/../../eoc/latest/environment-overview/delete-an-environment)

## Performing Backups

Environment backups are performed in the Environment Operations Center. In the EOC navigation pane, select Environments and choose the environment. Click the BACKUPS tab.

For more details, see: [Backups](/../../eoc/latest/environments/backup-and-restore/create-backup)

### Manual

Manually trigger an environment backup from Environment Operations Center.

1. In Environment Operations Center, navigate to Environments > [EnviromentName] > BACKUPS tab.
1. Click **Backup**.
  ![Create a Backup](Media/backup-env.jpg)

1. Enter a backup file name (there is a default auto-prefix) and click **SAVE**. This process takes a few minutes.


### Scheduled

Schedule backups from Environment Operations Center.

1. In Environment Operations Center, navigate to Environments > [EnviromentName] > BACKUPS tab.
2. Scheduled backups can be enabled and configured by clicking the cog icon next to: Sheduled: [enabled/disabled]

![Scheduling Backups](Media/schedule-backups.jpg)
