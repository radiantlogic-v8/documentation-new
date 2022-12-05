---
title: bind-order
description: bind-order
---
         
# Bind Order

The RadiantOne service can send the client bind request (credentials checking) to many identity sources (any that contributed to the global profile identity). After the project is configured, you can define the bind order to indicate the order of identity sources RadiantOne should attempt binds against. For example, if a global profile identity is linked to identities from two different sources, RadiantOne attempts the bind against the source configured first in the bind order. If the bind fails, it tries against the next identity source in the bind order. If the bind fails against all identity sources, the client receives a bind failure error from the RadiantOne service.
