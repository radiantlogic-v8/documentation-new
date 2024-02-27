---
title: Configure Secure Data Connector Client to run in Proxy environment. Deploy the Secure Data Connector Client.
description: Configure the secure data connector client to run in proxy environment. Learn how to deploy the Secure Data Connector client in your on-premise or private cloud environment.
---

# Run the Secure Data Connector Client under Proxy Network Setup

Once a secure data connector has been created in Environment Operations Center, the client must be deployed on your local system before you can establish a connection. The default guideline on system requirements and steps to deploy a data connector client on a Windows, Linux, or Docker system are available in [deploy a secure data connector client](#system-requirements) guide.

This guide covers the **additional steps** needed for running the client in a proxy network setup.

>[!note] You must create a secure data connector endpoint in Env Ops Center before deploying on the client side. For details on how to create a secure data connector in Env Ops Center, see the [add a data connector](configure-sdc-service#adding-a-new-data-connector) guide.

## Proxy Configuration for Windows

To have secure data connector client run on a Windows system, refer the section ***Deploy on Windows*** in [deploy a secure data connector client](#deploy-the-secure-data-connector-client) guide.

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

Once you have the proxy configuration setup, go back to *Deploy on Windows* section in [deploy a secure data connector client](#deploy-the-secure-data-connector-client) guide and follow the next steps.

## Proxy Configuration for Linux

To have secure data connector client run on a Linux system, refer the section ***Deploy on Linux*** in [deploy a secure data connector client](#deploy-the-secure-data-connector-client) guide.

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

	export https_proxy=http://linux1:test@a92.168.8.3.3128

Once you have the proxy configuration setup, go back to *Deploy on Linux* section in [deploy a secure data connector client](#deploy-the-secure-data-connector-client) guide and follow the next steps.

## Proxy Configuration for Docker

To have secure data connector client run on a Linux system, refer the section ***Deploy on Docker*** in [deploy a secure data connector client](#deploy-the-secure-data-connector-client) guide.

There are two options to configure the proxy for Docker. First option is to set the proxy configuration at each containers by passing values for the environment variables while running the docker command.

docker run -e "ServerHubConfiguration__AgentToken=[access_token]" -e "ServerHubConfiguration__Proxy__Url=http://192.168.8.3:3128" -e "ServerHubConfiguration__Proxy__UserName=ProxyUs3r" -e "ServerHubConfiguration__Proxy__Password=$Pa$$word!" -e HTTP_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" -e HTTPS_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" radiantone/sdc-client:latest

The second option is to set the proxy configuration at the docker engine as shown below.

![image description](images/proxy-docker-engine.png)

When proxy configuration is set at the docker engine, the secure data connector client can be run as normal:

	docker run -e "ServerHubConfiguration_AgentToken=[access_token]" radiantone/sdc-client

![image description](images/docker-command-line.png)

It is highly recommended to have logs from sdc-client to go into a mounted drive, to have that setup replace the above commands with the one below based on one of the options you chose for your deployment:

**Option 1 (Passing proxy information as part of environment variables):**

    docker run -v /path/on/host:/app/logs -e "ServerHubConfiguration__AgentToken=[access_token]" -e "ServerHubConfiguration__Proxy__Url=http://192.168.8.3:3128" -e "ServerHubConfiguration__Proxy__UserName=ProxyUs3r" -e "ServerHubConfiguration__Proxy__Password=$Pa$$word!" -e HTTP_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" -e HTTPS_PROXY="http://ProxyUs3r:$Pa$$word!@192.168.8.3:3128" radiantone/sdc-client:latest	
**Option 2 (Making changes at docker engine level):**

	docker run -v /path/on/host:/app/logs -e "ServerHubConfiguration_AgentToken=[access_token]" radiantone/sdc-client

Replace `/path/on/host` with an actual path on your host machine where you want to store the logs.

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](configuration/data-sources.md) guide.


# Deploy the Secure Data Connector Client

Once a secure data connector has been created in Environment Operations Center, the client must be deployed on your local system before you can establish a connection. This guide outlines the system requirements and steps to deploy a data connector client on a Windows, Linux, or Docker system.

> [!note] You must create a secure data connector endpoint in Env Ops Center before deploying on the client side. For details on how to create a secure data connector in Env Ops Center, see the [add a data connector](configure-sdc-service#adding-a-new-data-connector) guide.

## System requirements

The following system specifications are required to deploy the secure data connector client. Please ensure your system meets these requirements before proceeding to the deployment steps below.

System requirements:

- ASP.NET core runtime must be installed on the machine or SDK (version 6 and above). The runtime is available on the [Microsoft .NET](https://dotnet.microsoft.com/en-us/download/dotnet/6.0) page.
- CPU: x-64 processor
- Processor: 1 GHz
- RAM 512 MB
- Minimum disc space (64-bit): 4.5 GB
- Operation System: Windows Server 2016 Datacenter, Windows Server 2019 Datacenter, Windows Server 2022 Datacenter, AWS Linux 2, Ubuntu 20.04.6 LTS, Red Hat Enterprise Linux 8.8, and Debian GNU/Linux 12.

## Getting started

Before deploying the secure data connector client, you must retrieve the registration token associated with the data connector in Env Ops Center. For Windows or Linux systems, you must also download the respective binary. 

To locate these dependencies in Env Ops Center, select the connector name to open the connector details. Alternatively, you can also select **View Details** from the **Options** (**...**) dropdown menu to open the connector details.

![image description](images/connector-view-details.png)

In the *Data Connector Info* section the connector status displays as "Unregistered", and there are no available connections. 

Next to the status in the *Data Connector Info* section select **Register**.
![image description](images/connector-register.png)

For Windows or Linux systems, select the applicable card to download the binary.

![image description](images/download-binary.png)

A confirmation message displays once the binary has successfully downloaded.

![image description](images/binary-success.png)

Select the copy icon to copy the registration token located just below the Windows and Linux cards. You will use this while deploying the secure data connector client. The steps to deploy a secure data connector on a Windows or Linux system are outlined in the following sections.

![image description](images/copy-token.png)

For a Docker container, copy the docker command located in the *Docker* section of the *Data Connector Registration* dialog. You will use this while deploying the secure data connector client on the Docker container. The steps to deploy a secure data connector on a Docker container are outlined in the following sections.

![image description](images/docker-token.png)

## Deploy on Windows

To deploy the secure data connector client on a Windows system, first unzip the *sdc-windows-(version).zip* file into a directory on the client system. Next, locate the following files:

- *appsettings.Production.json*
- *RadiantLogic.OnPremisesAgentClient.Agent.exe*

![image description](images/binary-windows-files.png)

Open the *appsettings.Production.json* file and locate the `"AgentToken"` field. Enter the token copied from the *Data Connector Registration* dialog in Env Ops Center into the `"AgentToken"` field.

![image description](images/appsettings-token.png)

If the client to be run on a network where proxy is setup, see the [Proxy Configuration for Windows](#proxy-configuration-for-windows) section. Once you have the proxy settings updated following instructions in [proxy configuration](#run-the-secure-data-connector-client-under-proxy-network-setup) guide, continue to the next steps.

Launch the *RadiantLogic.OnPremisesAgentClient.Agent.exe* file. A notification displays in the command line that confirms a connection has been established between the agent and server.

![image description](images/windows-success.png)

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](configuration/data-sources/data-sources) guide.

### Deploy as a service on Windows

#### Step 1: Launch Command window as Administrator (Run as administrator)

#### Step 2: Create the service using following commands
    sc create <ServiceName> binPath= "<PathToExecutable> --service”

![image description](images/windows-create-service.png)

#### Step 3: Configure the service to start automatically (Optional)
    sc config <ServiceName> start= auto

![image description](images/windows-service-auto-start.png)

#### Step 4: Start the service 
    sc start <ServiceName>

![image description](images/windows-service-start.png)

Following all the above steps, your sdc-client should be registered to run as a Windows service and started automatically.

![image description](images/windows-service-running.png)

## Deploy on Linux

To deploy the secure data connector client on a Linux system, first unzip the *sdc-linux-(version).zip* file into a directory on the client system. Next, locate the following files:

- *appsettings.Production.json*
- *RadiantLogic.OnPremisesAgentClient.Agent*

Open the *appsettings.Production.json* file using an editor and locate the `"AgentToken"` field. Enter the token copied from the *Data Connector Registration* dialog in Env Ops Center into the `"AgentToken"` field.

![image description](images/linux-vi-appsettingsjson-file.png)

If the client to be run on a network where proxy is setup, see the *Proxy Configuration for Linux* section in [run the secure data connector client under proxy network setup](configure-sdc-client.md) guide.  Once you have the proxy settings updated following instructions in [proxy configuration](#run-the-secure-data-connector-client-under-proxy-network-setup) guide, continue to the next steps.

Open the command line and navigate to the directory that contains the unzipped *sdc-linux.zip* files. From the directory, run the following command to give execute permissions for inlets-pro and RadiantLogic.OnPremisesAgentClient.Agent:
    
    chmod +x ./RadiantLogic.OnPremisesAgentClient.Agent
    chmod +x ./inlets-pro

Then launch the secure data connector client using this command:

    ./RadiantLogic.OnPremisesAgentClient.Agent

A notification displays in the command line that confirms a connection has been established between the agent and server.

![image description](images/linux-run-client.png)

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](configuration/data-sources/data-sources) guide.

### Deploy as a daemon on Linux

#### Step 1: CD to binary location and give execute permissions for inlets-pro and RadiantLogic.OnPremisesAgentClient.Agent

    chmod +x ./RadiantLogic.OnPremisesAgentClient.Agent
    chmod +x ./inlets-pro

![image description](images/linux-chmod-cmds.png)
#### Step 2: Check the Init System:
Determine which init system your Linux distribution uses. Common init systems include systemd, SysV init, and Upstart. You can often identify the init system by checking the version of Linux or the documentation for your specific distribution. Steps 3.1 and 3.2 covers the cases of systemd and SysV Init.

#### Step 3.1: If your system use 'systemd'. Follow below steps:

**Create a Systemd Service File:**

Create a .service file in the /etc/systemd/system/ directory. This file defines the configuration for our application daemon. Replace **‘your-app-name’** with an appropriate name for SDC Client:

    sudo nano /etc/systemd/system/your-app-name.service

**Edit the Service File:**

In the nano editor, add the following content to the service file, adjusting the paths and parameters to match your environment:

```
[Unit]
Description=Give your description here for running SDC Client as Daemon
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=/path/to/binary/sdc-client
ExecStart=/path/to/binary/sdc-client/RadiantLogic.OnPremisesAgentClient.Agent
Restart=always
RestartSec=10
SyslogIdentifier=your-app-name
User=your-username
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
```

![image description](images/linux-edit-service-file.png)

- WorkingDirectory: Set this to the directory where your downloaded binaries is located.

- ExecStart: Specify the path to executable and the path to application's DLL.

- User: Replace your-username with the appropriate username that should run the application.

**Reload Systemd and Start the Service:**

After creating and editing the service file, reload the systemd configuration and start the application: 

    sudo systemctl daemon-reload

    sudo systemctl start your-app-name

![image description](images/linux-start-daemon.png)

**Enable Autostart on Boot:**

To make sure your application starts automatically when the system boots, enable the service:

    sudo systemctl enable your-app-name

To validate the sdc client is successfully started as a service, you can check the client logs in the /Logs folder and opening the log file:

![image description](images/linux-check-logs-service-started.png)

**Manage the Service:**

You can use standard systemd commands to manage your application daemon:
- Start: ```sudo systemctl start your-app-name```

- Stop: ```sudo systemctl stop your-app-name```

- Restart: ```sudo systemctl restart your-app-name```

- Check status: ```sudo systemctl status your-app-name```

- Disable autostart: ```sudo systemctl disable your-app-name```

**Note:** Remember to replace placeholders like ***your-app-name***, ***/path/to/binary/sdc-client***, and ***your-username*** with actual values.

#### Step 3.2: If your system use 'SysV init'. Follow below steps:

**Create a new init script file, replacing **your-app-name** and adjusting paths:**

    sudo nano /etc/init.d/your-app-name

**Add the following content to the file:**

```
#!/bin/bash
### BEGIN INIT INFO
# Provides:          your-app-name
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Give your description here for running SDC Client as Daemon
# Description:       Give your detailed description here for running SDC Client as Daemon
### END INIT INFO

case "$1" in
  start)
    cd /path/to/binary/sdc-client
    sudo -u your-username RadiantLogic.OnPremisesAgentClient.Agent &
    ;;
  stop)
    pkill -f "RadiantLogic.OnPremisesAgentClient.Agent"
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
```

**Save the file and make it executable:**

    sudo chmod +x /etc/init.d/your-app-name

**Start and Manage the Service:**

Use the following commands to start, stop, and restart your application:

Start: sudo /etc/init.d/your-app-name start
Stop: sudo /etc/init.d/your-app-name stop
Restart: sudo /etc/init.d/your-app-name restart

**Enable Autostart on Boot:**

If your init system supports it, you might be able to enable the script to start automatically on boot:

    sudo update-rc.d your-app-name defaults

**Note:** Remember to replace placeholders like ***your-app-name***, ***/path/to/binary/sdc-client***, and ***your-username*** with actual values.

## Deploy on Docker

To deploy the secure data connector client on Docker, Docker must first be installed on the system. If you have not yet installed Docker, please visit the [Docker](https://docs.docker.com/get-docker) site and follow the instructions to download and install.

Open the command line and run the copied command from Env Ops Center to start the client:

    docker run -e "ServerHubConfiguration_AgentToken=[access_token]" radiantone/sdc-client

It is highly recommended to have logs from sdc-client to go into a mounted drive, to have that setup replace the above command with the one below:

    docker run -v /path/on/host:/app/logs -e "ServerHubConfiguration_AgentToken=[access_token]" radiantone/sdc-client

Replace `/path/on/host` with an actual path on your host machine where you want to store the logs.

If the client to be run on a network where proxy is setup, see [Proxy Configuration for Docker](#proxy-configuration-for-docker).

The `radiantone/sdc-client` is the latest image of the secure data connector client container located in the Radiant Logic Docker Hub repository.

![image description](images/docker-command-line.png)

Once the client is running, you can can setup a connection with the on-premise backend. For details on setting up a connection, see the [server backend](configuration/data-sources/data-sources) guide.
