# RadiantOne Identity Data Management

## Version Comparison: v7 vs. v8 vs. v9

*Prepared for administrators planning a deployment or upgrade*

This document summarizes the operational differences between the three supported generations of RadiantOne Identity Data Management (IDDM). The largest divides are the Java runtime, the administration interface, and the underlying deployment architecture: v7 is a monolithic server-based install, while v8 and v9 share a microservices architecture that runs on Kubernetes in both Radiant Logic SaaS and customer-managed data centers.

## Comparison matrix

| Area | IDDM v7 | IDDM v8 | IDDM v9 |
|---|---|---|---|
| **Java runtime** | Amazon Corretto v8 | OpenJDK v8 | OpenJDK v25 |
| **Architecture** | Monolithic, legacy server-based product | Microservices-based | Microservices-based (same stack as v8) |
| **Underlying platform** | Traditional server install on the host OS or VM | Kubernetes | Kubernetes |
| **Deployment model** | Self-managed only, installed by the customer in their desired data center | Radiant Logic SaaS or self-managed in the customer data center — Kubernetes-based either way | Radiant Logic SaaS or self-managed in the customer data center — Kubernetes-based either way |
| **Control Panel (main admin/config interface)** | Classic Control Panel, built on an older technology stack | Newly refactored, modern Control Panel | Same refactored, modern Control Panel as v8, with further Classic Control Panel functions migrated in (\*see *What is new in v9* section below) |
| **Moving to a new version** | V7 to v8 is not recommended, security vulnerabilities will not be addressed once OpenJDK v8 reaches EOL in Nov 2026.<br><br>V7 to v9 is applied as an upgrade. Parallel deployment is used - Export configuration from v7. Install v9 (SaaS or self-managed) and reference the export file during install. After validation, frontend ingress/load balancer can redirect traffic to v9 cluster. | V8 to v9 is applied like a patch. Can be an in-place update, or a parallel deployment where an export of v8 is used during a new install of v9.<br><br>Typically, a parallel deployment is recommended to install v9 to reduce friction and risk. Once v9 has been validated, frontend ingress/load balancer can redirect traffic to v9 cluster. <br> <br> No new features or improvements are supported. | This is the latest version where improvements and new features are supported. |

## What is new in v9

v9 keeps the v8 architecture and Control Panel and layers on the improvements below. Items are grouped by theme; the full itemized list, including issue IDs, is in the v9.0 release notes.

| Theme | What changed in v9 |
|---|---|
| **Runtime and platform currency** | Moves to OpenJDK 25 and Apache Lucene 10, replacing the Java 8 runtime used in v7 and v8. |
| **Control Panel coverage** | Further Classic Control Panel functions now live in the new Control Panel: Custom Banner and Message of the Day, backend connection pooling (Tuning > Limits > Backends), Global Joins, and Usage & Activity under a new Analyze section. JSON attribute editing in Directory Browser now supports updating a record directly from the preview, and new attribute-handling properties are configurable under Tuning. |
| **Connector improvements for Entra ID and Active Directory (AD) backends** | Entra ID backends support batch writes for group member and owner operations with a configurable batch size, and AD DirSync with Fetch Entry now expands ranged attributes (for example `member;range=0-1499`) to the full value before publishing an event, rather than publishing partial data. |
