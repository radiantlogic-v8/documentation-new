---
title: Configure FIPS Mode
description: Learn how to enable FIPS mode in your Self-Managed RadiantOne Identity Data Management deployment.
---

# Configure FIPS Mode

## Overview

The Federal Information Processing Standards (FIPS) are a set of security standards published by the National Institute of Standards and Technology (NIST). FIPS 140-3 defines the security requirements for cryptographic modules used to protect sensitive information. Compliance is validated through the Cryptographic Module Validation Program (CMVP), which certifies cryptographic modules against FIPS 140-3 and related standards.

Many government agencies and regulated industries require applications that process sensitive data (including Personally Identifiable Information, or PII) to use FIPS 140-3 validated cryptographic modules. RadiantOne Identity Data Management includes a [FIPS-validated cryptographic module](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/5127) certified through the NIST CMVP.

This guide describes the FIPS implementation introduced in RadiantOne IDDM 8.5.0 for Self-Managed Kubernetes deployments. FIPS initialization is integrated into the IDDM startup process. When FIPS mode is enabled during installation, the appropriate cryptographic module is automatically configured during container initialization.

> [!note]
> FIPS mode is supported only in **Self-Managed RadiantOne Identity Data Management (IDDM)** deployments.

![IDDM 8.5.0 FIPS deployment flow](./images/dep-flow.png)

## Prerequisites

Before enabling FIPS mode, ensure the following:

- RadiantOne Identity Data Management version **8.5.0** or later.
- FIPS-compatible Helm chart version **1.5.0** or higher.
- A Kubernetes cluster with `kubectl` and `helm` configured for the target namespace.

## Configuration

FIPS behavior is controlled by a single Helm configuration parameter:

```yaml
global:
  fipsMode: DISABLED | ENABLED | PREVALIDATED
```

The available values and their effects are:

| Value         | Description                                                   | Provider JAR                          |
|--------------|---------------------------------------------------------------|---------------------------------------|
| `DISABLED`   | Uses the standard (non-FIPS) cryptographic provider.          | Default provider                      |
| `ENABLED`    | Loads the validated FIPS provider during application startup. | `ccj-4.0.0-fips.jar`                  |
| `PREVALIDATED` | Loads the prevalidation FIPS provider during startup.       | `ccj-4.0.1-prevalidation-fips.jar`    |

Set `global.fipsMode` in your Helm values file (`values.yaml`) to control the FIPS deployment mode.

## Installation

To install IDDM with FIPS support using the FIPS-compatible Helm chart, run:

```bash
helm -n <namespace> install fid \
  oci://registry-1.docker.io/radiantone/iddm-helm \
  --version 1.5.0 \
  --values </path/to/your/values.yaml> \
  --debug
```

Replace `<namespace>` with your target Kubernetes namespace and ensure that `global.fipsMode` is set appropriately in your `values.yaml` file.

## Deployment modes

### DISABLED

Runs IDDM using the default deployment mode without FIPS:

```yaml
global:
  fipsMode: DISABLED
```

In this mode, IDDM uses the standard cryptographic provider.

### ENABLED

Loads the validated FIPS cryptographic provider (`ccj-4.0.0-fips.jar`) during application startup:

```yaml
global:
  fipsMode: ENABLED
```

**Expected log output:**

```text
2026-07-21T14:05:57,330 WARN  com.rli.slapd.server.VDSServer:900 - ### ---
2026-07-21T14:05:57,331 WARN  com.rli.slapd.server.VDSServer:901 - ### Server started! The server is running in FIPS mode with the security module loaded from: /opt/radiantone/vds/lib/fips/ccj-4.0.0-fips.jar
2026-07-21T14:05:57,331 WARN  com.rli.slapd.server.VDSServer:902 - ### ---
```

This message confirms that the validated FIPS provider (`ccj-4.0.0-fips.jar`) was successfully loaded and that the server is running in FIPS mode.

### PREVALIDATED

Loads the prevalidation FIPS cryptographic provider (`ccj-4.0.1-prevalidation-fips.jar`) during startup:

```yaml
global:
  fipsMode: PREVALIDATED
```

**Expected log output:**

```text
2026-07-16T22:59:18,021 WARN  com.rli.slapd.server.VDSServer:901 - ### Server started! The server is running in FIPS mode with the security module loaded from: /opt/radiantone/vds/lib/fips/ccj-4.0.1-prevalidation-fips.jar
2026-07-16T22:59:18,022 WARN  com.rli.slapd.server.VDSServer:902 - ### ---
```

This message identifies the prevalidation cryptographic provider that was loaded and confirms that the server is operating in FIPS mode.

> [!note]
> The FIPS startup message is logged at WARN level to ensure it is visible during deployment validation.

## Verifying FIPS deployment

A successful FIPS deployment can be confirmed by verifying all of the following:

- The Helm values file specifies the correct `global.fipsMode`.
- All deployed IDDM container images use the `-fips` image tag.
- The server startup log reports that the expected FIPS provider was loaded.
- The reported provider matches the configured deployment mode:
    - `ccj-4.0.0-fips.jar` for `ENABLED`
    - `ccj-4.0.1-prevalidation-fips.jar` for `PREVALIDATED`

To confirm that each IDDM container image includes the `-fips` suffix, run:

```bash
kubectl -n <namespace> describe pod <pod-name>
```

or:

```bash
kubectl -n <namespace> get pod <pod-name> -o yaml
```

**Example output:**

![Pod description showing a FIPS-compliant image tag](./images/fips-compliant.png)

Pod names may differ from those shown above, but FIPS-enabled images will include the `-fips` suffix in their image tags.

## Known limitations

The following limitations apply to FIPS-enabled deployments:

- Internal TLS communications between IDDM and ZooKeeper are not supported when FIPS mode is enabled.
- After FIPS mode has been enabled, reverting an existing deployment to non-FIPS mode is not supported.
- FIPS-generated keystores are not automatically converted back to standard keystores. If a deployment is migrated away from FIPS, existing keystores must be recreated manually.
- Configuration Promotion supports Git repositories accessed over HTTPS only. SSH-based Git authentication is not supported when FIPS mode is enabled due to limitations in the FIPS cryptographic provider used for SSH key handling.
