# Chapter 3: Post Installation

This chapter describes applying your license key, verifying the installation of RadiantOne, and troubleshooting.

## Apply License Key

Copy your license.lic file into the <RLI_HOME>/vds_server directory (unless you copied the license key during the GUI-based install) before using RadiantOne.

## Verification of Successful Install

1. Check log files located at: <RLI_HOME>\logs\install\Install_<datestamp>.log. See    Troubleshooting for some common errors and their potential cause.
2. To check if ZooKeeper is running properly in the ensemble, youcan execute the following <RLI_HOME>/bin/advanced/cluster.bat check (.sh on UNIX) on a RadiantOne node. You should see a message similar to the one below for all the servers in the ensemble.
   <br> 2015 - 04 - 09 10:54:22 INFO com.rli.zookeeper.commands.ClusterCommands:? -
    Completed check with 0 errors.

## Troubleshooting

The results of the system checks performed during installation are saved here:
```
<RLI_HOME>/logs/install/system-check-install.log
<RLI_HOME>/logs/install/remote-check-install.log
```

| Error Message | Potential Cause | Remedy 
|------------|------------|--------------
The installer reports that the network throughput requirements are insufficient to continue the install. | Virus scanners can significantly impact I/O speed and network throughput. | Disable Virus Scanner during install. Note – after install, it is recommended to avoid or limit the [scanning of RadiantOne files/folders](01-prerequisites#virus-scanners).
In the installer wizard UI you might see: Error: Cannot establish connection with ZK ensemble at `<ZK server or IP>:2181` <br> In the `<RLI_HOME>\logs\install\Install_<datestamp>.log` you might see the following: <br> org.apache.zookeeper <br> KeeperException$NoAuthException: KeeperErrorCode = NoAuth | The following error can be seen when adding cluster nodes and is caused by entering invalid credentials to connect to ZooKeeper | Verify the ZooKeeper credentials you are entering.
RadiantConfigurationFactory: loading logging configuration from file /C:/radiantone/vds/config/logging/log4j2-default-console.json <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Error processing element appenders: CLASS_NOT_FOUND <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Error processing element loggers: CLASS_NOT_FOUND <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Error processing element loggers: CLASS_NOT_FOUND <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Error processing element root: CLASS_NOT_FOUND <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Unable to locate plugin type for appenders <br> 2017 - 04 - 18 09:13:41,697 Thread-28 ERROR Unable to locate plugin type for loggers <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for PatternLayout <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for appender <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for appenders <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for logger <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for logger <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for logger <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for logger <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for AppenderRef <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for root <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unable to locate plugin for loggers <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [d] <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [d] starting at position 16 in conversion pattern. <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [thread] 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [thread] starting at position 25 in conversion pattern. <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [level] <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [level] starting at position 35 in conversion pattern. <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [logger] <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [logger] starting at position 47 in conversion pattern. <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [msg] <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [msg] starting at position 54 in conversion pattern. <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized format specifier [n] <br> 2017 - 04 - 18 09:13:41,729 Thread-28 ERROR Unrecognized conversion specifier [n] starting at position 56 in conversion pattern. | Generally due to LOG4J2-673 "plugin preloading fails in shaded jar files" <br> https://issues.apache.org/jira/browse/LOG4J2 - 673 | These messages are related to a known issue in Log4J2 and can be ignored since they don’t impact the actual install.
In the installer wizard UI you might see a popup message that reads: Could not find any ZooKeeper server running. Please make sure you have at least one ZooKeeper running. | There is no ZooKeeper running on the target machine indicated in the URL. | Verify the ZooKeeper URL you are entering, and that ZooKeeper is running on that machine. To manually start ZooKeeper you can run: <RLI_HOME>/bin/ runZooKeeper.bat (.sh on Linux)
