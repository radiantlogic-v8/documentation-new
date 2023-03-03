---
title: Custom data sources
description: Custom data sources
---

# Custom data sources

A custom data source is one that is not queried via LDAP or JDBC. Examples include Azure AD, Okta Universal Directory and any SCIM-accessible source. Virtual views of these data sources should be configured with persistent cache in RadiantOne prior to using as a source for synchronization. Once cached, the source/capture connector for synchronization is based on HDAP Triggers and is automatically configured in pipelines.
