# RadiantOne Hardware Sizing Guide

## Introduction Contents

Hardware sizing is a critical component of directory service planning and deployment. When sizing hardware, both the amount of memory and the amount of local disk space available are of key importance.

RadiantOne runs as a multi-threaded Java program, and is built to scale across multiple processors. In general, the more processing power available, the better. However, in practice, adding memory, faster disks, or faster network connections can enhance performance more than additional processors.

When deploying a cluster, nodes must be running on hardware that is configured for optimal redundancy and highly reliable connectivity between the cluster nodes/machines.

The information in this guide provides a basis for capacity planning that helps ensure that the virtual directory server hardware is adequate for handling peak loads. The following minimum requirements must be met and might be inadequate for a production environment. For best results, install and configure a test system with a subset of entries representing those used in production. You can then use the test system to approximate the behavior of the production server.


- CPU Cores - minimum 2 cores.
- Machine Memory - minimum 15GB.
- Disk Throughput - minimum 100MB/sec.
- Disk Space - minimum 20GB.
- DNS resolution - all hostnames must be resolvable.
- Zookeeper network latency - maximum 15ms.
- Zookeeper read throughput - minimum 25MB/sec.
- Zookeeper write throughput - minimum 5MB/sec.
- Linux Open File Descriptors - minimum 48k.
- Linux Maximum resident set size - requires unlimited.
- Linux Memory Map Areas for processes - minimum 256KB.
- Linux Swappiness - swap to be disabled or swappiness <=20.
- Linux Maximum amount of virtual memory available to a process launched by the user associated with the RadiantOne installation - requires unlimited.

## Virtual Machine Settings

All aspects in this guide should be considered when deploying RadiantOne on Virtual Machines (VMs). However, some VM-specific items to consider are described in this section.

### Memory Ballooning

Memory ballooning in the hypervisor should be disabled as it is a feature that can impact the throughput performance of RadiantOne. In typical deployments, the primary function of RadiantOne is processing end user authentication and authorization. The user experience is highly dependent on the efficient processing of these requests. To ensure the consistent availability of free memory assigned to RadiantOne FID by VMWare, it is highly recommended that Memory Ballooning be turned off for the Virtual Machines hosting RadiantOne. If Memory Ballooning is enabled and triggered, the EXSi Host may claim free memory from the Virtual Machine host causing subsequent authentication and authorization requests processed by RadiantOne to page to disk frequently, significantly reducing the processing throughput of the server and negatively impacting the end users.

### Memory Requirements

The memory requirements/allocation to the virtual machine must meet the minimum requirements. The memory requirements for RadiantOne are sometimes considered high for allocating to standard virtual machines and this is often a contributing factor to the decision made to go with “physical” or “virtual” hardware for the product deployment. The RadiantOne specifications recommends at least 16GB of RAM and it is not unusual to have a deployment with a higher amount of memory depending on the number of identities, complexity of the views and number of persistent caches.

```
VM Memory (needed) = guest OS memory + JVM Memory where JVM Memory = JVM
Max Heap (-Xmx value) + Perm Gen (-XX:MaxPermSize) +
NumberOfConcurrentThreads * (-Xss)
```

JVMs running on virtual machines have an active heap that must always be present in physical memory. Use the VMware vSphere® Client™ to set the reservation equal to the needed virtual machine memory.

```
Reservation Memory = VM Memory = guest OS Memory + JVM Memory
```

### Network Interface

One network interface (1GB or greater) of the Hypervisor should be dedicated to RadiantOne as low network latency and high network throughput are desired.

### vCPU

For performance-critical enterprise Java applications virtual machines in production, make sure that the total number of vCPUs assigned to all of the virtual machines does not cause greater than 80% CPU utilization on the ESX/ESXi host.

Do not oversubscribe to CPU cycles that you do not really need.

### Timekeeping

Time synchronization between cluster nodes is imperative! It is recommended to reduce the polling interval to 15 minutes. As timekeeping is different with virtual machines, please follow the recommendations made by the hypervisor vendor. Example, for VMWare:

[http://www.vmware.com/files/pdf/Timekeeping-In-VirtualMachines.pdf](http://www.vmware.com/files/pdf/Timekeeping-In-VirtualMachines.pdf)
[http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&exte](`http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=`)

Timekeeping can have an effect on Java programs if they are sensitive to accurate measurements over periods of time, or if they require a timestamp that is within an exact tolerance (such as a timestamp on a shared document or data item). VMware Tools contains features that are installable on the guest operating system to enable time synchronization. Use of those tools is recommended. The frequency of timer interrupts can also affect the performance of your Java application.

Synchronize the time on the ESX/ESXi host with an NTP source. Synchronize the time in the virtual machine’s guest operating system:

- For Linux guest operating systems use an external NTP source. See the preceding reference.
- For Windows guest operating systems use W32Time. Refer to your Windows administration guide for detailed information. Lower the clock interrupt rate on the virtual CPUs in your virtual machines by using a guest operating system that allows lower timer interrupts. Examples of such operating systems are RHEL 4.7 and later, RHEL 5.2 and later, and SUSE Linux Enterprise Server 10 SP2.

Use the Java features for lower resolution timing that are supplied by your JVM, such as the option for the Sun JVM on Windows guest operating systems: -XX:+ForceTimeHighResolution

You can also set the _JAVA_OPTIONS variable to this value on Windows operating systems using the technique given (useful in cases where you cannot easily change the Java command
line). The following is an example of how to set the Sun JVM option. To set the _JAVA_OPTIONS environment variable: Select Start > Settings > Control Panel > System > Advanced > Environment Variables. Select New under System Variables. The variable name is _JAVA_OPTIONS. The variable value is -XX:+ForceTimeHighResolution. Restart the guest operating system to propagate the variable. For Windows guest operating systems that use an SMP HAL, avoid using the /usepmtimer option in the boot.ini system configuration.

### Vertical Scalability

Virtual machines with a guest OS that supports hot add CPU and hot add memory can take advantage of the ability to change the virtual machine configuration at runtime without any interruption to virtual machine operations. This is particularly useful when you are trying to increase the ability of the virtual machine to handle more traffic.

### Horizontal Scalability

When creating clusters, enable VMware HA and VMware DRS:

VMware HA – Detects failures and provides rapid recovery for the VM running in a cluster. Core functionality includes host monitoring and VM monitoring to minimize downtime.

VMware DRS – Enables VMware vCenter Server™ to manage hosts as an aggregate pool of resources. Cluster resources can be divided into smaller pools for users, groups, and virtual machines. It enables VMware vCenter™ to manage the assignment of virtual machines to hosts automatically, suggesting placement when virtual machines are powered on, and migrating running virtual machines to balance loads and enforce allocation policies.

## Disk Speed and Space

The Lucene-based storage is heavy on I/O when indexing because segments are merged and optimized generating a lot of I/O. Solid State Drives (SSD) are recommended, and if used on Linux, you should set the I/O scheduler to deadline or noop.

Disk performance is also critical for ZooKeeper which must have low latency disk writes in order to perform optimally. You can use autopurge.purgeInterval and autopurge.snapRetainCount to automatically cleanup ZooKeeper data and reduce maintenance overhead.

Disk mirroring is strongly advised (RAID configuration). Avoid using NAS due to latency issues and single point of failure.

On Windows systems, format drives as NTFS rather than FAT. FAT is not supported for use with the Virtual Directory Server. NTFS allows access controls to be set on files and directories and doesn’t have the file size limitations present in FAT.

Minimum recommended disk space is 500 GB. Depending on your deployment architecture, a variety of different local storages might be used and can consume varying amounts of disk
space.

The recommended minimum data transfer rate is 150 MB/sec.

See Table 1 below for details on how to estimate disk space requirements.

Table 1: Recommended Disk Space

| Local Store Usage | Free Local Disk Space | 
|------------|------------|
| **Universal Directory (HDAP stores)** <br> RadiantOne offers a scalable local storage that can store any entries. This is known as a Universal Directory module | Calculated by multiplying the size of the LDIF file (containing all entries) by 2. As an example, 1,000,000 entries approximately 1KB in size = 1 GB x 2= 2 GB disk space  
| **Persistent Cache (local)** <br> Persistent cache is actually the cache image stored on disk. The cache image is stored in the local RadiantOne FID where it is configured. With persistent cache, RadiantOne FID can offer a guaranteed level of performance because the underlying data source(s) do not need to be queried and once the server starts, the cache is ready without having to “prime” with an initial set of queries. | Calculated by multiplying the size of the LDIF file (containing all entries) by 2. As an example, 1,000,000 entries approximately 1KB in size = 1 GB x 2= 2 GB disk space.
| **Changelog** <br> The changelog is the recommended approach for other processes to detect changes that have happened to virtual entries. <br> If enabled (which it is by default), the change log stores all modifications made to any entry in the virtual namespace including entries that are stored in persistent cache. The contents of the change log can be viewed below the cn=changelog suffix in the directory. | Calculated by multiplying the size of the LDIF file (containing all entries) by 2. As an example, 1,000,000 entries approximately 1KB in size = 1 GB x 2= 2 GB disk space. <br> To prevent the changelog growing forever (and filling up disk space), it is recommended to set a Max Age value on the Main Control Panel >Settings tab > Logs section > Changelog sub-section. 
| **Replication Journal** <br> If inter-cluster replication is enabled, a replication journal stores changes that happen on the configured naming context. The replication journal is associated with the default data source defined as replicationjournal and root naming context named cn=replicationjournal. Other clusters can pick up changes from the replication journal to update their local image. If you have not deployed multiple clusters, then the replication journal is not used. | Calculated by multiplying the approximate size of the entries by 2. As an example, 1,000,000 changed entries approximately 1KB in size = 1 GB x 2= 2 GB disk space. <br> By default all entries in the replication journal older than 3 days are removed. Therefore, when sizing disk space you should estimate how many changes are expected to happen during a three day period and multiply the total size of these entries by 2.
| **Local Journal** <br> If multi-master inter-cluster replication is enabled (for Universal Directory/HDAP stores) and a site is unable to connect to the replication journal to log a change, the change is temporarily logged locally into cn=localjournal. Changes are queued in the local journal until the connection to the replication journal can be re-established. | Calculated by multiplying the approximate size of the entries by 2. As an example, 1,000,000 changed entries approximately 1KB in size could not be published to the replication journal due to connection problems = 1 GB x 2= 2 GB disk space.  <br> By default, changes remain in the cn=localjournal for three days and after are automatically removed. Therefore, when sizing disk space you should estimate how many changes are expected to happen during a three day period (assuming all of these changes couldn’t be published to the replication journal during this time) and multiply the total size of these entries by 2.
| **Tombstone** <br> If inter-cluster replication is enabled, a “tombstone” storage stores all deleted entries that happen on the configured naming context. cn=tombstone is the naming context that stores these entries. | Calculated by multiplying the approximate size of the deleted entries by 2. As an example, 1,000,000 deleted entries approximately 1KB in size = 1 GB x 2= 2 GB disk space. <br> By default, deleted entries remain in the cn=tombstone for three days and after are automatically removed. Therefore, when sizing disk space you should estimate how many delete operations are expected to happen during a three day period and multiply the total size of these entries by 2.
| **Cache Refresh Log** <br> Update activity performed against a persistent cache is logged below a branch in the virtual namespace named cn=cacherefreshlog. This storage is always enabled for persistent cached branches and the “content”/log level can be set to all, status, or just errors. The level is set on the Main Control Panel > Settings Tab > Logs section > Changelog sub-section, Persistent Cache Refresh Log Level parameter. | Calculated by multiplying the approximate size of the cached entries by 2. As an example, 1,000,000 changed persistent cache entries approximately 1KB in size = 1 GB x 2= 2 GB disk space. <br> The size and number of the entries logged into the cn=cacherefreshlog varies depending on log level. <br> If all log level is selected, the cn=cacherefreshlog branch contains all requests (successful or not) to refresh the persistent cache. This includes information about the exact changes (what information changed). The attribute named ‘changes’ contains the attribute level changes. <br> The difference between status level and all level is that all only logs entries that have actually changed whereas status level logs all changes coming into the persistent cache whether the actual entry has changed or not. <br> Log level of *error* only logs entries that fail to be updated in the persistent cache.
| **ZooKeeper snapshots** <br> ZooKeeper maintains snapshots and transaction logs of its configuration. A new snapshot is created every time ZooKeeper starts and when zookeeper.snapCount is reached (dictated by the Java system property: zookeeper.snapCount). By default, a maximum of 3 snapshots are saved. The snapshots are saved here: <RLI_HOME>\apps\zookeeper\data\version-2 folder. The number of snapshots created can temporarily exceed 3 due to the autopurge.purgeInterval which is set to 3 hours by default. If there are many transactions (configuration changes) during this 3 hour timeframe, there can be a lot of snapshots and transaction log files created. For example, if you use ICS, and the connectors are capturing many changes, the number of writes to ZooKeeper that are performed (to write last processed change number...etc.) can be quite high resulting in exceeding the 10,000 transaction snapCount and more snapshots and transaction logs being created. This could easily consume several GB of disk space so must be taken into account. | Keep an eye on the size of the <RLI_HOME>\apps\zookeeper\data\version-2 folder. <br> You can reduce the number of files accumulating in this location by reducing the purge interval (autopurge.purgeInterval in <RLI_HOME>\apps\zookeeper\conf\zoo.cfg). Restart ZooKeeper after making changes to this file. If RadiantOne is deployed in a cluster, stop and restart ZooKeepers on all nodes.

Additional disk space required for log files is calculated separately and recommendations can be seen in Table 2 below.

Volume for logs depends on how RadiantOne is configured. Please refer to the RadiantOne Logging and Troubleshooting Guide for details on configuring logging.

Total disk space recommended = (disk space for entries) + (disk space for logs).

Table 2: Recommended disk space for log files

| Log File Name | Free Local Disk Space
|------------|------------|
| **vds_server.log** <br> This log file is zipped (to reduce the size) and archived when it reaches the rollover size. The maximum number of log files to archive and rollover size are configurable from the Main Control Panel > Settings tab > Logs section > Log Settings sub-section. Since this log is archived when it reaches the rollover size, you could have more than one archived log file for each day – syntax of these files is vds_server_`<year>-<month>-<day>_<hour>-<minute>-<second>`.log). | This varies depending on how many days of log files you would like to keep. 2 GB worth of log files could be generated daily (possibly more if you have increased the number of archived files to keep).
| **vds_server_access.log** <br> This log file is archived when the size reaches the rollover size. Archived files are kept for 30 days by default. These settings are configurable from the Main Control Panel > Settings tab > Logs section > Access Logs sub-section. <br> The log output format can be text and/or CSV. Text is the default. If CSV is also enabled, the settings configured on the Main Control Panel -> Settings tab -> Logs section -> Access Logs sub-section are applicable to it as well. | This varies depending on how long you would like to keep archived logs and how many log output formats are used. Amount of log files generated daily depends on if both text and CSV formats are configured.
| **Other miscellaneous log files related to Jetty and VRS (found in <RLI_HOME>/vds_server/logs), ZooKeeper (found in <RLI_HOME>/logs/zookeeper) and synchronization/persistent cache refresh (found in <RLI_HOME>/r1syncsvcs/log).** | Add at least 20 GB 

## Linux Memory Map Areas

Check the value for the number of discrete mapped memory areas with the following command:

sysctl vm.max_map_count

The default value is 65536.

For most deployments, the default is too low. It is recommended to increase it to 262144 in /etc/sysctl.conf file. This file contains the maximum number of memory map areas a process may have.

## Linux User Limits

For Linux, the number of file descriptors should be set to at least 65536. Check the amount with:

```
$ ulimit -n
```

Confirm that ulimit -v and -u return unlimited to prevent problems with the amount of virtual
address space that can be allocated.

Also, set shell limits for the Max Number of Processes. These steps are described below.

1. As root, open the system's /etc/security/limits.conf file.
2. Add two lines that set the hard and soft limits for the number of processes (nproc) for the Directory Server user. The soft limit sets how many processes the user has available by default; the user can manually adjust that setting until they hit the hard limit.

```
user soft nproc 2047

user hard nproc 16384
```

><span style="color:red">**IMPORTANT NOTE - Do not set the hard limit for the Directory Server user equal to (or higher than) the maximum number of file descriptors assigned to the system itself in /proc/sys/fs/file-max. If the hard limit is too high and the user users all of those file descriptors, then the entire system runs out of file descriptors.**

## Linux Swap Space

Swap space in Linux is used when the amount of physical memory (RAM) is full. If the system needs more memory resources and the RAM is full, inactive pages in memory are moved to the swap space. While swap space can help machines with a small amount of RAM, it should not be considered a replacement for more RAM. Swap space is located on hard drives, which have a slower access time than physical memory. This means RadiantOne performance is impacted if swap space starts to be used.

The setting that controls how often the swap file is used is called swappiness. A swappiness setting of zero means that the disk will be avoided unless absolutely necessary (you run out of memory). Swap should be disabled if possible (/etc/fstab) or configured to prevent swapping under normal usage (set vm.swappiness to a value <=20 which is the percentage of RAM left before the system starts to swap). Reboot your system for the change to take effect.

## Network Capacity

RadiantOne is a network-intensive application, and for each client application request, it may send multiple operations to different data sources. Make sure the network connections between RadiantOne and your backend data sources are fast, with plenty of bandwidth and low latency. Also make sure the connections between client applications and the RadiantOne service can handle the amount of traffic you expect.

Testing has demonstrated that 100 Mbit Ethernet may be sufficient for classic (active/active or active/passive architectures) depending on the maximum throughput expected. You may estimate theoretical maximum throughput as follows:

max. throughput = max. entries returned/second x average entry size

Imagine for example that a Directory Server must respond to a peak of 6000 searches per second for which it returns 1 entry each with entries having average size of 2000 bytes, then the theoretical maximum throughput would be 12 MB, or 96 Mbit. 96 Mbit is likely to be more than a single 100 Mbit Ethernet adapter can provide. Actual observed performance may vary.

If you expect to perform multi-master replication (replication across clusters, or replication across active/active or active/passive classic architectures) over a wide area network, ensure the connection provides sufficient throughput with minimum/low latency and near-zero packet
loss.

><span style="color:red">**IMPORTANT NOTE - If you intend to deploy RadiantOne in a cluster, on the same network for load balancing purposes, ensure the network infrastructure can support the additional load generated. 1 Gb minimum (this is a basic network card speed) between the cluster nodes is required. It is preferable to have the nodes connected to the same network switch. If you are deploying RadiantOne cluster nodes on Virtual Machines (VM), ensure the network capacity allocated to the VMs is 1 Gb minimum.**

If you intend to support high update rates for replication in a wide area network environment, ensure through empirical testing that the network quality and bandwidth meet your requirements for replication throughput. When deploying multiple clusters or a classic active/active or active/passive architecture (clusters or individual servers across different networks), to ensure optimal inter-cluster/multi-master replication speeds, 1 Gb is preferred.

### Sizing for SSL

By default, support for the Secure Sockets Layer (SSL) protocol is implemented in RadiantOne.

Using the software-based SSL implementation may have significant negative impact on the Directory Server performance. Running the directory in SSL mode may require the deployment of several directory replicas to meet overall performance requirements.

## Memory

Adequate memory is key to optimum performance. As a general rule, the more memory available, the more directory information can be cached for quick access.

Estimating memory size required to run RadiantOne involves estimating the memory needed both for a specific RadiantOne configuration, and for the underlying system on which it runs. These two aspects are described in this section.

### Sizing Memory for RadiantOne

The minimum machine memory to deploy RadiantOne (up to a total of 1 million entries of roughly 1KB in size stored in either persistent cache or in a local Universal Directory/HDAP store) is 16 GB. Keep in mind, for persistent cached views, computations and joins that might need to happen prior to caching often dictate a requirement of more than 16 GB. To provide another example, 20 million entries (~1 KB in size) stored in Universal Directory (HDAP store) would require 64 GB of RAM on the machine (not specifically allocated to the RadiantOne FID JVM).

Table 3 summarizes the values used for the calculations in this section.

Table 3: Default Memory Allocation

| RadiantOne Component | Description | Default Memory
|------------|------------|------------|
| **RadiantOne FID** | Includes: Correlation engine, In-memory cache(query and entry), Interception scripts, Web services (REST, SCIM,SPML, DSML), Join Engine, Security (ACL), Computed Attributes. | 1 GB, automatically expanding up to ¼ of machine memory <br> *See additional comments below.
| **ZooKeeper** | Responsible for cluster orchestration and configuration management. | 3 GB <br> *See additional comments below.
| **Universal Directory (HDAP stores)** | Storage for persistent cache, extension attribute and Universal Directory stores including cn=changelog and cn=replicationjournal. | Calculated based on: <Size of LDIF file> x 2 <br> Note - Lucene leverages the OS file system cache for its disk-based data. Java heap size is not applicable. <br> When the RadiantOne platform is deployed only with the Universal Directory module, on machines with large amounts of memory (e.g. 32GB), it is recommended to set a max JVM (-Xmx) for the RadiantOne FID service instead of letting it expand to ¼ of the available memory. This leaves more memory for the Universal Directory (HDAP) stores to ensure optimal performance.
| **Tasks Scheduler** | Schedules tasks. | 1 GB
| **Tasks** | Activities that are processed as tasks are: <br> Exporting to LDIF, Importing from LDIF, Login analysis (initiated from the virtual identity wizard), Initializing a persistent cache or Universal Directory (HDAP) store, Re- indexing a persistent cache or Universal Directory (HDAP) store, and the default RadiantOne FID monitoring task. | 512 MB, expanding up to ¼ of the machine memory. <br> *See additional comments below.
| **Jetty Application Server** | Hosts the Main Control Panel and the Server Control Panels. | 512 MB
| **Real Time Persistent Cache Refresh Agent** | Deploys and manages the real-time persistent cache refresh connectors. | 1 GB <br> The memory allocation is configured in <RLI_HOME>/bin/advanced/ start_cacherefresh_realtime_agent.bat/.sh <br> - Xms512m -Xmx | 

In addition to the items listed in the table, to estimate approximate machine memory size, you should be aware of the following:

- The RadiantOne FID uses memory mainly to hold information that is being processed. Complex aggregations for processing some virtual directory requests against multiple data sources may temporarily use extra memory. You should keep this in consideration in addition to the estimates provided in this section.
- By default, RadiantOne FID memory expands up to ¼ of the machine memory. For example, if the machine had 16 GB, then the memory would expand to use at most 4 GB. Once the memory requirements are known for your deployment, ensure the minimum and maximum memory allocations are the same to prevent the heavy process of heap resizing at runtime. You can indicate a minimum (-Xms) and maximum amount (-Xmx) value for the JVM process instead of leveraging this automated expansion. For details on configuring memory size, see the RadiantOne Deployment and Tuning Guide.
  
    <span style="color:red">**IMPORTANT NOTE – It is recommended to keep the maximum memory (-Xmx) under 32 GB to ensure the JVM uses compressed oops as a performance enhancement. If this is exceeded, the pointers switch to ordinary object pointers which grow in size, are more CPU-intensive and less efficient.**

    <span style="color:red">**It is also important to note that the number of cached entries and indexed attributes configured for memory cache (if used) affect the RadiantOne FID memory usage. The number of cached entries is relevant for memory cache (entry and query). This is the number of entries to be stored in main memory. The default size is 5000 entries. The entry cache is populated as requests are sent to RadiantOne FID. This main memory stores the most recently used entries. Indexed attributes is relevant for memory cache (entry level). This is a list of indexed attributes. The default size is 1000 pages, which means there are, at most, 1000 index pages for each attribute you have indexed. For more details on memory cache, please see the RadiantOne Deployment and Tuning Guide.**

- The memory requirements for persistent cache or Universal Directory (HDAP) stores varies depending on how many entries are stored and can be calculated with: `<size of LDIF file containing all entries> x 2 = <MEMORY>`

    E.G. 1M entries (~1KB each) = 1GB LDIF file x 2 = 2GB memory to store this in a Universal Directory (HDAP) store.

- If your deployment contains a lot of virtual views (a lot of metadata), ZooKeeper can run out of memory, especially during periods where additional cluster nodes are added and the existing configuration must be synchronized to the new nodes. To check the size of the ZooKeeper data, view the folder size located at <RLI_HOME>/apps/zookeeper/data/version-2. For large amounts of metadata (e.g. 3GB), ZooKeeper memory should be increased (e.g. -Xmx5g would increase it to 5GB). ZooKeeper memory size can be set in <RLI_HOME>/bin/advanced/runZooKeeperBlocking.bat file. An example of setting the memory to 5GB is shown below:

```
"%RLI_JHOME%\bin\java" –Xmx5g -cp "%ZOO_CP%"
"com.rli.zookeeper.commands.ZooKeeperServerWrapper"
"%RLI_RHOME%\apps\zookeeper\conf\zoo.cfg"
```

- The Task Scheduler requires approximately 1 GB to schedule tasks. The actual tasks themselves each run inside their own JVM. For cache initialization containing a large number of entries (e.g. 1 million) it is recommended you manually define the memory used by the task to at least 8GB. This speeds up the cache initialization. For more details on Tasks and how to tune the JVM, please see the System Administration Guide.

You may use utilities such as sar on Linux systems or the Windows Task Manager to measure physical memory used by the RadiantOne processes.

### Sizing Memory for the Operating System

Estimating the base amount of memory needed to run the underlying operating system must be done empirically, as operating system memory requirements vary widely based on the specifics of the system configuration. You may use utilities such as sar on Linux systems or the Task Manager on Windows to measure memory use.

You should also allocate enough memory for general system overhead and normal administrative use. Ideally, you will allocate enough space for overhead so that the system avoids swapping pages in and out of memory while in production.

The system total memory needed by the operating system, can then be estimated as follows:

```
Total = Base amount + Overhead amount
```

### Sizing Total Memory

Given the amount of memory needed for RadiantOne plus the amount needed for the Operating System (OS) described in the previous sections, you can estimate the total memory needed.

```
Total Memory = RadiantOne memory + OS memory
```

Total memory is an estimate of the total memory needed, including the assumption that the system is dedicated to the RadiantOne, and includes estimated memory use for all other applications and services expected to run on the system.


