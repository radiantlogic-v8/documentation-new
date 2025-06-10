---
title: Deployment and Tuning Guide
description: Deployment and Tuning Guide
---

# Starting and Stopping Components and Services

This document covers how to start, stop, restart, and uninstall RadiantOne Identity Data Management and the Jetty web server hosting the Control Panels. It includes details for both Windows and Linux platforms.  

## Starting RadiantOne 

You can start RadiantOne Identity Data Management manually using the Control Panel web application or the included shell scripts. Alternatively, you can configure RadiantOne to run as an operating system service or daemon (Windows/Linux) by following the steps outlined in this document.  
 
We recommend setting up RadiantOne Identity Data Management as an operating system service (Windows service or Linux daemon/service) in production environments to automate its lifecycle (stopping, starting, etc.). 

### Starting via Control Panel

Launch the Control Panel web application and log in with the super user account (default: cn=directory manager or  cn=directory administrators) using the password set during installation. 

From the Dashboard tab, start RadiantOne Identity Data Management by clicking the power button icon, and selecting the “Start” action from the context menu. 

>[!warning]
> Starting RadiantOne from the Dashboard tab will cause it to stop when you log off your device. To keep it running, start RadiantOne as a OS-managed service instead. When it is set up that way, it cannot be started or stopped via the Control Panel. This prevents manual intervention and ensures the service manager alone controls its startup and shutdown. 

### Starting via Shell scripts 

To start RadiantOne Identity Data Management manually, navigate to the bin folder in your RLI_HOME directory and execute the following script:

* `startVDSServer.bat` (on Windows) or `runVDSServer.sh` (on Linux). 

### Starting as a Windows Service 

To start **RadiantOne Identity Data Management** as a Windows service, follow the steps outlined below. For clustered environments, perform these steps on **each node**.

1. Navigate to the `\bin\windows.service` directory. You will find two batch files:
   - `fid-server-service-install.bat`: Installs RadiantOne Identity Data Management as a Windows service.
   - `fid-server-service-uninstall.bat`: Uninstalls the RadiantOne Identity Data Management Windows service.

2. Execute `fid-server-service-install.bat`.  
   To do this, **right-click the file** and select **Run as administrator**.

3. A command window will appear briefly and then close automatically.

4. Open or refresh the **Services** window.  
   You should now see a new service listed for **RadiantOne Identity Data Management**.

5. Start RadiantOne Identity Data Management using the newly created service.

> **Note:** Repeat steps 1–5 on all nodes if deployed in a **cluster**, or on all applicable servers in a **classic deployment**.

### Starting as a Linux Daemon 
  

To configure and start RadiantOne Identity Data Management as a Linux service, use either init.d or systemd scripts provided with the installed product. 

* For init.d scripts: 

    ```
    sudo cp $RLI_HOME/bin/rc.d/vds /etc/init.d/ 
    sudo chmod +x /etc/init.d/vds 
    sudo chkconfig --add vds 
    sudo service vds start 
    ps -ef | grep vds  # Confirm RadiantOne runs under the correct user
    ```
      

* For systemd scripts: 

    ```
    sudo cp $RLI_HOME/bin/system.d/vds.service /etc/systemd/system/ 
    sudo systemctl enable vds.service 
    sudo systemctl start vds.service
    ```

## Stopping RadiantOne

### Stopping via Control Panel

Launch the **Control Panel** web application and log in with the super user account  
(default: `cn=directory manager` or `cn=directory administrators`) using the password set during installation.

From the **Dashboard** tab, stop RadiantOne Identity Data Management by clicking the **power button icon**, and selecting the **“Stop”** action from the context menu.

> **Note:** When RadiantOne Identity Data Management is set up as an **OS-managed service**, it cannot be started or stopped via the Control Panel.  
> This prevents manual intervention and ensures the service manager alone controls its startup and shutdown.


### Stopping the Windows Service

If RadiantOne Identity Data Management is installed as a **Windows service**:

1. Open the **Services** console.
2. Locate the **RadiantOne Identity Data Management** service.
3. Right-click and select **Stop** to stop the service.

### Stopping the Linux Daemon

Use the appropriate command based on your Linux system’s service manager:

* For init.d: `/etc/init.d/vds stop`

* For systemd: `systemctl stop vds.service`
  

