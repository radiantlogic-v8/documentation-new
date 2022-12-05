---
title: vuid
description: vuid
---
         
# VUID

The VUID attribute is the unique identifier for the identity in the global profile. All unique identities are assigned a VUID value when the entry is added into the global profile and keep this value permanently. All linked/correlated users are assigned the same VUID because they represent the same physical person. The VUID is unique not only in the enterprise, but also across the world. VUID values are not re-used. If an identity is removed from the global profile, and there are no other user accounts linked to the identity, the VUID is deleted and not re-used.

An example of a global profile entry and the correlation process can be found [here](#correlationExample).

>[!important]
>Once identities are linked in the global profile, they remain linked forever unless the identity is deleted from a data source or an administrator [manually unlinks](#identity-unlinking) them.
