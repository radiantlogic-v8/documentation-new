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
<br>The first chapter of this guide describes the main RadiantOne module, the Federated Identity Engine, along with a logical architecture of the product. In particular, it covers the different layers involved in a directory design and how each work alongside one another.

[Concepts](concepts.md)
<br>This chapter develops the concept of “identity union” in addition to concepts for handling issues such as authentication and authorization when facing an identity aggregation/integration challenge.

[Virtual View Design](virtual-view-design.md)
<br>This chapter focuses on the design considerations and options when building a view for addressing authentication, authorization and security.

[Common Use Cases](common-use-cases.md)
<br>This chapter covers frequently seen usages for the RadiantOne platform.

[Getting Started with RadiantOne](getting-started-with-radiantone.md)
<br>This chapter offers advice for the best ways to get started using RadiantOne. This includes an introduction to the two different Control Panels along with descriptions of which namespace configuration approach to use and what the best tool/wizard is to get you started.

[High Availability and Performance](high-availability-and-performance.md)
<br>The final chapter focuses on how to design a highly available, fault tolerant architecture that meets required performance expectations.

### Technical Support

Before contacting Customer Support, please make sure you have the following information:

- Version of RadiantOne
- Type of computer you are using including operating system.
- The license number for your software.
- A description of your problem including error numbers if appropriate

Technical support can be reached using any of the following options:

E-mail: support@radiantlogic.com

Website: https://support.radiantlogic.com/

Phone: 415 - 209 - 6800

Toll-Free Phone: 1-877-727-6442

Fax: 415-798-5697