---
title: Introduction to Directory Namespace
description: Learn about the meaning of different icons used in the Directory Namespace. 
---

## Icon Overview

Each naming context visible on the Control Panel > SETUP > Directory Namespace > Namespace Design can represent a unique type of configuration. Some nodes represent a direct mapping to an LDAP directory identity source backend. Some represent nodes that are configured as persistent cache. Some nodes represent a combination of many different types of identity sources backends. The following table outlines the icons used and their meaning. This gives you global visibility into how the namespace is constructed without having to click on each node to understand the type.

Icon	| Meaning
-|-
![Plus symbol](media/image72.png)	| `http://localhost:8089/adap/<baseDN>?deletetree=true`
Example URL	| http://localhost:8089/adap/uid=alice,cn=config?deletetree=true
Method	| Delete
Header Name	| Authorization
Header Value	| Basic `<base64 value dn:password>`