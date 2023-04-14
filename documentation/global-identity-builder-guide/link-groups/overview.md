---
title: Link existing groups to global profile identities
description: Get a quick introduction to the potential need for associating existing groups to users in the view created using the Global Identity Builder tool. Group membership is based on member DN values. The member DN must be converted into the DN used in the Global Identity Builder view to ensure applications that rely on group membership for enforcing authorization retrieve the correct user memberships.
---

# Link existing groups to global profile identities

Many client applications leverage LDAP directories for authentication and a policy information point. These applications rely on group memberships for enforcing authorization and personalization.

This chapter describes how to virtualize existing static groups from backend directories and define the remapping needed so the group member DNs are remapped to the identities in the global profile. The process of creating a global profile of identities is described in the chapters on [concepts](../concepts.md), [project creation](../create-projects/create-project.md), [manual identity administration](../identity-administration.md), and [real-time persistent cache refresh](../manage-persistent-cache/overview.md).

For more information about linking existing groups to global profile identities, please read the section on [creating a root naming context for global profile identities and groups](naming-context.md)
