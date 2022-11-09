# Real-time Persistent Cache Refresh Impact on Global Profile Identities

The following table describes the expected outcome for global profile identities based on events detected on the source.

| Source Event Detected by Connector | Result |
|---|---|
| An entry that is currently correlated/linked in the global profile entry has been updated. | Applicable attributes are updated in the global profile.<br>Correlation rules are not re-evaluated, so the entry will not be unlinked or re-linked (to a new global profile entry). |
| An entry that is currently marked as unresolved has been updated. | If the update results in a correlation, the entry is linked in the global profile and removed from [unresolved](#view-unresolved-identities). |
| An entry that is currently correlated/linked in the global profile has been deleted. | If the entry is linked to other entries in the global profile, the attributes coming from the source the entry was deleted from are removed from the global profile.<br>If there are no other linked entries in the global profile for the user, the entry is deleted from the global profile. |
| An entry that is currently marked as unresolved has been deleted. | The entry is removed from [unresolved](#view-unresolved-identities). |
| A new entry has been added. | Correlation rules are evaluated and the entry is either linked to a matching global profile identity, created as a new identity in the global profile, or marked as [unresolved](#view-unresolved-identities) and not added into the global profile. |
| An entry is moved to a new container that is not below the naming context configured for the identity source, making it out of the scope of the Global Identity Builder project. For example, assume the user `uid=sam,ou=people,dc=domainA` is moved to `uid=sam,ou=globalpeople,dc=domainA` and the identity source definition for the correlation project was configured for `ou=people,dc=domainA`. | If the entry is linked to other entries in the global profile, the attributes coming from the entry identified by the old DN are removed from the global profile.<br>If the entry is in the global profile and not linked to any other entries, it is removed from the global profile and added to [unresolved](#view-unresolved-identities) (represented only by the old DN).<br>If the entry is not in the global profile, it is ignored, since the suffix of the new entry doesn't match what is defined for the identity source in the correlation project. |
| An entry is moved to a new container that is below the naming context configured for the identity source. For example, assume the user `uid=joan,ou=internaluser,dc=domainB` was moved to `uid=joan,ou=externaluser,dc=domainB` and the identity source definition for the correlation project was configured for `dc=domainB`. | If the entry is in the global profile, the `vddn` attribute is updated and the entry is refreshed by fetching the latest values from the identity source.<br>If the entry is not in the global profile, correlation rules are evaluated and the entry is either linked to an existing global profile identity, added as a new identity, or added to [unresolved](#view-unresolved-identities). |
| An entry is moved from a container that was not in scope to a new container that is below the naming context configured for the identity source. For example, assume the user `uid=joan,ou=internaluser,dc=domainA` was moved to `uid=joan,ou=externaluser,dc=domainB` and the identity source definition for the correlation project was configured for `dc=domainB`. | Correlation rules are evaluated and the entry is either linked to an existing global profile identity, added as a new identity, or added to [unresolved](#view-unresolved-identities). |

## Identity Source Logs

A log is generated for each identity source and updated after uploads or when a source event triggers the real-time persistent cache refresh. Logs are located at: `{RLI_HOME}/vds_server/logs/correlation/{NAME_OF_CORRELATION_PROJECT}/{IDENTITY_SOURCE}.csv`

The Status column indicates the action that was performed on each identity. The status values are: new, new(manual), moved, correlated, correlated(manual), already correlated, ignored, or error. Below is a description of each.

- New - Indicates a new identity that is pushed into the global profile.

- New(manual) – Indicates that the entry was manually added as a new identity in the global profile list by an administrator using the Global Identity Builder.

- Moved – This status is not seen during uploads. It is only applicable for events related to real-time persistent cache refresh of the global profile list. For LDAP identity sources, if a capture connector detects a `move` or `modRDN` operation on an entry, the persistent cache refresh connector scans the global profile list and updates the VDDN attribute for the relevant identity, to match the moved entry's new DN/location. The entry DN in the log is the old DN (before the `move`/`modRDN`).

- Correlated – Indicates the entry was able to match an identity in the global profile list.

- Correlated(manual) - Indicates that the entry was manually correlated to an existing identity in the global profile list by an administrator using the Global Identity Builder.

- Already correlated - Indicates that the entry was already in the global profile list, and it was simply refreshed.

- Ignored – Indicates the entry was neither correlated to an existing identity in the global profile list nor created as a new identity in the global profile list. This means that the correlation rules were applied on the identity source entry and:

    - The engine couldn't find an exact match in the global profile list to correlate with (zero matches found or multiple matches found causing ambiguity).

    - The **create new identity** option in the correlation rules wasn't selected, so the engine didn't create a new identity in the global profile list.

    - The identity source entry is sent to the **unresolved** store/list and requires manual intervention to decide what to do with it.

- Error – Indicates there was an error that occurred when correlating an identity. An example of a common error is one indicating that there was a disconnection to the identity data source.

The `entryDn` column is the full DN of the identity source entry that was processed.

The `vuid` column contains the unique identifier for the entry inside the global profile.

The `filter` column indicates the last filter that was evaluated by the correlation engine. If an entry has status **correlated**, this filter is the exact filter that allowed a successful correlation. If it is **N/A** then the entry was already correlated, ignored or an error occurred.

The `ruleNumber` column indicates the correlation rule number that was used to correlate the entry. If it is **N/A** the entry was already correlated, ignored, or error occurred.

The `time` column indicates the exact date/time when the entry was processed.

For details on logs related to the real-time persistent cache refresh components (e.g. connectors, sync engine, agent) please see the RadiantOne Logging and Troubleshooting Guide.
