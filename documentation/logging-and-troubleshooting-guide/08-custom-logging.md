---
title: Logging and Troubleshooting
description: Logging and Troubleshooting
---

# Custom Logging

RadiantOne includes a custom logger that can be used in interception scripts, custom data source/object scripts and transformation scripts. This allows for directing log output to a specified log file. To use custom logging, edit your script and add the following line. Update the log file name and path accordingly:

```
private final static Logger customLogger = com.rli.logging.LoggingUtils.getUserLogger("/radiantone/vds/vds_server/logs/myCustomLog.log");
```

Throughout the script, use the following to write to the log file: 

```
customLogger.info(“LOG OUTPUT”); 
```

If you are customizing an interception or custom data source/object script, rebuild the .jar file and restart the RadiantOne service. Jar files can be rebuilt using ANT. An example is shown below (for simplicity, most of the output of the script has been excluded below). Restart the RadiantOne service after jars are rebuilt. If RadiantOne is deployed in a cluster, restart the service on every node.

```
C:\radiantone\vds\vds_server\custom>c:\radiantone\vds\ant\bin\ant.bat buildjars
```

`Buildfile: build.xml 
[propertyfile] Creating new property file: C:\radiantone\vds\vds_server\custom\build.txt 
buildjars: 
[jar] Building jar: C:\radiantone\vds\vds_server\custom\lib\customobjects.jar
[jar] Building jar: C:\radiantone\vds\vds_server\custom\lib\intercept.jar 
[jar] Building jar: C:\radiantone\vds\vds_server\custom\lib\fidsync.jar 
[jar] Building jar: C:\radiantone\vds\vds_server\custom\lib\changeMessageConvertors.jar 
BUILD SUCCESSFUL 
Total time: 9 seconds`

To customize the Log Level and Rollover strategy for the custom log file:

1.	Go to Main Control Panel > Settings > Logs > Log Settings.

2.	In the Log Settings to Configure drop-down list, select Common - User.

3.	Select the Log Level from the drop-down list.

4.	Enter a Rollover size amount.

5.	Indicate the number of files to keep in archive.

6.	Click **Save**.

