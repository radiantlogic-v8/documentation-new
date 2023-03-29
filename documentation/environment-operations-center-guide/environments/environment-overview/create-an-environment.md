---
keywords:
title: Create an Environment
description: Guide to create a new environment
---
# Create an Environment

This guide provides an overview of the steps required to create a new environment in Environment Operations Center.

An environment is where a RadiantOne product lives. Each environment is completely isolated and contains endpoints to access different applications. Each instance of Env Ops Center has a predefined number of production and non-production environments that can be created for production, development, quality assurance, and staging purposes. 

The number of each type of environment available depends on the tier selected during the initial configuration of your Env Ops Center instance. If you would like to adjust the number of production or non-production environments, please contact your Radiant account manager.

## Getting Started

You will need to have the following before setting up your new environment:

- Your environment tier.
- The version number that corresponds with your instance.
- If you are importing a configuration file, ensure you have the correct file type saved and ready to go.

The new environment setup requires you to define the environment type, details, and provides an optional step to upload a configuration file from another environment.

## New environment set up

To create a new environment, select the **New Environment** button on the *Environments* home screen.

![image description](images/create-new.png)

This takes you to the *New Environment* form that contains all the input fields for the information required to create a new environment. The following sections outline how to complete these required fields.

![image description](images/new-env-dialog.png)

### Define Environment Type

Start by selecting the required **Environment Type** and **Environment Tier**.

#### Environment type

To set the **Environment Type**, use the radio buttons to select either **Non-production**, for development and testing, or **Production**, for production purposes.

![image description](images/create-env-type.png) 

A status bar located just below the environment types indicates how many of your available production and non-production environments have been used. If your organization has already configured the maximum number of environments available in your tier, the environment type and associated radio button will be greyed out.

![image description](images/env-type-used.png)

#### Environment tier

To set the **Environment Tier**, select the tier that suits your organization's Env Ops Center subscription.

![image description](images/env-tier.png)

### Define environment details

Under the **Environment Details** section, set the environment name, version, password, and license key.

#### Environment name

To set the **Environment Name**, enter a unique name in the space provided. Names must follow the naming convention: can be alphanumeric, can contain underscores and hyphens, cannot contain any other special characters, and can contain 18 characters or less.

![image description](images/create-env-name.png)

#### Version

To set the Environment **Version**, select the version drop down to display all available versions. Select the value that corresponds with your organization's version of Environment Operations Center.

![image description](images/create-env-version.png)

#### Password

Select a password by either entering your chosen password in the space provided, or by selecting the **Generate** button to have a password automatically generated for you. 

[!note] Passwords must be a minimum of 12 characters, contain at least 1 special character, contain lower and upper case letters, and contain at least 1 number.

Depending on the complexity and strength of your password, you will receive a notification that your password is "Weak", "Fair", "Good", or "Strong". It is recommended that you adjust the password until you receive a "Strong" rating. Adjust your password accordingly to ensure you have entered a strong password before proceeding to the confirmation step.

![image description](images/password.png)

To confirm your password, reenter or copy and paste your password in the confirmation space provided. If you selected to have a password automatically generated, the password will also automatically populate in the confirmation text box.

To reveal your original or confirmation password, select the eye icon (![image description](images/eye-icon.png)) located within the text field you wish to view.

![image description](images/confirm-pw.png)

#### Create the new environment

Completing the steps outlined in the **Environment Type** and **Environment Details** sections are all that is required to set up your new environment. Once both sections are complete, select **Create** to create the new environment.

[!note] If you would like to upload a configuration file from an external environment, proceed to the Advanced Setup section.

![image description](images/create.png)

### Advanced Setup

An optional advanced setup is available if you would like to upload a configuration ZIP file from another environment or create the environment using samples. Enable advanced setup by toggling on **Advanced Setup**.

![image description](images/advanced-setup.png)

#### Upload type

Next, choose the type of configuration you would like to use by selecting either **Upload Configuration Artifact** or **Install Samples**.

- The **Upload Configuration Artifact** option allows you to upload a configuration ZIP file from an external environment.

- The **Install Samples** option will import sample data. See the [quick start](../../../quick-start-guide/02-understanding-default-configuration-and-samples.md) guide for further details about sample data.

![image description](images/upload-type.png)

#### Configuration file upload

To import a configuration file, select the configuration ZIP file to upload. You can locate the file on your system and drag and drop it into the provided space. Alternatively, you can select **choose file** within the upload box to open your system's file manager and locate the file to upload.

![image description](images/select-choose-file.png)

While your file is uploading, an "Uploading" message will appear in the file upload box, along with a progress bar. You can cancel the file upload while it is in progress by selecting the **X** located in the progress bar box.

![image description](images/upload-progress.png)

Once your configuration file has successfully loaded, the file name will appear in place of the file upload box. Select **Create** to create the new environment.

![image description](images/config-uploaded.png)

To delete the file and return to the file upload screen, select the trash can icon located in the same box as the successful file upload.

![image description](images/delete-config.png)

If the file upload is not successful, the configuration upload box displays with a red dashed outline and an error message appears just below. Review your file type to ensure you have selected the correct configuration file for upload and try again.

## New environment confirmation 

After saving the New Environment details form, you return to the *Environments* home screen. A confirmation message appears noting that your environment is being created and that the process can take up to 1 hour. The status of your new environment shows as "Creating". Select **Dismiss** to close the confirmation message.

![image description](images/creating.png)

Once the environment has been successfully created, the environment's status will switch from "Creating" to "Operational".

![image description](images/operational.png)

### Form submission failure

If there is an issue with the form submission, you will receive an error message that the new environment creation failed and the new environment will no longer be visible in the environment list on the *Environments* home screen. Select **Dismiss** to close the error message and proceed to restart the workflow to create a new environment.

### Failure to create new environment

If there is an error and the environment cannot be created, the environment status will switch from "Creating" to "Creation Failed".

Select the ellipsis (**...**) in line with the environment to display a list of options. Options include:

- **Submit Again**: resubmit the same form without editing any of the fields.
- **View Logs**: troubleshoot where the error may have occurred while the form data was processing.
- **Delete**: if the environment hasn't been successfully created, delete the failed instance.

## Next Steps

After reading this guide you should have an understanding of the steps required to create a new environment and optionally how to upload a configuration file during new environment creation. To learn how to update an existing environment, review the guide on [updating an environment](update-an-environment.md).
