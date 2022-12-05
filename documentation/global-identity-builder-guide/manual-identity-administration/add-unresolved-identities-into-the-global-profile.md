---
title: add-unresolved-identities-into-the-global-profile
description: add-unresolved-identities-into-the-global-profile
---
         
# Add Unresolved Identities into the Global Profile

Any [unresolved](#unresolved-identity) identity can be manually added to the global profile as a new entry, or linked to an existing global profile entry from the source identity browser. You can view unresolved identities per identity source. From the main project page, select ![magnifying glass icon](./media/image60.png) next to the identity source.

>[!important]
>Once identities are linked in the global profile, they remain linked forever unless the identity is deleted from a data source or an administrator [manually unlinks](#identity-unlinking) them.

![Identity Source Browser](./media/image61.png)

Identity Source Browser

From the drop-down list, select **Unresolved** to just view the identities that were flagged as unresolved in this source. Choose an unresolved identity and you can manually add the identity into the global profile by selecting **Add to Global Profile** on the **Correlation Status** tab.

![Manually Adding and Unresolved Identity into the Global Profile List](./media/image64.png)

Manually Adding and Unresolved Identity into the Global Profile List

If you want to manually link the identity to an existing global profile identity, select the **Link Manually** tab and enter search criteria to locate the global profile user. The results from the global profile are returned and you can link the source identity to this profile by selecting **Link**.

![Manually Linking a Source Identity to a Global Profile Identity](./media/image66.png)

Manually Linking a Source Identity to a Global Profile Identity

If the unresolved user matches multiple global profile users based on correlation rules, the Rules Matches tab displays which global profile users are a potential match. You can link the source identity to a profile by selecting **Link**.

![Manually Linking a Source Identity to a Global Profile Identity](./media/image67.png)

Manually Linking a Source Identity to a Global Profile Identity
