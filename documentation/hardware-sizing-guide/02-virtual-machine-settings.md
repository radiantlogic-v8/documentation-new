---
title: Hardware Sizing Guide
description: Hardware Sizing Guide
---

# Virtual Machine Settings

All aspects in this guide should be considered when deploying RadiantOne on Virtual Machines (VMs). However, some VM-specific items to consider are described in this section.

## Memory Ballooning

Memory ballooning in the hypervisor should be disabled as it is a feature that can impact the throughput performance of RadiantOne. In typical deployments, the primary function of RadiantOne is processing end user authentication and authorization. The user experience is highly dependent on the efficient processing of these requests. To ensure the consistent availability of free memory assigned to RadiantOne FID by VMWare, it is highly recommended that Memory Ballooning be turned off for the Virtual Machines hosting RadiantOne. If Memory Ballooning is enabled and triggered, the EXSi Host may claim free memory from the Virtual Machine host causing subsequent authentication and authorization requests processed by RadiantOne to page to disk frequently, significantly reducing the processing throughput of the server and negatively impacting the end users.

## Memory Requirements

The memory requirements/allocation to the virtual machine must meet the minimum requirements. The memory requirements for RadiantOne are sometimes considered high for allocating to standard virtual machines and this is often a contributing factor to the decision made to go with “physical” or “virtual” hardware for the product deployment. The RadiantOne specifications recommends at least 16GB of RAM and it is not unusual to have a deployment with a higher amount of memory depending on the number of identities, complexity of the views and number of persistent caches.


`VM Memory (needed) = guest OS memory + JVM Memory where JVM Memory = JVM
Max Heap (-Xmx value) + Perm Gen (-XX:MaxPermSize) +
NumberOfConcurrentThreads * (-Xss)`


JVMs running on virtual machines have an active heap that must always be present in physical memory. Use the VMware vSphere® Client™ to set the reservation equal to the needed virtual machine memory.

`Reservation Memory = VM Memory = guest OS Memory + JVM Memory`

## Network Interface

One network interface (1GB or greater) of the Hypervisor should be dedicated to RadiantOne as low network latency and high network throughput are desired.

## vCPU

For performance-critical enterprise Java applications virtual machines in production, make sure that the total number of vCPUs assigned to all of the virtual machines does not cause greater than 80% CPU utilization on the ESX/ESXi host.

Do not oversubscribe to CPU cycles that you do not really need.

## Timekeeping

Time synchronization between cluster nodes is imperative! It is recommended to reduce the polling interval to 15 minutes. As timekeeping is different with virtual machines, please follow the recommendations made by the hypervisor vendor. Example, for VMWare:

[http://www.vmware.com/files/pdf/Timekeeping-In-VirtualMachines.pdf](http://www.vmware.com/files/pdf/Timekeeping-In-VirtualMachines.pdf)

Timekeeping can have an effect on Java programs if they are sensitive to accurate measurements over periods of time, or if they require a timestamp that is within an exact tolerance (such as a timestamp on a shared document or data item). VMware Tools contains features that are installable on the guest operating system to enable time synchronization. Use of those tools is recommended. The frequency of timer interrupts can also affect the performance of your Java application.

Synchronize the time on the ESX/ESXi host with an NTP source. Synchronize the time in the virtual machine’s guest operating system:

- For Linux guest operating systems use an external NTP source. See the preceding reference.
- For Windows guest operating systems use W32Time. Refer to your Windows administration guide for detailed information. Lower the clock interrupt rate on the virtual CPUs in your virtual machines by using a guest operating system that allows lower timer interrupts. Examples of such operating systems are RHEL 4.7 and later, RHEL 5.2 and later, and SUSE Linux Enterprise Server 10 SP2.

Use the Java features for lower resolution timing that are supplied by your JVM, such as the option for the Sun JVM on Windows guest operating systems: -XX:+ForceTimeHighResolution

You can also set the _JAVA_OPTIONS variable to this value on Windows operating systems using the technique given (useful in cases where you cannot easily change the Java command
line). The following is an example of how to set the Sun JVM option. To set the _JAVA_OPTIONS environment variable: Select Start > Settings > Control Panel > System > Advanced > Environment Variables. Select New under System Variables. The variable name is _JAVA_OPTIONS. The variable value is -XX:+ForceTimeHighResolution. Restart the guest operating system to propagate the variable. For Windows guest operating systems that use an SMP HAL, avoid using the /usepmtimer option in the boot.ini system configuration.

## Vertical Scalability

Virtual machines with a guest OS that supports hot add CPU and hot add memory can take advantage of the ability to change the virtual machine configuration at runtime without any interruption to virtual machine operations. This is particularly useful when you are trying to increase the ability of the virtual machine to handle more traffic.

## Horizontal Scalability

When creating clusters, enable VMware HA and VMware DRS:

VMware HA – Detects failures and provides rapid recovery for the VM running in a cluster. Core functionality includes host monitoring and VM monitoring to minimize downtime.

VMware DRS – Enables VMware vCenter Server™ to manage hosts as an aggregate pool of resources. Cluster resources can be divided into smaller pools for users, groups, and virtual machines. It enables VMware vCenter™ to manage the assignment of virtual machines to hosts automatically, suggesting placement when virtual machines are powered on, and migrating running virtual machines to balance loads and enforce allocation policies.

