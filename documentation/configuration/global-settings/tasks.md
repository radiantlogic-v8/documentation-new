---
title: Tasks
description: Learn how to manage tasks.
---

## Overview

When you perform various actions in the tools or wizards, a notification appears alerting you that the task has been defined and added to the scheduler. These tasks can be viewed and updated in the Control Panel > Manage > Tasks. You can define a task as re-occurring (scheduled) in addition to setting the execution interval. You can also configure the JVM parameters for tasks that run inside their own dedicated JVM.

![Managing Tasks](../Media/tasks.jpg)
 
The following operations are considered tasks and generate an event in the Task Scheduler when they occur: 
-	Initializing a persistent cache 
-	Initializing a RadiantOne Directory store 
-	Re-indexing a persistent cache
-	Exporting entries to an LDIF file
-	Importing entries from an LDIF file
-	Login Analysis (initiated from the Global Identity Builder)

## Task Scheduler Configuration

Task Scheduler parameters can be modified in the *Configuration Settings* in the Task Scheduler section. 

By default, each task executes in its own dedicated JVM. If the option “Dedicated JVM” is not toggled on in the specific task configuration, then the task executes inside the JVM of the scheduler. Users can customize the default JVM parameters to allow more memory, or change the performance settings. However, tuning the JVM of the task scheduler is less important than tuning the dedicated JVM for the individual task. For a full list of possible behavioral and performance options, please see the link below.

http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html

You can specify the number of days that completed tasks are kept on the task list for users to see. For example, if you set the parameter to “10 days” then after 10 days all of the tasks with a status of “Finished” are deleted from the system. 

## Managing Tasks 

When actions are processed as tasks, they appear in the Task List section, with information about the task displayed. The task list can be filtered by: All, Scheduled, Not Scheduled, or Terminated using the *Filter By* drop-down list. 
Tasks can be managed with the inline buttons for: *Task Details*, *Edit Task*, and *Start Task*. 

![Sample Task List](../Media/task-list.jpg)
 
### Task Details

Task Details displays two tabs showing the PROPERTIES and LOGS. The task log can also be downloaded from the LOGS tab.

### Editing Tasks

To edit a task, click the pencil icon. The Task Configuration menu displays all task components. The name and status are shown, but cannot be changed. To make the task non-recurring (the task no longer repeats) toggle off the *SCHEDULE* option, the task runs one final time and then the status automatically changes to “Finished”. The execution interval (the frequency at which the task is executed) can be modified by changing the hours, minutes, and second boxes.

By default, all tasks run in their own dedicated JVM and the memory allocated for the task automatically expands up to ¼ of the total machine memory. For example, if the machine where RadiantOne is installed has 16 GB of RAM, the task memory expands up to 4 GB to process a task. If you prefer, you can define a max Java heap size in the JVM parameters instead of leveraging this default expansion. Other custom settings can be entered in the JVM Parameters as well. For a full list of possible behavioral and performance options, please see the link below.

http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html

If “Dedicated JVM” is toggled off, the task runs inside the JVM of the Task Scheduler. If it is toggled on, the task runs inside its own JVM and you can specify JVM parameters.

Click **SAVE** before closing out of the task configuration screen to save the changes.

![Task Configuration](Media/task-config.jpg)

### Running Tasks

To manually start a task, click the *Start Task* button inline with the task.

## Custom Tasks

In addition to the built-in tasks, you can create and configure custom tasks to support specialized operations.

Custom tasks allow you to upload Java classes and create scheduled or ad-hoc task instances that execute custom logic in your Radiant Logic deployment. Task output is typically written to files in the vds_server/custom directory.

### Uploading and Running a Custom Task

To upload and run a custom task, follow these steps:

1. Navigate to the Tasks page and click Upload Custom Java Class.

  ![Upload button](../Media/custom-java.png "Upload button")

2. Select your Java class file and click Upload.  
   - If you upload a class with the same name as an existing one, the existing class will be replaced.

3. After the upload, you may see a warning indicating that services must be restarted for the new class to take effect.  
   - Restart your Identity Data Management instance via the Environment Operations Center before proceeding.

     ![EOC restart UI](../Media/custom-java.png "EOC restart UI]")

4. Click Create Task Instance. In the form that appears, complete all required fields.

  ![Create task button](../Media/create-task.png "Create task button")

5. Ensure the Java Class Name matches the name of the class you uploaded.

6. Configure the task schedule to define when and how often the task should run.  
   - If no schedule is defined, the task runs as a one-time operation.

7. In the Arguments field, provide any parameters expected by the readArguments method in your Java class.

8. Under Advanced Settings, you can enable or disable additional task options as needed:
   - Run on Error: Runs the task even if it previously failed.
   - Delete after completion: Deletes the task after it finishes running.
   - New JVM: Runs the task in a separate JVM. You can specify JVM parameters, such as memory settings (for example, -Xms1024m -Xmx1024m).

9. Review the configuration details and click Save.

The task will run according to the schedule you specified.


