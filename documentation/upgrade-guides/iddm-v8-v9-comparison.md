# RadiantOne Identity Data Management

## Version Comparison: v8 vs. v9

*Prepared for administrators planning a deployment or upgrade*

This document summarizes the operational differences between v8 and v9 of RadiantOne Identity Data Management (IDDM). 

## Comparison matrix

| Area | IDDM v8 | IDDM v9 |
|---|---|---|
| **Java runtime** | OpenJDK v8 | OpenJDK v25 |
| **Supports TLS 1.3 and modern cipher suites: the KEM API, and the first post-quantum algorithms (ML-KEM/ML-DSA)** | No | Yes |
| **Architecture** | Microservices-based | Microservices-based (same stack as v8) |
| **Underlying platform** | Kubernetes | Kubernetes |
| **Deployment model** | Radiant Logic SaaS or self-managed in the customer data center — Kubernetes-based either way | Radiant Logic SaaS or self-managed in the customer data center — Kubernetes-based either way |
| **Control Panel (main admin/config interface)** | Newly refactored, modern Control Panel | Same refactored, modern Control Panel as v8, with further Classic Control Panel functions migrated in (\*see *What is new in v9* section below) |
| **Moving to a new version** | V8 to v9 is applied like a patch. Can be an in-place update, or a parallel deployment where an export of v8 is used during a new install of v9.<br><br>Typically, a parallel deployment is recommended to install v9 to reduce friction and risk. Once v9 has been validated, frontend ingress/load balancer can redirect traffic to v9 cluster. <br> <br> No new features or improvements are supported. | This is the latest version where improvements and new features are supported. |

## What is new in v9

v9 keeps the v8 architecture and Control Panel and layers on the improvements below. Items are grouped by theme; the full itemized list, including issue IDs, is in the v9.0 release notes.

| Theme | What changed in v9 |
|---|---|
| **Runtime and platform currency** | Moves to OpenJDK 25 and Apache Lucene 10, replacing the Java 8 runtime used in v8. |
| **Control Panel coverage** | Further Classic Control Panel functions now live in the new Control Panel: Custom Banner and Message of the Day, backend connection pooling (Tuning > Limits > Backends), Global Joins, and Usage & Activity under a new Analyze section. JSON attribute editing in Directory Browser now supports updating a record directly from the preview, and new attribute-handling properties are configurable under Tuning. |
| **Connector improvements for Entra ID and Active Directory (AD) backends** | Entra ID backends support batch writes for group member and owner operations with a configurable batch size, and AD DirSync with Fetch Entry now expands ranged attributes (for example `member;range=0-1499`) to the full value before publishing an event, rather than publishing partial data. |
