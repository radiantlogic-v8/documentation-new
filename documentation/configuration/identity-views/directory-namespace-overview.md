---
title: Introduction to Directory Namespace
description: Learn about the meaning of different icons used in the Directory Namespace. 
---

## Icon Overview

Each naming context visible on the Control Panel > SETUP > Directory Namespace > Namespace Design can represent a unique type of configuration. Some nodes represent a direct mapping to an LDAP directory identity source backend. Some represent nodes that are configured as persistent cache. Some nodes represent a combination of many different types of identity sources backends. The following table outlines the icons used and their meaning. This gives you global visibility into how the namespace is constructed without having to click on each node to understand the type.

Icon	| Meaning
-|-
![Plus symbol](../Media/root-naming-context.jpg)	| A Root Naming Context.
![Plus symbol](../Media/reserved-r1-directory.jpg)	| A Reserved RadiantOne Directory Store.
![Plus symbol](../Media/r1-directory-store.jpg)	| A RadiantOne Directory Store.
![Plus symbol](../Media/ldap-backend-proxy.jpg)	| An identity view from an LDAP Backend created using a proxy approach.
![Plus symbol](../Media/link.jpg)	| An identity view that contains a link to another identity view.
![Plus symbol](../Media/virtual-tree.jpg) | An identity view created using a model-driven approach.
![Plus symbol](../Media/label.jpg) | A label node in an identity view.
![Plus symbol](../Media/container.jpg) | A container node in an identity view.
![Plus symbol](../Media/content.jpg) | A content node in an identity view.
![Plus symbol](../Media/ldap-backend-proxy-cache-no-init.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined but not yet initialized. This may also represent an identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined and initialized but the view is deactivated.
![Plus symbol](../Media/ldap-backend-proxy-cache-no-refresh.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined and initialized, but no refresh type has been configured.
![Plus symbol](../Media/ldap-backend-proxy-cache-periodic-refresh.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined and initialized, with a periodic refresh type configured.
![Plus symbol](../Media/ldap-backend-proxy-cache-realtime-refresh.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined and initialized, with a real-time refresh type configured.
![Plus symbol](../Media/ldap-backend-merged.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a merge define to another ldap proxy view.
![Plus symbol](../Media/link-no-cache-init.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured but not initialized. This may also represent an identity view that has a link to another view and has a persistent cache defined and initialized but the view is deactivated.
![Plus symbol](../Media/link-no-cache-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured but no refresh type has been configured.
![Plus symbol](../Media/link-cache-periodic-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured with a periodic refresh type.
![Plus symbol](../Media/link-cache-realtime-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured with a real-time refresh type configured.
![Plus symbol](../Media/virtual-tree-no-cache-init.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache, but not yet initialized.
![Plus symbol](../Media/virtual-tree-no-cache-refresh.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache and initialized, but no refresh type is configured.
![Plus symbol](../Media/virtual-tree-cache-periodic-refresh.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache and initialized, and has been configured with a periodic refresh type.
![Plus symbol](../Media/virtual-tree-cache-realtime-refresh.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache and initialized, and has been configured with a real-time refresh type.
![Plus symbol](../Media/label-with-link.jpg) | need description
![Plus symbol](../Media/label-with-link-no-cache-init.jpg) | need description
![Plus symbol](../Media/label-no-cache-init.jpg) | need description
![Plus symbol](../Media/label-cache-no-refresh.jpg) | need description
![Plus symbol](../Media/label-cache-periodic-refresh.jpg) | need description
![Plus symbol](../Media/label-cache-realtime-refresh.jpg) | need description
![Plus symbol](../Media/container-link.jpg) | need description
![Plus symbol](../Media/container-link-no-cache-init.jpg) | need description
![Plus symbol](../Media/container-cache-no-refresh.jpg) | need description
![Plus symbol](../Media/container-cache-periodic-refresh.jpg) | need description
![Plus symbol](../Media/container-cache-realtime-refresh.jpg) | need description
![Plus symbol](../Media/content-no-cache-init.jpg) | need description
![Plus symbol](../Media/content-no-cache-refresh.jpg) | need description
![Plus symbol](../Media/content-cache-periodic-refresh.jpg) | need description
![Plus symbol](../Media/content-cache-realtime-refresh.jpg) | need description
