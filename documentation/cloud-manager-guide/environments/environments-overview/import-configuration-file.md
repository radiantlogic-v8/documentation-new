---
keywords:
title: Import a configuration file
description: Steps to import a configuration file to an existing environment
---
# Import a configuration file

This guide outlines the steps required to import a configuration file into an existing environment in Cloud Manager. 

> **Note:** Before getting started, ensure you have the correct configuration ZIP file saved and ready to upload.

Quick Links to other docs

## Begin file upload

You can begin the configuration file import from the [*Environments* home screen](#environments-home-screen) or from a [specific environment's *Details* screen](#environment-details-screen). After initiating the file import workflow, the steps to [import a configuration file](#upload-configuration-file) are the same.

### Environments home screen

To begin the file import from the *Environments* home screen, locate the environment where you would like to import a configuration file. Select the ellipsis to the far right to open the *Options* dropdown menu. From the dropdown menu, select **Import Configuration** to open the import configuration dialog box and begin the [file import workflow](#upload-configuration-file).

![image description](environments/environment-overview/images/import-configuration.png)

### Environment details screen

To being the file import from a specific environment's *Details* screen, select **Configuration** from the navigation bar to navigate to the *Configuration* screen.

![image description](environments/environment-overview/images/import-env-details-screen.png)

From the *Configuration* screen, select the **Import Configuration** button to open the import configuration dialog box and begin the [file import workflow](#upload-configuration-file).

![image description](environments/environment-overview/images/import-config-button.png)

## Upload configuration file

There are two options to upload the configuration file:

- Drag and drop the file into the file upload box provided.
- Select **Choose File** to open your system's file manager and select the file to upload.

![image description](environments/environment-overview/images/import-dialog.png)

While your file is uploading, the upload box will display an "Uploading" message and an upload progress bar appears just below with your file name. You can cancel the file upload by selecting the **X** located next to the progress bar.

![image description](environments/environment-overview/images/import-uploading.png)

Once the file upload is complete, your file name appears next to a blue circle and check mark indicating a successful upload.

To begin importing the configuration file, select **Import**. This will take you to the [confirmation screen](#upload-confirmation).

![image description](environments/environment-overview/images/import-successful-upload.png)

> **Note:** Importing a new configuration file will replace the environment's current configuration file.

To delete the uploaded configuration file and return to the screen to select a file to upload, select the trash bin icon next to the file name.

![image description](environments/environment-overview/images/import-delete-upload.png)

## Upload confirmation 

After selecting **Import**, a confirmation message will appear notifying that importing your file will replace the existing configuration file. If you would like to proceed, select **Yes, Import Configuration**. Select Cancel if you wish to cancel and exit out of the file upload process.

![image description](environments/environment-overview/images/import-confirm.png)

If you started the configuration file import from the *Environments* home screen, you will be directed back to the [home screen](#environments-home-screen-confirmation) while the file uploads. Alternatively, if you started the configuration file import from a specific environment's *Details* screen, you will be directed back to the [*Configuration* screen](#configuration-screen-confirmation) while the file uploads.

### Environments home screen confirmation

After selecting **Yes, Import Configuration** from the [confirmation dialog](#upload-confirmation), you will return to the *Environment's* home screen. Here, you will receive a confirmation message that your environment is being updated and that the process can take up to 1 hour. The environment's *Status* will display as "Updating...".

To hide the confirmation message, select **Dismiss**.

![image description](environments/environment-overview/images/import-updating.png)

If the file import is successful, the environment's *Status* will update to "Operational".

![image description](environments/environment-overview/images/import-operational.png)

If the file import is unsuccessful, you will receive an error notification and the environment's *Status* will change to "Import Failed".

To hide the error message, select **Dismiss**.

![image description](environments/environment-overview/images/import-failed.png)

### Configuration screen confirmation

After selecting **Yes, Import Configuration** from the [confirmation dialog](#upload-confirmation), you will return to the *Configuration* screen. Here, you will receive a confirmation message that your environment is being updated and that the process can take up to 1 hour.

Select **Dismiss** to close the confirmation message while the file upload processes.

![image description](environments/environment-overview/images/import-envdetails-uploading.png)

If the file import is successful, the top level row displays the environment's details for the most recent configuration action. In the case of a file import this includes:

- Action: "Import", indicating a configuration file is being imported.
- Date: the date of the file import.
- Version: the environment version number.
- User: the user who imported the configuration file.
- Status: displays as "Successful".

![image description](environments/environment-overview/images/import-envdeatails-success.png)

If the file import is unsuccessful, you will receive an error notification and the first row's *Status* will change to "Failed".

Select **Dismiss** to close the error message.

![image description](environments/environment-overview/images/import-envdetails-error.png)

## Next steps

After reading this guide you should have an understanding of the steps required to import a configuration file to an existing environment, either from the *Environment's* home screen or from a specific environments *Details*. To learn how to export a configuration file, review the guide on **exporting a configuration file**.

### Related documentation

- Review configuration history
- Export a configuration file
- Delete an environment
- View environment details
