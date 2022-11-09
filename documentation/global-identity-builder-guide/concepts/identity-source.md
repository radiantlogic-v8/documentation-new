# Identity Source

An identity source is a data source such as Active Directory, Oracle database, Oracle Directory Server, etc. that can contribute identities to the global profile view. Any data source configured in RadiantOne can be an identity source used in the tool. When correlation rules result in a source identity matching exactly one global profile identity, the identities are automatically linked.  If a source identity doesn't match any identities in the global profile, or matches more than one global profile identity, the default behavior is to categorize it as [unresolved](#unresolved-identity) and not add it to the global profile.

>[!important]
>Custom data sources are supported. However, you must first virtualize the identities in RadiantOne and store them in persistent cache. Then, use the persistent cache as the LDAP data source for the project. For details on this process, please see [Integrate and Configure a Custom Data Source](#integrate-and-configure-a-custom-data-source).
