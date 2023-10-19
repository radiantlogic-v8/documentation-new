---
title: Migration Utility
description: Migration Utility
---

If a migration plan has been generated, the export command uses it to determine what configuration should be included in the export. If a migration plan has not been generated, the migration utility exports the configuration dictated by its default behavior.

The following export example assumes the migration utility has been unzipped at C:\MigrationUtility\radiantone-migration-tool-2.1.0 on the Windows machine containing the RadiantOne configuration to be exported, and the file containing the export is C:/tmp/export.zip.

C:\MigrationUtility\radiantone-migration-tool-2.1.0\migrate.bat export C:/tmp/export.zip

>[!warning] If you do not have an RLI_HOME environment variable defined, you must pass the location where RadiantOne is installed in the command.

## Customizing a Migration Plan

To have more control over what gets migrated, you can generate a migration plan which can be customized before doing the export. The example below creates a migration plan.

C:\MigrationUtility\radiantone-migration-tool-2.1.0\migrate.bat generate-migration-plan

>[!warning] If you do not have an RLI_HOME environment variable defined, you must pass the location where RadiantOne is installed in the command.

The command generates migration_plan.json in the location where you executed the script. Using the example above, the migration plan would be located here: C:\MigrationUtility\radiantone-migration-tool-2.1.0\migration_plan.json 

The .json file contains the naming contexts (this is only the definition of the naming contexts, not the dependencies – orx files, dvx files, data sources), RadiantOne Universal Directory (HDAP) stores (only the actual data, not the naming context), data sources, schema files (.orx), and virtual view files (.dvx) that are possible to export. You can edit the .json file and use the keyword MIGRATE next to the items you want to be included in the export, and the keyword KEEP next to items that you do not want included in the export. In the example Naming Contexts section shown below, the o=adeurope and o=adseradiantproxy naming contexts would not be included in the export. After customizing the migration plan, run the command to export the configuration. Make sure the migration_plan.json is located in the same location as the migrate script, otherwise it is not used and the default export is performed.

"vds_server" : {
    "namingcontexts" : {
      "o_adeurope" : "KEEP",
      "o_adseradiantproxy" : "KEEP",
      "o_azuremgraph" : "MIGRATE",
      "o_empldaphierarchy" : "MIGRATE",
      "o_hrdatabase" : "MIGRATE",
      "o_myprofile" : "MIGRATE",
   }

>[!warning] Use extreme caution when customizing the migration plan. Make sure that you don’t accidently exclude needed .orx files, .dvx files, and/or data sources for naming contexts that you include in the export.
