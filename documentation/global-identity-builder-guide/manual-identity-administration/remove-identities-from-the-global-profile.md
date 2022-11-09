# Remove Identities from the Global Profile

During the design and configuration of the global profile view (when [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is not running), you may need to remove the entire contents of the global profile or just identities from a specific source. From the configured project, select **Upload/Sync**. In the Bulk Upload section, select **Reset All** to delete all identities from the global profile view. To only remove identities uploaded from a specific data source, select **Reset** next to the identity source in the Single Upload section.

>[!important]
>The reset options should only be used during the initial design and configuration of the global profile. Once deployed and [real-time persistent cache refresh](#persistent-cache-with-real-time-refresh) is running, the reset options generally aren't needed. When you reset a data source, the identities are removed from the global profile. If the identity is the last reference in the global profile (there are no other users linked to it) it is deleted and the unique identifier (VUID) assigned to the identity is removed. In this case, identities that are uploaded again from the same data source are assigned a new value for VUID. If other downstream applications rely on this unique identifier, they are impacted when an identity source is reset because the identifier for the identity changes.

## Identity Unlinking

>[!important]
>Once identities are linked in the global profile, they remain linked forever unless the identity is deleted from a data source or an administrator [manually unlinks](#identity-unlinking) them.

To manually unlink an identity in the global profile, use the global profile identities browser to locate the identity.

On the main project page, select **Identities Browser**.

![Global Profile Identity Browser](./media/image9.png)

Global Profile Identity Browser

Search for and choose the identity to unlink.

A list of data sources the user is from is displayed. Select **Unlink** for the identity you want to remove. The unlinked identity goes into the list of [unresolved](#unresolved-identity).

![Unlinking Global Profile Identities](./media/image59.png)

Unlinking Global Profile Identities

If the user is not linked to any other identities in the global profile, selecting **Unlink** removes them from the global profile and adds them to the list of [unresolved](#unresolved-identity).
