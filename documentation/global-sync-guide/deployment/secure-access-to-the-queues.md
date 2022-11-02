# Secure Access to the Queues

The Agent and Sync Engine process read and/or write into the queues using the credentials configured in the RadiantOne data source named: vdsha

You can view this data source configuration from Main Control Panel -> Settings -> Server Backend -> LDAP Data Sources.

For security reasons, the user account (Bind DN) you have configured in the vdsha data source should be the only one allowed to access the cn=queue and cn=dlqueue naming contexts.

Configure access controls for these root naming contexts from Main Control Panel -> Settings  
-> Security -> Access Control. Access should only be allowed for the account configured in the vdsha data source. For details on configuring access controls, see the RadiantOne System Administration Guide.
