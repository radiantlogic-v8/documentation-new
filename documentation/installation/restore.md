---
title: Restore from an existing Backup
description: Learn how to import existing configurations and data from a backup file to a new installation of the Identity Data Management application.  
---

## Overview

The Identity Data Management Helm chart includes a restore feature that enables users to import existing configurations and data from a backup file to a new installation of the Identity Data Management application.   

This functionality is particularly beneficial for setting up a new Identity Data Management instance with pre-existing configurations or for migrating data from a previous installation to a new installation. 

> Note that you cannot use this feature for upgrades or patches. 

Follow the steps outlined below to restore your self-managed Identity Data Management application. 
 

### 1. Configure your values.yaml file 

To configure the migration feature, include the `migration` object in your `values.yaml` file prior to installation of the application as shown below: 


```yaml 

fid: 

  migration: 

    # Migration file URL to be imported during the first installation (e.g., export.zip) 

    url: <URL_TO_YOUR_BACKUP_FILE> 

``` 

In the `url` property, enter a URL pointing to the backup export file  (`export.zip`). Ensure the URL directs to an HTTP server accessible from the Kubernetes cluster without requiring authentication. 
 
 
### 2. Run the installation command 
 
Once you have made the necessary changes to your values.yaml file, run the install command to deploy the chart: 

 
```bash 
  helm -n self-managed install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.1.2 --values </path/to/your/values.yaml> --debug 
``` 

 

After installation, you can confirm that the migration URL was correctly set by checking the pod's environment variables or init container configuration: 

 

```bash 
 kubectl describe pod fid-0 
``` 

During the installation of the Identity Data Management application, the Helm chart will use the provided URL to download the migration export file. This file will be used to perform a migration import during the installation process. 

 
### Implementation details 

**Init Container** 

An init container named `migration` is included in the FID pod when a migration URL is provided. 
The init container employs `curl` to download the export file from the specified URL, saving it to `/migrations/export.zip` within the container. 

**Volume mounting**

 A volume named `migrations` is created and mounted to both the init container and the main FID container. This setup allows the downloaded migration file to be accessible to the Identity Data Management application during startup. 

**Conditional execution**

 The init container and its associated logic will only execute if a migration URL is specified in the `values.yaml` file. 

**Example configuration:**

```yaml 

fid: 

  migration: 

    url: "<https://mycompany.com/fid-exports/prod-config-export.zip>" 

``` 


### Limitations and considerations 

- This feature is intended solely for new installations of the Identity Data Management application.  Using it during an upgrade will not trigger a new migration. 

- Ensure that the migration URL provided is accessible from the Kubernetes cluster where Identity Data Management is being installed. This should point to an HTTP server that doesn’t have any authentication wall. 

- Ensure that your migration file is a valid export file in ZIP format. 

- Ensure sensitive data in the migration file is adequately secured, and the URL is accessed over a secure connection (HTTPS) when necessary. 


