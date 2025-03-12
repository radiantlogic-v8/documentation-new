---
title: Creating backups
description: Learn how to create a backup of your self-managed Identity Data Management.
---

## Overview

This guide provides an overview of the steps required to create backups of your self-managed Identity Data Management deployment. 
 
**To create a backup, follow these steps:**

1. Open your terminal and run the following command: 
 
   ```
    kubectl exec -<RELEASE_NAME>-0 -n <NAMESPACE> -- bash -c "./migrate.sh export <EXPORT_FILE_NAME> 
    ```

   This will generate an export file that contains the backup in your pod. 

       
2. Copy the file from the pod and move it to your local machine by running the following command: 

   ```
    kubectl cp <NAMESPACE>/<RELEASE_NAME>-0:/opt/radiantone/vds/work/<EXPORT_FILE_NAME> /<path-to-your-local-folder>/<EXPORT_FILE_NAME> 
    ```

   Replace <RELEASE_NAME>, <NAMESPACE>, <EXPORT_FILE_NAME>, and <path-	to-your-local-folder> with appropriate values. 

## Next steps

Learn how to [restore](./restore) a new installation using your backup. 

