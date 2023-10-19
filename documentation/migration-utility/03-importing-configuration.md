---
title: Migration Utility
description: Migration Utility
---

If a migration plan has been extracted from the export file and customized, the import command uses it to determine what configuration should be included in the import. If a migration plan has not been extracted and customized, the migration utility imports the configuration dictated by its default behavior.

The following example assumes the migration utility has been unzipped at C:\MigrationUtility\radiantone-migration-tool-2.1.0 and the file to import is C:/tmp/export.zip. The cross-environment option in the command indicates that the source environment is a different machine, and possibly a different build (patch) version of RadiantOne, than the target environment. For example, the source environment could be running v7.4.0 and the target environment could be running v7.4.X, where X > than 0.

C:\MigrationUtility\radiantone-migration-tool-2.1.0\migrate.bat import C:/tmp/export.zip cross-environment

>[!warning] Ensure all RadiantOne services EXCEPT ZooKeeper are stopped on the target machine prior to importing. If you have deployed RadiantOne in a cluster, only the services on the machine you are importing into need stopped. ZooKeeper servers in the ensemble must be running prior to importing.

If you do not have an RLI_HOME environment variable defined, you must pass the location where RadiantOne is installed in the command.

## Customizing a Migration Plan

Prior to performing an import, you can extract and customize the migration plan from the export file. Customizing the migration plan is optional and allows for more flexibility over what configuration is imported. To extract the migration plan, use generate-migration-plan along with the full path to the export zip file. An example is shown below.

C:\MigrationUtility\radiantone-migration-tool-2.1.0 generate-migration-plan C:/tmp/export.zip

>[!warning] If you do not have an RLI_HOME environment variable defined, you must pass the location where RadiantOne is installed in the command.

This command generates migration_plan.json in the location where you executed the script. The .json file contains the naming contexts (this is only the definition of the naming contexts, not the dependencies – orx files, dvx files, data sources), RadiantOne Universal Directory (HDAP) stores (only the actual data, not the naming context), data sources, schema files (.orx), and virtual view files (.dvx) that are possible to import. You can edit the .json file and use the keyword MIGRATE next to the items you want to be included in the import, and the keyword KEEP next to items that you do not want included in the import. Make sure the migration_plan.json is located in the same location as the migrate script, otherwise it is not used and the default import is performed.

>[!warning] Use extreme caution when customizing the migration plan. Make sure that you don’t accidently exclude needed .orx files, .dvx files, and/or data sources for naming contexts that you include in the import.

After customizing the migration plan, run the command to import the configuration.
