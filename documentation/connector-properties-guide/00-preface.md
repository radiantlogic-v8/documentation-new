---
title: 00-preface
description: 00-preface
---
         
# RadiantOne Connector Properties Guide

- [Preface](00-preface.md)
- [Chapter 1 – Overview](01-overview.md)
- [Chapter 2 – Configuring Connector Types and Properties](02-configuring-connector-types-and-properties.md)
- [Chapter 3 – LDAP Connectors](03-ldap-connectors.md)
- [Chapter 4 – Active Directory Connectors](04-active-directory-connectors.md)
- [Chapter 5 – Database Changelog (Triggers) Connector](05-database-changelog-triggers-connector.md)
- [Chapter 6 – Database Timestamp Connector](06-database-timestamp-connector.md)
- [Chapter 7 – Database Counter Connector](07-database-counter-connector.md)

## Preface

### About this Manual

Connectors are components responsible for capturing changes on entries in data sources and are used by the RadiantOne Global Sync module to propagate changes from source systems to one or more targets systems.

Depending on the source data store type (e.g. LDAP directory, Active Directory, RDBMS), different connectors are available. This guide provides information about each connector type and their corresponding configurable properties.

### Audience

This manual is intended for administrators who are responsible for tuning and deploying the RadiantOne Global Sync module. This manual assumes that the reader is familiar with the following:

- SQL Queries

- LDAP Queries

- TCP/IP Connections

- LDAP failover and load balancing

### How the Manual is Organized

[Chapter 1 – Overview](01-overview.md)

This chapter introduces the connectors available in the RadiantOne Global Sync module.

[Chapter 2 – Configuring Connector Types and Properties](02-configuring-connector-types-and-properties.md)

This chapter describes the high-level process of configuring connector types and properties that are used by all connectors.

[Chapter 3 – LDAP Connectors](03-ldap-connectors.md)

Two change detection mechanisms are available for LDAP directories, changelog and persistent search. This chapter describes properties specific to the Changelog Connector and the Persistent Search Connector.

[Chapter 4 – Active Directory Connectors](04-active-directory-connectors.md)

Change detection for Active Directory can be based on the USNChanged attribute or on the DirSync control. There is also a hybrid option that can more efficiently handle failover scenarios. This chapter describes properties for Active Directory connectors.

[Chapter 5 – Database Changelog (Triggers) Connector](05-database-changelog-triggers-connector.md)

This chapter describes properties specific to the Database Changelog (Triggers) Connector.

[Chapter 6 – Database Timestamp Connector](06-database-timestamp-connector.md)

This chapter describes properties specific to the Database Timestamp Connector.

[Chapter 7 – Database Counter Connector](07-database-counter-connector.md)

This chapter describes properties specific to the Database Counter Connector.

### Technical Support

Before contacting Customer Support, please make sure you have the following information:

- Version of RadiantOne

- Type of computer you are using including operating system

- The license number for the software

- A description of your problem including error numbers if appropriate

Technical support can be reached using any of the following options:

- Website: [support.radiantlogic.com](https://support.radiantlogic.com)

- E-mail: <support@radiantlogic.com>

- Fax: 415-798-5765

- Toll-Free Phone Number 1-877-727-6442
