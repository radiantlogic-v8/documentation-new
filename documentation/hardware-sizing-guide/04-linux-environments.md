---
title: Hardware Sizing Guide
description: Hardware Sizing Guide
---

# Linux Environments

This section covers memory map areas, user limits, and swap space. 

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

>[!warning]
>Do not set the hard limit for the Directory Server user equal to (or higher than) the maximum number of file descriptors assigned to the system itself in /proc/sys/fs/file-max. If the hard limit is too high and the user users all of those file descriptors, then the entire system runs out of file descriptors.

## Linux Swap Space

Swap space in Linux is used when the amount of physical memory (RAM) is full. If the system needs more memory resources and the RAM is full, inactive pages in memory are moved to the swap space. While swap space can help machines with a small amount of RAM, it should not be considered a replacement for more RAM. Swap space is located on hard drives, which have a slower access time than physical memory. This means RadiantOne performance is impacted if swap space starts to be used.

The setting that controls how often the swap file is used is called swappiness. A swappiness setting of zero means that the disk will be avoided unless absolutely necessary (you run out of memory). Swap should be disabled if possible (/etc/fstab) or configured to prevent swapping under normal usage (set vm.swappiness to a value <=20 which is the percentage of RAM left before the system starts to swap). Reboot your system for the change to take effect.

