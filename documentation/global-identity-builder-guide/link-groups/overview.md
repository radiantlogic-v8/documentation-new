---
title: Link existing groups to global profile identities
description: Link existing groups to global profile identities
---

# Link existing groups to global profile identities

Many client applications leverage LDAP directories for authentication and a policy information point. These applications rely on group memberships for enforcing authorization and personalization.

This chapter describes how to virtualize existing static groups from backend directories and define the remapping needed so the group member DNs are remapped to the identities in the global profile. The process of creating a global profile of identities is described in the chapters on [concepts](../concepts.md), [project creation](../create-projects/create-project.md), [manual identity administration](../identity-administration.md), and [real-time persistent cache refresh](../manage-persistent-cache/overview.md).

For more information about linking existing groups to global profile identities, please read the section on [creating a root naming context for global profile identities and groups](naming-context.md)
