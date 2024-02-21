---
title: Introduction to Directory Namespace
description: Learn about the meaning of different icons used in the Directory Namespace. 
---

## Overview
The Directory Namespace and the Directory LDAP Schema are managed from Control Panel > Setup > Directory Namespace.

## Namespace Design
Identity views are created from the Control Panel > Setup > Directory Namespace > Namespace Design section. 

If the applications that are consuming the RadiantOne service are expecting a naming/hierarchy that matches an existing directory structure, the simplest method to creating an identity view is to use an LDAP proxy approach. To do this, create a new naming context and then mount a backend of type LDAP. 

To design an identity view that aggregates multiple data sources, create a new naming context and mount a series of label levels until you achieve the desired hierarchy. Then, mount backends at the needed labels. Once you mount a backend at a label, you cannot mount other backends at the same label level. You must define other label levels in order to mount additional backends. The options available at each level in the identity view are based on how you've defined the parent node.

![Directory Namespace Mounting Options](./Media/dir-namespace-mounting.jpg)

### Icon Overview

Each naming context visible on the Control Panel > Setup > Directory Namespace > Namespace Design can represent a unique type of configuration. Some nodes represent a direct mapping to an LDAP directory identity source backend. Some represent nodes that are configured as persistent cache. Some nodes represent a combination of many different types of identity sources backends. The following table outlines the icons used and their meaning. This gives you global visibility into how the namespace is constructed without having to click on each node to understand the type.

Icon	| Meaning
-|-
![All Root Naming Contexts](Media/root-naming-context.jpg)	| Very top configuration node in the Directory Namespace. All Root Naming Contexts appear below this.
![Reserved RadiantOne Directory Store](Media/reserved-r1-directory.jpg)	| A Reserved RadiantOne Directory Store.
![RadiantOne Directory Store](Media/r1-directory-store.jpg)	| A RadiantOne Directory Store.
![LDAP Proxy View](Media/ldap-backend-proxy.jpg)	| An identity view from an LDAP Backend created using a proxy approach.
![Link](Media/link.jpg)	| An identity view that contains a link to another identity view.
![Model Driven View](Media/virtual-tree.jpg) | An identity view created using a model-driven approach.
![Label Node](Media/label.jpg) | A label node in an identity view.
![Container Node](Media/container.jpg) | A container node in an identity view.
![Content Node](Media/content.jpg) | A content node in an identity view.
![Cached LDAP Proxy View](Media/cache-proxy.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a persistent cache defined. Click on this node and navigate to the CACHE tab to see what refresh strategy is configured.
![Merged LDAP Proxy View](Media/ldap-backend-merged.jpg) | An identity view from an LDAP Backend created using a proxy approach that has a merge defined to another ldap proxy view.
![Cached Virtual Tree](Media/cache-virtualtree.jpg) | An identity view created using a model-driven approach that has been configured for persistent cache. Click on this node and navigate to the CACHE tab to see what sublevels are cached and the applicable refresh strategy.
![Label with Link Below](Media/label-with-link.jpg) | A label node in an identity view that has child nodes where at least one child node has a backend or view mounted.
![Container with Link Below](Media/container-link.jpg) | A container node in an identity view that has a link mounted below it.

## Directory Schema
