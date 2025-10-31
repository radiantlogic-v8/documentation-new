---
title: Certificate Rollover
description: Steps to rollover zero-downtime certificate updates.
---

## Overview

Certificate rollover enables zero-downtime certificate updates for SAML 2.0 and WS-Federation SSO applications. 
This guide provides simple, step-by-step instructions for implementing certificate rollover.

### Prerequisites

* PowerShell access to CFS management tools
* Tenant and application access permissions
* Certificate files (PFX format) or ability to generate new certificates
* Applications must have UsesCertificateRollover enabled (see Application Setup section below)

## Enable Certificate Rollover

For enabling rollover, the recommended approach is using the Admin UI. However, there are alternative approaches. All options are documented below.

### Method 1: Using Admin UI (Recommended)

1. Navigate to the application in the Admin UI.
2. Look for the certificate section.
3. Click "Enable certificate rollover" button. You should see: "Legacy Mode: This application uses a single certificate.
   Enable certificate rollover for zero-downtime updates."
5. Confirm the change.

### Method 2: Bulk Update Using Script 

This approach is recommended when you need to update multiple application certificates. 

```

# Use the UpdateApplication_CertificateRollover.ps1 script for bulk updates
# This script can update all applications at once to enable certificate rollover
# Example usage with all required parameters:
.\UpdateApplication_CertificateRollover.ps1 `
-Server "server_name" -Port 636 `
-TopDN "ou=applications,ou=tenant,ou=tenants,ou=cfs,cn=config" `
-BindUser "cn=directory manager" -Password "YourPassword" `
-AttrName "UsesCertificateRollover" -BoolValue $true
```

### Method 3: Manual LDAP Update (Advanced)

```
# Set tenant context
Set-CfsCurrentTenant -Name "your-tenant-name"

# Get the application
$app = Get-CfsApplication -Id "your-app-id"
1 / 6
CertificateRolloverSteps.md 2025-10-26
# Enable certificate rollover
$app.UsesCertificateRollover = $true
# Note: There is no direct cmdlet to save this change
# This requires manual LDAP attribute update or UI usage
```

### Method 4: Automatic Enablement

Certificate rollover is automatically enabled when you add certificates using `Add-CfsNextCertificate`. This causes the system to set
`UsesCertificateRollover = true` internally.

## Quick Start with Basic Implementation

Follow these steps to set up certificate rollover for a tenant and its applications.

1. Set Tenant Context

     ```
     # Set the current tenant context
     Set-CfsCurrentTenant -Name "your-tenant-name"
     ```
     <br>
  
2. Check Current Certificate Status

     ```
     # Check tenant-level certificates
     Get-CfsCertificateStatus -Main
     # Check application-level certificates
     Get-CfsCertificateStatus -Application "your-app-id"
     ```
      <br>
  
3. Add Next Certificate

   You can either use an existing certificate or generate a new one. 
  
  **Option A: Use Existing Certificate**
  
  ```
  # For tenant-level certificate
  Add-CfsNextCertificate -Main -Certificate $yourCertificate -ActivationDate (Get-
  Date).AddDays(7)
  
  # For application-level certificate
  Add-CfsNextCertificate -Application "your-app-id" -Certificate $yourCertificate -
  ActivationDate (Get-Date).AddDays(7)
  ```
  <br>


  **Option B: Generate New Certificate**
  
  ```
  # For tenant-level certificate
  Add-CfsNextCertificate -Main -Generate -ActivationDate (Get-Date).AddDays(7)
  # For application-level certificate
  Add-CfsNextCertificate -Application "your-app-id" -Generate -ActivationDate (Get-
  Date).AddDays(7)
  ```
  <br>

4. Verify Implementation

   After adding the certificate, confirm that the certificates are valid.
  
     ```
     # Check certificate status
     Get-CfsCertificateStatus -Main
     Get-CfsCertificateStatus -Application "your-app-id"
     ```


### Emergency Migration for Expiring Certificates

Use the following script for scenarios when your certificates are expiring in less than 30 Days (CRITICAL). 

  ```
  # Set tenant context
  Set-CfsCurrentTenant -Name "your-tenant-name"
  # Emergency migration with new certificate generation
  Start-CfsCertificateEmergencyMigration -Main -GenerateNewCert -Force
  # OR use existing certificate file
  Start-CfsCertificateEmergencyMigration -Main -NewCertPath "path\to\your\cert.pfx"
  -Force
  ```
  <br>

Use the following script for scenarios when your certificates are expiring in 30-90 Days. 

  ```
  # Set tenant context
  Set-CfsCurrentTenant -Name "your-tenant-name"
  # Urgent migration with staged activation
  Start-CfsCertificateEmergencyMigration -Main -DaysUntilExpiry 60 -GenerateNewCert
  ```
  <br>

### Manual Rotation (Optional)

Trigger Certificate Rotation

  ```
  # Set tenant context
  Set-CfsCurrentTenant -Name "your-tenant-name"
  # Manual rotation for tenant
  Start-CfsCertificateRotation -Main
  
  # Manual rotation for application
  Start-CfsCertificateRotation -Application "your-app-id"
  
  # Force rotation (bypass activation date checks)
  Start-CfsCertificateRotation -Main -Force
  ```
  <br>

## Common Workflows 

**For New Tenant Setup**

1. Set tenant context: `Set-CfsCurrentTenant -Name "tenant-name"`
2. Generate tenant certificate: `Add-CfsNextCertificate -Main -Generate`
3. Verify certificate status: `Get-CfsCertificateStatus -Main`

**For Application Certificate Rollover**

1. Set tenant context: `Set-CfsCurrentTenant -Name "tenant-name"`
2. Add application certificate: `Add-CfsNextCertificate -Application "app-id" -Generate`
3. Verify certificate status: `Get-CfsCertificateStatus -Application "app-id"`

**For Emergency Certificate Replacement**

1. Set tenant context: `Set-CfsCurrentTenant -Name "tenant-name"`
2. Emergency migration: `Start-CfsCertificateEmergencyMigration -Main -GenerateNewCert -Force`
3. Verify certificate status: `Get-CfsCertificateStatus -Main`

### Troubleshooting

1. Check Certificate Status

  ```
  # Always start by checking current status
  Get-CfsCertificateStatus -Main
  Get-CfsCertificateStatus -Application "app-id"
  ```
  <br>

2. Handling Common Issues

1. If no certificates are found, use `Add-CfsNextCertificate` to add certificates.
2. If rotation does not work, check activation dates (note that using -Force parameter will not have any effect as it is not implemented).

  Example:
  
  ```
  # IMPORTANT: -Force parameter is defined but NOT IMPLEMENTED in any certificate
  cmdlets
  # These commands will work but -Force has ZERO effect:
  Start-CfsCertificateRotation -Main -Force
  Start-CfsCertificateEmergencyMigration -Main -GenerateNewCert -Force
  # The -Force parameter is completely ignored in the implementation
  ```
  <br>
  
3. If you get other certificate errors, verify certificate validity and permissions. 


### Key Points to Remember

1. Enable certificate rollover first using Admin UI or Add-CfsNextCertificate. 
2. Always set tenant context first using `Set-CfsCurrentTenant -Name "tenant-name"`.
3. Use the Correct Scope Parameter:
- Use `-Main` for tenant-level operations when managing tenant certificates.  
- Use `-Application "app-id"` for application-level operations when managing application certificates.
5. Check the status of the certificate after running a script using `Get-CfsCertificateStatus`.
6. Emergency migration must be automatic as the system need to handle urgent situations automatically. 

### Parameter Reference

#### Add-CfsNextCertificate

| Parameter | Description |
|-----------|-------------|
| `-Main` | For tenant-level certificates |
| `-Application` | For application-level certificates |
| `-Certificate` | Use an existing certificate |
| `-Generate` | Generate a new certificate |
| `-ActivationDate` | When to activate the certificate (default: 7 days) |

#### Get-CfsCertificateStatus

| Parameter | Description |
|-----------|-------------|
| `-Main` | Check tenant certificates |
| `-Application` | Check application certificates |

#### Start-CfsCertificateRotation

| Parameter | Description |
|-----------|-------------|
| `-Main` | Rotate tenant certificates |
| `-Application` | Rotate application certificates |
| `-Force` | NOT IMPLEMENTED – parameter exists but is completely ignored |

#### Start-CfsCertificateEmergencyMigration

| Parameter | Description |
|-----------|-------------|
| `-Main` | Migrate tenant certificates |
| `-Application` | Migrate application certificates |
| `-GenerateNewCert` | Generate a new certificate |
| `-NewCertPath` | Use an existing certificate file |
| `-Force` | NOT IMPLEMENTED – parameter exists but is completely ignored |
