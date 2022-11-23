# Chapter 2: General Commands

This chapter introduces the help and execfile commands.

## help

This command displays help information about a given command name and its usage.

**Usage:**
<br> `help <commandname>`

Command Arguments:
<commandname>
The name of the command. If no command is specified, all commands and their functions are
displayed.

## execfile

Sequentially runs all the commands in the file.

Create a file containing the commands to run (one command per line) and then pass the file name to the execfile command.

**Usage:**
<br>`execfile <file>`

**Command Arguments:**
<file>
<br> The name of the file(s) to be executed.

><span style="color:red">**IMPORTANT NOTE – the execfile command is not supported through REST (ADAP).**
