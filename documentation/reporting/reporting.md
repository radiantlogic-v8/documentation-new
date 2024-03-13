---
title: Reporting
description: Learn about basic reporting capabilities in RadiantOne Identity Data Management
---

## Overview

This is the overview.

## Creating Reports

## Entry Statistics Report

An entry statistics report is a way to guage how many entries are being managed by the RadiantOne Identity Data Management product.
An entry is defined as a unique object (e.g. person, group, device…etc.) referenceable by a distinguished name and managed by the platform.   
For purposes of entry counting, the following definitions are used: 

-  Directory store: a naming context where a RadiantOne Directory Store is mounted. This is any local store used by the platform.
-  Persistent Cached View: a view that has been configured as persistent cache.
-  Layered View - a view that is created from another store/view in the RadiantOne namespace (Directory store, a persistent cache, an LDAP Proxy View or LDAP Model-driven View).
-  LDAP Proxy View - a non-cached view that is created directly from an LDAP backend data source using a “proxy” approach (e.g. reflecting an existing directory backend hierarchy).
-  Model-driven View -  a non-cached view that is created directly from a backend data source (of any type) using a “model-driven” approach that leverages specific types/class of objects, using container/content components. 

The entries stored in Directory Stores or persistent cache, or returned in views, contribute to the total entry count. Note that this is not necessarily equivalent to the total number of entries in the actual data source (backend), as depicted in the diagram below. 

![Identity View Example for Entry Stats](/Media/entry-stat-example.jpg)
