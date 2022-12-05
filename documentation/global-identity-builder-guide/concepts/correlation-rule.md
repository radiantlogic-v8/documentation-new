---
title: correlation-rule
description: correlation-rule
---
         
# Correlation Rule

Correlation rules are defined for each identity source and indicate how a source identity can be automatically linked to a global profile identity. When correlation rules result in a source identity matching exactly one global profile identity, the identities are automatically linked and share the same [VUID](#vuid) unique identifier.  If a source identity doesn't match any identities in the global profile, or matches more than one global profile identity, the default behavior is to categorize it as [unresolved](#unresolved-identity) and not add it to the global profile.
