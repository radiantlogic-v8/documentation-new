---
title: Introduction to Directory Namespace
description: General introduction to namespace design and directory schema. Also learn about the meaning of different icons used in the Directory Namespace. 
---

## Overview
The Directory Namespace and the Directory LDAP Schema are managed from Control Panel > Setup > Directory Namespace.

## Namespace Design
Identity views are created from the Control Panel > Setup > Directory Namespace > Namespace Design section. 

If the applications that are consuming the RadiantOne service are expecting a naming/hierarchy that matches an existing directory structure, the simplest method to creating an identity view is to use an LDAP proxy approach. To do this, create a new naming context and then mount a backend of type LDAP. 

To design an identity view that aggregates multiple data sources, create a new naming context and mount a series of label levels until you achieve the desired hierarchy. Then, mount backends at the needed labels. Once you mount a backend at a label, you cannot mount other backends at the same label level. You must define other label levels in order to mount additional backends. The options available at each level in the identity view are based on how you've defined the parent node. Container and content nodes are defined based on objects in schemas from backends, and Links allow you to mount an existing identity view at the node location. For details see [Creating Identity Views](../identity-views/intro-view-design).

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

### Introduction to the Object Builder

The Object Builder is used to customize how entries associated with a specific object class are joined, how attributes are remapped for specific object classes, defining attributes properties (e.g. updateable, searchable, hidden), and managing computed attributes.

Access the Object Builder from the Control Panel > Directory Namespace > Namespace Design. Select the node below Root Naming Contexts and go to the OBJECT BUILDER tab.

*Canvas* - The main area of the Object Builder is the canvas. This is where objects that will comprise the final RadiantOne entries appear. 

![Canvas](Media/entire-canvas.jpg)

*View* - the view options are: COMPACT (default) and EXPANDED. The compact view doesn't display intermediate join result objects, whereas the expanded view does. You can also track attribute lineage in the expanded view.

The following images depict the difference between compact view (shown first) and expanded view (the same canvas, shown in expanded view).

![Compact View](Media/compact-view.jpg)

![Compact View](Media/expanded-view.jpg)

*Attribute Lineage* - Attribute lineage allows you to visualize how an attribute of the final object makes its way from source objects. Switch to expanded view and then click on an attribute in the final output object. The attribute lineage is highlighted allowing you to track the origin(s).

![Compact View](Media/attribute-lineage.jpg)

To remove the lineage highlighting from the canvas, click the *X*: ![Remove Lineage](Media/remove-lineage.jpg)

*Search Attributes* - The "Search for an attribute" box on the top left allows you to locate an attribue in any object shown on the canvas. The search results are shown in blue text in the objects on the canvas. In the example shown below, the attribute "Gender" is entered and the search results are shown in blue in the objects identified as origin C and the final object output.

![Compact View](Media/search-attribute.jpg)

*Primary Object* - The Primary Object option is only shown for objects from LDAP proxy views. Use this menu to select a primary object from the source view and/or managing primary objects (add or remove) on the canvas.

*Add Component* - The Add Component drop-down allows you add objects to the canvas and add joins.

*Moving Objects on Canvas* - to move the objects around on the canvas, either left-click the mouse on the canvas (NOT on any objects) and move the objects (they move around as a whole image), or you can use the +/-/[] buttons on the bottom left to zoom in/zoom out/fit to the window.

![Resizing Canvas](Media/canvas-adjustment.jpg)

*Node Details* - Click on an object in the canvas to access the Node Details panel. You can delete secondary nodes from here. To remove primary object nodes (only applicable to LDAP proxy views), use: Primary Object > Manage Primary Object

For details on joining objects see: [Joins](/joins.md)

## Directory Schema
Applications can request the directory schema by issuing a search with a base DN of *cn=schema*. The object classes and attributes defined in the schema are managed from the Control Panel > Setup > Directory Namespace > Directory Schema section. 
For details, see [Managing Directory Schema](../directory-stores/managing-directory-schema).
