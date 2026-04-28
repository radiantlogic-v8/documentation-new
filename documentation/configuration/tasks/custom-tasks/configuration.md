---
title: Custom Task Instance Configuration
description: Additional details about configuring a custom task instance
---
## Overview

This page provides a summary of the basic and advanced properties used to configure custom task instances:

### Basic Properties

| Property | Description |
|---|---|
| ***Task Name*** **(required)** | A name for the custom task. This will be the name displayed in the ***Task List***. It should be unique for easy identification. |
| ***Java Class Name*** **(required)** | The name of the uploaded Java class that contains the custom task logic. Select from the dropdown list of available classes. |
| ***Scheduled*** | If enabled, the task will run according to the specified ***Execution Interval***. If disabled, the task runs once immediately after creation. |
| **Execution Interval** | Specifies how often the task will run. For example, a value of *1h 0m 0s* will run the task once every hour. |
| <a id="arguments"></a>**Arguments** | A list of key-value pairs containing the name and value of the arguments required by the custom task implementation. The arguments will be processed by the *`readArguments`* method in the custom task Java class. |

An example of the filled out basic properties for a custom task instance:

![Custom task instance basic properties example](../global-settings/Media/01-task-instance-basic-properties.png)

In the image above:

- The display name of the task will be *writeContentToFile*
- The task will execute the *ArgumentsTest_MultiNode* class
- The task will be executed every 1 hour and 30 mins (i.e., every hour and a half)
- The task takes in two arguments:
  - `-f` with a value of `fileName.txt`
  - `-c` with a value of `content to write`

### Advanced Properties

| Property | Description |
|---|---|
| **Delete After Completion** | If enabled, the task will be removed after it finishes running and will not be visible in the ***Task List***. This does not apply to tasks in the *Scheduled* status. |
| **New JVM** | If enabled, the task runs in its own isolated process. This is recommended for tasks that are memory-intensive or long-running, so they don't impact the performance of IDDM. |
| **JVM Parameters** | Specify parameters used by the JVM, such as memory settings — for example, `-Xms1024m –Xmx1024m` allocates 1GB of memory to the task. Only valid if ***New JVM*** is enabled. |
