---
title: Congiguration Promotion
description: Learn how to use promote configuration changes in self-managed Identity Data Management environments.
---


# Configuration Promotion

Radiant Logic's configuration promotion feature enables seamless transfer of configuration changes across different Identity Data Management (IDDM) environments. This is particularly useful for promoting configuration updates from development to QA or production environments.

## Things to know

**Both source and destination environments must have identical versions of Identity Data Management.**

### Supported Configurations:

- Data Sources  
- Database Templates  
- Custom Templates  
- Schemas  
- Naming Contexts  
- Caches  
- Global Sync Pipelines  
- Interception scripts  

### Unsupported Configurations:

- HDAP replication  
- Special attributes  
- ACIs  
- Client certificates  
- Password policies  
- FID server schema  
- Datasource connection or credential information  

**This feature is only supported in:**  
- Helm chart version 1.1.4 and higher.  
- Identity Data Management 8.1.4 and higher.

## Steps to enable Configuration Promotion

1. **Create a Git Repository** in either Github or Gitlab.  
2. For multiple environments, create one Git branch per environment (e.g., create DEV, QA, PROD if you have three Identity Data Management environments). Once you set these branches, avoid other manual modifications to the repository.  
3. Update the `values.yaml` files in each environment to enable exporting changes from one branch to the next in the promotion flow. For example, with three environments, DEV exports to QA, and QA exports to PROD. This configuration supports a smooth, staged rollout of changes from development through to production.  
4. Include the `autoConfigPromotion` object in your `values.yaml` file for source and target environments.

### Example Configuration in DEV Environment

```yaml
autoConfigPromotion: 
  enabled: true 
  persistence: 
    storageClass: standard 
  git: 
    repository: git@github.com:example-org/config-repo.git 
    exportTo: 
      branch: "qa"  # Target branch to export changes to 
    importFrom: 
      branch: ""  # Source branch to import configuration changes from (empty for DEV as we are not exporting anything to DEV branch.) 
    credentials: 
      secretName: “” # Name of the Kubernetes Secret containing GIT_PRIVATE_KEY
```

### Example Configuration in QA Environment

```yaml
autoConfigPromotion: 
  enabled: true 
  persistence: 
    storageClass: standard 
  git: 
    repository: git@github.com:example-org/config-repo.git 
    exportTo: 
      branch: "prod"  # Target branch to export changes to 
    importFrom: 
      branch: "qa"  # Source branch to import configuration changes from 
    credentials: 
      secretName: “” # Name of the Kubernetes Secret containing GIT_PRIVATE_KEY
```
### Example Configuration in PROD Environment

```yaml
autoConfigPromotion: 
  enabled: true 
  persistence: 
    storageClass: standard 
  git: 
    repository: git@github.com:example-org/config-repo.git 
    exportTo: 
      branch: ""  # Target branch to export changes to (empty for PROD) 
    importFrom: 
      branch: "prod"  # Source branch to import configuration changes from 
    credentials: 
      secretName: “” # Kubernetes secret name containing Git credentials.
```

> The storage class must provide a volume that supports full filesystem operations, including symlinks. Pseudo-filesystems such as object stores (e.g., S3) are not compatible. In multi-node, multi-zone environments, ensure the volume is accessible from all nodes across all zones.

This setup assumes that you are promoting configurations from DEV to QA to PROD. Your setup may look different depending on the number of environments.

### Applying Configuration Changes

After modifying the `values.yaml` file, apply the changes by updating the deployment separately for each environment using the following Helm command:

```bash
helm -n self-managed upgrade --install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid \
  --version 1.1.4 --values </path/to/your/values.yaml> --debug
```

## Next Steps

Login to your self-managed Identity Data Management environment(s) and implement configuration changes by following the steps outlined in this document.

