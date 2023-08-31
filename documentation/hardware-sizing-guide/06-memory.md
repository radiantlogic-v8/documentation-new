---
title: Hardware Sizing Guide
description: Hardware Sizing Guide
---

# Memory

Adequate memory is key to optimum performance. As a general rule, the more memory available, the more directory information can be cached for quick access.

Estimating memory size required to run RadiantOne involves estimating the memory needed both for a specific RadiantOne configuration, and for the underlying system on which it runs. These two aspects are described in this section.

## Sizing Memory for RadiantOne

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
- By default, RadiantOne FID memory expands up to ¼ of the machine memory. For example, if the machine had 16 GB, then the memory would expand to use at most 4 GB. Once the memory requirements are known for your deployment, ensure the minimum and maximum memory allocations are the same to prevent the heavy process of heap resizing at runtime. You can indicate a minimum (-Xms) and maximum amount (-Xmx) value for the JVM process instead of leveraging this automated expansion. For details on configuring memory size, see the [RadiantOne Deployment and Tuning Guide](/deployment-and-tuning-guide/07-deployment-architecture/#setting-the-java-virtual-memory-size-for-the-radiantOne-service).
  
    >[!warning]
    >It is recommended to keep the maximum memory (-Xmx) under 32 GB to ensure the JVM uses compressed oops as a performance enhancement. If this is exceeded, the pointers switch to ordinary object pointers which grow in size, are more CPU-intensive and less efficient. Also, -Xms and -Xmx should be set to the same value to help avoid the performance-costly process of garbage collection from happening too frequently.

    >[!warning]
    >It is also important to note that the number of cached entries and indexed attributes configured for memory cache (if used) affect the RadiantOne FID memory usage. The number of cached entries is relevant for memory cache (entry and query). This is the number of entries to be stored in main memory. The default size is 5000 entries. The entry cache is populated as requests are sent to RadiantOne FID. This main memory stores the most recently used entries. Indexed attributes is relevant for memory cache (entry level). This is a list of indexed attributes. The default size is 1000 pages, which means there are, at most, 1000 index pages for each attribute you have indexed. For more details on memory cache, please see the RadiantOne Deployment and Tuning Guide.

- The memory requirements for persistent cache or Universal Directory (HDAP) stores varies depending on how many entries are stored and can be calculated with: `<size of LDIF file containing all entries> x 2 = <MEMORY>`

    E.G. 1M entries (~1KB each) = 1GB LDIF file x 2 = 2GB memory to store this in a Universal Directory (HDAP) store.

- If your deployment contains a lot of virtual views (a lot of metadata), ZooKeeper can run out of memory, especially during periods where additional cluster nodes are added and the existing configuration must be synchronized to the new nodes. To check the size of the ZooKeeper data, view the folder size located at <RLI_HOME>/apps/zookeeper/data/version-2. For large amounts of metadata (e.g. 3GB), ZooKeeper memory should be increased (e.g. -Xmx5g would increase it to 5GB). ZooKeeper memory size can be set in <RLI_HOME>/bin/advanced/runZooKeeperBlocking.bat file. An example of setting the memory to 5GB is shown below:

`"%RLI_JHOME%\bin\java" –Xmx5g -cp "%ZOO_CP%"`
<br> `"com.rli.zookeeper.commands.ZooKeeperServerWrapper"`
<br> `"%RLI_RHOME%\apps\zookeeper\conf\zoo.cfg"`

- The Task Scheduler requires approximately 1 GB to schedule tasks. The actual tasks themselves each run inside their own JVM. For cache initialization containing a large number of entries (e.g. 1 million) it is recommended you manually define the memory used by the task to at least 8GB. This speeds up the cache initialization. For more details on Tasks and how to tune the JVM, please see the [RadiantOne System Administration Guide](/sys-admin-guide/01-introduction/#tasks-tab).

You may use utilities such as sar on Linux systems or the Windows Task Manager to measure physical memory used by the RadiantOne processes.

## Sizing Memory for the Operating System

Estimating the base amount of memory needed to run the underlying operating system must be done empirically, as operating system memory requirements vary widely based on the specifics of the system configuration. You may use utilities such as sar on Linux systems or the Task Manager on Windows to measure memory use.

You should also allocate enough memory for general system overhead and normal administrative use. Ideally, you will allocate enough space for overhead so that the system avoids swapping pages in and out of memory while in production.

The system total memory needed by the operating system, can then be estimated as follows:


`Total = Base amount + Overhead amount`

## Sizing Total Memory

Given the amount of memory needed for RadiantOne plus the amount needed for the Operating System (OS) described in the previous sections, you can estimate the total memory needed.

`Total Memory = RadiantOne memory + OS memory`

Total memory is an estimate of the total memory needed, including the assumption that the system is dedicated to the RadiantOne, and includes estimated memory use for all other applications and services expected to run on the system.
