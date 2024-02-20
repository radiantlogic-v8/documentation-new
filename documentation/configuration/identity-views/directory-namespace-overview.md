---
title: Introduction to Directory Namespace
description: Learn about the meaning of different icons used in the Directory Namespace. 
---

## Icon Overview

Each naming context visible on the Control Panel > SETUP > Directory Namespace > Namespace Design can represent a unique type of configuration. Some nodes represent a direct mapping to an LDAP directory identity source backend. Some represent nodes that are configured as persistent cache. Some nodes represent a combination of many different types of identity sources backends. The following table outlines the icons used and their meaning. This gives you global visibility into how the namespace is constructed without having to click on each node to understand the type.

Icon	| Meaning
-|-
![Plus symbol](Media/root-naming-context.jpg)	| A Root Naming Context.
![Plus symbol](Media/reserved-r1-directory.jpg)	| A Reserved RadiantOne Directory Store.
![Plus symbol](Media/r1-directory-store.jpg)	| A RadiantOne Directory Store.
![Plus symbol](Media/ldap-backend-proxy.jpg)	| An identity view from an LDAP Backend created using a proxy approach.
![Plus symbol](Media/link.jpg)	| An identity view that contains a link to another identity view.
![Plus symbol](Media/virtual-tree.jpg) | An identity view created using a model-driven approach.
![Plus symbol](Media/label.jpg) | A label node in an identity view.
![Plus symbol](Media/container.jpg) | A container node in an identity view.
![Plus symbol](Media/content.jpg) | A content node in an identity view.
![Plus symbol](Media/cache-proxy.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined. Click on this node and navigate to the CACHE tab to see what refresh strategy is configured.
![Plus symbol](Media/ldap-backend-merged.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a merge define to another ldap proxy view.
![Plus symbol](Media/link-no-cache-init.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured but not initialized. This may also represent an identity view that has a link to another view and has a persistent cache defined and initialized but the view is deactivated.
![Plus symbol](Media/link-no-cache-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured but no refresh type has been configured.
![Plus symbol](Media/link-cache-periodic-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured with a periodic refresh type.
![Plus symbol](Media/link-cache-realtime-refresh.jpg) | A node in an identity view that has a link to another view and a persistent cache has been configured with a real-time refresh type configured.
![Plus symbol](Media/cache-virtualtree.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache. Click on this node and navigate to the CACHE tab to see what sublevels are cached and the applicable refresh strategy.
![Plus symbol](Media/label-with-link.jpg) | A label node in an identity view that has child nodes where at least one child node has a backend or view mounted.
![Plus symbol](Media/label-with-link-no-cache-init.jpg) | A label node in an identity view that has child nodes where at least one child node has a backend or view mounted that has been configured for persistent cache, but the cache has not been initialized. This may also represent a configuration where a persistent cache is defined and initialized but the view is deactivated.
![Plus symbol](Media/label-no-cache-init.jpg) | A label node in an identity view that has child nodes, one of which has been configured for persistent cache but not yet initialized. This may also represent a configuration where a persistent cache is defined and initialized but the view is deactivated.
![Plus symbol](Media/label-cache-no-refresh.jpg) | A label node in an identity view that has child nodes, one of which has been configured for persistent cache but no refresh type is configured.
![Plus symbol](Media/label-cache-periodic-refresh.jpg) | A label node in an identity view that has child nodes, one of which has been configured for persistent cache with a periodic refresh type.
![Plus symbol](Media/label-cache-realtime-refresh.jpg) | A label node in an identity view that has child nodes, one of which has been configured for persistent cache with a real-time refresh type.
![Plus symbol](Media/container-link.jpg) | A container node in an identity view that has a link mounted below it.
![Plus symbol](Media/container-link-no-cache-init.jpg) | A container node in an identity view that has a link mounted below it and has been configured for persistent cache but not yet initialized. This may also represent a configuration where a persistent cache is defined and initialized but the view is deactivated.
![Plus symbol](Media/container-cache-no-refresh.jpg) | A container node in an identity view that is configured for persistent cache but no refresh type is configured.
![Plus symbol](Media/container-cache-periodic-refresh.jpg) | A container node in an identity view that is configured for persistent cache with a periodic refresh type.
![Plus symbol](Media/container-cache-realtime-refresh.jpg) | A container node in an identity view that is configured for persistent cache with a real-time refresh type.
![Plus symbol](Media/content-no-cache-init.jpg) | A content node in an identity view that is configured for persistent cache, but not yet initialized. This may also represent a configuration where a persistent cache is defined and initialized but the view is deactivated.
![Plus symbol](Media/content-no-cache-refresh.jpg) | A content node in an identity view that is configured for persistent cache but no refresh type is configured.
![Plus symbol](Media/content-cache-periodic-refresh.jpg) | A content node in an identity view that is configured for persistent cache with a periodic refresh type.
![Plus symbol](Media/content-cache-realtime-refresh.jpg) | A content node in an identity view that is configured for persistent cache with a real-time refresh type.
