---
keywords:
title: Configure Secure Data Connector Client to run in Proxy environment
description: Configure the secure data connector client to run in proxy environment
---
# Run the Secure Data Connector Client under Proxy Network Setup

Once a secure data connector has been created in Environment Operations Center, the client must be deployed on your local system before you can establish a connection. The default guideline on system requirements and steps to deploy a data connector client on a Windows, Linux, or Docker system are available in [deploy a secure data connector client](deploy-sdc-client.md) guide.

This guide covers the **additional steps** needed for running the client in a proxy network setup.

[!note] You must create a secure data connector endpoint in Env Ops Center before deploying on the client side. For details on how to create a secure data connector in Env Ops Center, see the [add a data connector](add-data-connector.md) guide.

## Proxy Configuration for Windows

To have secure data connector client run on a Windows system, refer the section ***Deploy on Windows*** in [deploy a secure data connector client](deploy-sdc-client.md) guide.

There are two options you can configure the proxy connection. First option is to open the *appsettings.Production.json* file and locate the proxy section, and fill in the values for respective keys.

| Proxy Configuration Key| Description |
| ------------------- | ----------- |
| Url | The proxy server url. |
| UserName | If proxy server requires authetication, its username value. |
| Password | If proxy server requires authetication, its password value. |

![image description](images/appsettings-proxy.png)

Second option is to set the proxy configuration at the windows operating system level by setting the system environment variables **http_proxy** and **https_proxy**.

The values for these variables can be of following formats:
- http://{username}:{password}@{proxy_server_ip}:{proxy_server_port}
- https://{username}:{password}@{proxy_server_ip}:{proxy_server_port}

| Placeholder | Description |
| ------------------- | ----------- |
| username | Proxy server credential, username value. |
| password | Proxy server credential, password value. |
| proxy_server_ip | The proxy server IP. |
| proxy_server_port | The proxy server port. |

![image description](images/win-proxy-env-variables.png)

Launch the *RadiantLogic.OnPremisesAgentClient.Agent.exe* file. A notification will display in the command line that confirms a connection has been established between the agent and server.

![image description](images/windows-success.png)

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](../../sys-admin-guide/server-backend.md) guide.

## Proxy Configuration for Linux

To have secure data connector client run on a Linux system, refer the section ***Deploy on Linux*** in [deploy a secure data connector client](deploy-sdc-client.md) guide.

There are two options you can configure the proxy connection. First option is to open the *appsettings.Production.json* file and locate the proxy section, and fill in the values for respective keys.

| Proxy Configuration Key| Description |
| ------------------- | ----------- |
| Url | The proxy server url. |
| UserName | If proxy server requires authetication, its username value. |
| Password | If proxy server requires authetication, its password value. |

![image description](images/appsettings-proxy.png)

Second option is to set the proxy configuration at the linux operating system level by setting the environment variable **https_proxy**.

The values for this variable can be of following formats:
- http://{username}:{password}@{proxy_server_ip}:{proxy_server_port}
- https://{username}:{password}@{proxy_server_ip}:{proxy_server_port}

| Placeholder | Description |
| ------------------- | ----------- |
| username | Proxy server credential, username value. |
| password | Proxy server credential, password value. |
| proxy_server_ip | The proxy server IP. |
| proxy_server_port | The proxy server port. |

The value is set using the command:

`export https_proxy=http://linux1:test@a92.168.8.3.3128`

Open the command line and navigate to the directory that contains the unzipped *sdc-windows.zip* files. From the directory, run the following command to launch the secure data connector client:

`dotnet run RadiantLogic.OnPremisesAgentClient.Agent.dll`

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](../../sys-admin-guide/server-backend.md) guide.

## Proxy Configuration for Docker

To have secure data connector client run on a Linux system, refer the section ***Deploy on Docker*** in [deploy a secure data connector client](deploy-sdc-client.md) guide.

There are two options to configure the proxy for Docker. First option is to set the proxy configuration at each containers by passing values for the environment variables while running the docker command.

`docker run -e "ServerHubConfiguration__AgentToken=[access_token]" -e "ServerHubConfiguration__Proxy__Url=http://192.168.8.3:3128" -e "ServerHubConfiguration__Proxy__UserName=ProxyUs3r" -e "ServerHubConfiguration__Proxy__Password=$Pa$$word!" -e HTTP_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" -e HTTPS_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" radiantone/sdc-client:latest`

The second option is to set the proxy configuration at the docker engine as shown below:

![image description](images/proxy-docker-engine.png)

When proxy configuration is set at the docker engine, the secure data connector client can be run as normal:

`docker run -e "ServerHubConfiguration_AgentToken=[access_token]" radiantone/sdc-client`

![image description](images/docker-command-line.png)

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](../../sys-admin-guide/server-backend.md) guide.

## Next steps

After reading this guide, you should now have an understanding of the steps required to configure proxy information to successfully run a secure data connector client on a Windows, Linux, or Docker system. To learn how to establish a connection with the on-premise backend, see the control panel [server backend](../../sys-admin-guide/server-backend.md) guide. For details on updating and monitoring the secure data connector client, see the [manage the secure data connector client](manage-sdc-client.md) guide.
