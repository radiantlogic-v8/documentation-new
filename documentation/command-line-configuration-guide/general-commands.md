---
title: Command Line Configuration Guide
description: Command Line Configuration Guide
---

# General Commands

This chapter introduces the help and execfile commands.

## help

This command displays help information about a given command name and its usage.

**Usage:**
<br> `help <commandname>`

Command Arguments:
`<commandname>`
The name of the command. If no command is specified, all commands and their functions are
displayed.

## execfile

Sequentially runs all the commands in the file.

Create a file containing the commands to run (one command per line) and then pass the file name to the execfile command. If an error occurs with a command, none of the remaining commands are executed. If the remaining commands should be executed, even if there are errors returned from previous commands, use the -ignoreError command.

**Usage:**
<br>`execfile <file> [-ignoreError]`

**Command Arguments:**

`<file>`
<br> [Required] The name of the file(s) to be executed.

`ignoreError`
<br>Flag to indicate if remaining commands should be executed if an error is returned from a previous command.

>[!warning]
>The execfile command is not supported through REST (ADAP).
