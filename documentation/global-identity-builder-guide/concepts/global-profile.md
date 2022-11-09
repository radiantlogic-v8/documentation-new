# Global Profile

The global profile is a general term to define the final view of correlated identity sources. The global profile view is comprised of a unique list (a union) of identities along with attributes sourced from identity sources or computed in the attribute mappings configured in the Global Identity Builder project.

>[!important]
>The RDN for the global profile entries is a unique identifier that is auto-generated. If you are virtualizing existing groups from backend data sources in FID, you should define a computed attribute for the `member`/`uniquemember` attribute in the groups virtual view that uses the `remapDN` function to lookup in the global profile view to get the list of member DNs. This configuration is described in the chapter[Linking Existing Groups to Global Profile Identities](#link-existing-groups-to-global-profile-identities).
