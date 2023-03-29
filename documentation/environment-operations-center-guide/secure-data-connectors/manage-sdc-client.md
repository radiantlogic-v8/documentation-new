---
keywords:
title: Manage the Secure Data Connector Client
description: Manage the secure data connector client
---
# Manage the Secure Data Connector Client

This guide outlines the steps to manage a secure data connector client, including updating, troubleshooting, and reviewing client logs.

## Update the secure data connector client

Client updates can be applied by stopping the client or as a rolling update. The following sections outline how to apply updates to Windows, Linux, or Docker systems, as well as how to apply rolling updates to avoid an interruption in service.

### Update on Windows or Linux

The client must be stopped before applying an update. To stop the client, select **Ctrl + C** in the terminal window running the client.

To install the update, unzip the new client version in the same directory that contains the current client. Overwrite everything except for *appsettings.Production.json*, as this is the configuration file for the client.

If the update is being installed on a Windows system, launch the *RaidantLogic.OnPremisesAgentClient.Agent.exe* file.

If the update is being installed on a Linux system, run the following command:

`dotnet run RadiantLogic.OnPremisesAgentClient.Agent.dll`

### Update on Docker

To update a secure data connector client on Docker, stop the Docker image and then start it again with the latest tag. The client will start running again with the latest available version.

### Rolling update

Installing a rolling update allows the client to continue running with no downtime during the update. To install a rolling update, create a new data connector in Environment Operations Center within the same group as the client you would like to update. 

![image description] (insert image of new agent creation in EOC)

Copy the new token from the *Data Connector Registration* dialog in the data connector details section.

![image description] (image of new token copied)

Follow the steps outlined in the [deploy a secure data connector client](deploy-sdc-client.md) guide for your system type to deploy the client as a fresh installation.

Once the new client deployment is complete, delete the old client.

## Troubleshooting

The following sections outline common errors that can occur while deploying or running a secure data connector client, along with possible solutions to resolve the error.

### Duplicated token

The unique token associated with a new data connector in Env Ops Center can only be used to deploy one secure data connector client. If a data connector token is used to run more than one client, you will receive a duplicate agent connection error in the client terminal.

![image description](images/err-duplicate-connection.png)

To resolve the error, return to Env Ops Center an create a new secure data connector and use the unique token to deploy the client.

For details on creating a new data connector, see the [add a data connector](add-data-connector.md) guide. For details on deploying a secure data connector client, see the [deploy a secure data connector client](deploy-sdc-client.md) guide.

### Test connection error

The following control panel error may indicate that the secure data connector client has stopped running: "Connection failed: An error has occurred, please contact your administrator".

![image description](images/test-connection-err.png)

If you receive the above connection failure error, return to the secure data connector client and verify that it is running.

### Test connection failure on Docker client

A test connection may fail for the localhost hostname for a secure data connector client deployed on a Docker container. The following error may indicate that a test connection failure has occurred: "Connection failed: Protocol or communication error".

![image description] (insert error image)

To resolve the connection failure, enter the special DNS name `host.docker.internal` in the **Host Name** field. This will resolve the internal IP address used by the host, allowing the Docker container running the client to access the host server backend.

![image description] (insert control panel image)

### Inoperative test connection

If the test connection is not working but you are unsure of the error, first review the secure data connector status in Env Ops Center.

First, save the backend data source and then navigate to the *Secure Data Connector* section of Env Ops Center. If the secure data connector status is "Disabled", the connection has not been correctly setup. Review the associated logs for the data connector to determine the error.

If the secure data connector status is "Active", then the inlets tunnel is working.

## Review client logs

The following sections outline where to locate the data connector client logs on a Windows, Linux, or Docker system.

### Review logs on Windows or Linux

If the secure data connector client is running on a Windows or Linux system, navigate to the unzipped directory. The client logs are located in the "/Logs" file in the directory.

### Review logs on a Docker container

If the secure data connector client is running on a Docker container, open a terminal and connect to the docker container using the following command:

`docker exec -it <container_name> bash`

Navigate to the logs folder:

`cd Logs`

List the log files:

`ls`

From here, you can open the logs files to access further details on the client activity.

## Next steps

You should now have an understanding of how to update, troubleshoot, and monitor the secure data connector client. For details on deploying the secure data connector client, see the [deploy a secure data connector client](deploy-sdc-client.md) guide. For details on managing data connectors in Env Ops Center, see the [manage data connectors](manage-data-connectors.md) guide.
