---
title: Architect Guide
description: Architect Guide
---

# Preface

## About this Manual

The focus of this guide is to:

- Introduce the different challenges that the RadiantOne platform addresses.
- Introduce ways to architect the solution while taking into account specific security requirements for authentication and authorization.

This guide is primarily for architects in charge of designing the solution to match the use case at hand. Although this document would be a valuable introduction for a RadiantOne administrator, it does not describe any step-by-step configuration details. This type of information is detailed in the RadiantOne System Administration Guide and Namespace Configuration Guide.

References to other relevant RadiantOne documentation are included throughout this guide.

## Audience

This manual is written with the assumption that the reader is familiar with the following LDAP and relational database terminology and concepts:

- LDAP
- SQL
- General knowledge regarding the structure of a directory information tree (DIT)

## How the Manual is Organized

This guide is broken down into the following chapters:

[RadiantOne Federated Identity Engine (FID)](radiantone-federated-identity-engine.md)
<br>The first chapter of this guide describes the RadiantOne Federated Identity product. In particular, it covers the different layers involved in a directory design and how each work alongside one another.

[Concepts](concepts.md)
<br>This chapter develops the concept of “identity union” in addition to concepts for handling issues such as authentication and authorization when facing an identity aggregation/integration challenge.

[Virtual View Design](virtual-view-design.md)
<br>This chapter focuses on the design considerations and options when building a view for addressing authentication, authorization and security.

[Common Use Cases](common-use-cases.md)
<br>This chapter covers frequently seen usages for the RadiantOne platform.

[Getting Started with RadiantOne](getting-started-with-radiantone.md)
<br>This chapter offers advice for the best ways to get started using RadiantOne. This includes an introduction to the two different Control Panels along with descriptions of which namespace configuration approach to use and what the best tool/wizard is to get you started.

[Performance](high-availability-and-performance.md)
<br>The final chapter focuses on how to use persistent caching to achive performance expectations.

### Technical Support

Technical support can be reached using email or our support website:

E-mail: support@radiantlogic.com

Website: https://support.radiantlogic.com/
