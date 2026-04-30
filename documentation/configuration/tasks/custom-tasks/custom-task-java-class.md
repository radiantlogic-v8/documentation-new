---
title: Writing a Custom Task Java Class
description: Learn how to write a Custom Task Java Class.
---

## Class-level Requirements

**Package:** The class must be in the `com.rli.scripts.tasks` package. Do not change the package declaration.

**File Name:** The Java file name must match the class name exactly. For example, a class named `MyCustomTask` must be in a file named `MyCustomTask.java`.

**Base Class:** The class must extend either `PerNodeCustomTask` or `PerClusterCustomTask`.

**Main Method:** A main method is required in every custom task class. See the **Main Method** section below for details.

## Methods to Implement

Your custom task class must override the following three methods:

### `processTask()`

This is where your task logic goes. It is called automatically when the task is executed.

A built-in logger is available for writing messages to the task log. Use `logger.info()`, `logger.warn()`, or `logger.error()` to log information that will be visible in the task **Logs** tab in the UI.

### `readArguments(String[] strings)`

This method receives the [arguments](../custom-tasks/configuration.md) that are configured when creating the task instance. Use it to parse and store argument values as instance variables so they can be used in `processTask()`.

The `strings` parameter is a flattened array of the key-value pairs defined in the **Arguments** section of the task instance form. For example, if you configured two arguments:

| Name | Value |
|---|---|
| -dn | o=example |
| -v | newValue |

The value of the `strings` parameter will be: ["-dn", "o=example", "-v", "newValue"].

It is good practice to validate that required arguments are present and throw an `IllegalArgumentException` if they are missing.

If your task does not require any arguments, you can leave this method empty.

### `getId()`

Returns an identifier for the task. This value is used internally to track and manage the task instance. This method should return a unique value for each instance of the task.

### Main Method

Every custom task class must include a main method with the following structure:

```java
public static void main(String[] args) {

    try {

        MyCustomTask task = new MyCustomTask();

        task.readArguments(args);

        task.process();

    } catch (Exception e) {

        e.printStackTrace();

        System.exit(1);

    }

}
```

Replace MyCustomTask with your class name. Do not modify the structure of this method. It must instantiate your class, call readArguments, and then call process in that order.

## Available Utilities

The following utilities are available for use in your custom task class:

* logger: A built-in logger for writing to the task log. Supports logger.info(), logger.warn(), logger.error(), and logger.debug().
* All standard Java 8 libraries can be imported and used.
* All classes available in jars in the $RLI_HOME/lib folder can be imported and used.

