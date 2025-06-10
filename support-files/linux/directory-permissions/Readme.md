# Creation
This directory permissions script was created using GitHub Copilot.

# Overview
When using QNAP QTS, QNAP has disabled the default admin account. This is good. However, QNAP has not adjusted their software to stop using the default admin account and use the one created during initialization.
This results in a lot of services creating files and directories with the "admin" user as the owner. 
Many times the administrators group is not given adequate permissions for accessing these directories and files.
One example is Container Station which creates the directories for volumes. You're supposed to be able to access these volumes from the host, but no one except for the disabled admin user has access.
I decided to test out GitHub Copilot by getting it to make me a script that would set the permissions of the specified directories for the specified groups



# Prompts Used To Prompt the AI

## First Pass
Please write me a linux bash script that modifies directory permissions recursively and base it on the following criteria:
- reads one of more full directory paths from a file called "paths.txt".
- reads a linux security group name from a file called "group.txt".
- reads desired permissions from a file called "permissions.txt".
- the permissions in the file permissions.txt will use the following words: "read", "write", and "execute".
- one permission per line in this file.
- there will be a '+' symbol or a '-' symbol in front of each permission.
- The + symbol means to add the specified permission to the specified directories.
- The - symbol means to remove the specified permission to the specified directories.
- provide the ability to optionally specify the paths, the group, and the permissions via command line argument to the script.
- provide the ability to optionally specify the paths, group, and permissions via environment variables to the script.
- The command line parameters have the highest precedence. This means that if command line parameters are detected, do not try to read from files or environment variables.
- Environment variables have the second highest precedence. This means that command line parameters are higher precedence. However, reading from files is lower precedence.
- Only try to read from files if no command line parameters are passed and no environment variables are found
- The script should output messages to standard out that adequately indicate each step of the process as it's being executed.
- Add appropriate comments within the script file to document the purpose of each line of code and/or each block of code.

The environment variables should be called "MDP_PATHS", "MDP_GROUP", and "MDP_PERMISSIONS".
The script will be called "mod_directory_permissions.sh".
Please also provide examples of how to use this script via the file approach, the command line approach, and the environment variable approach.

## Second Pass
please add functionality to print the usage options if the script is called with the "--help" argument or an error in processing input is encountered. Do not replace the error message in the case of an error, but additionally add the usage information. Also, please provide the usage examples and other information on usage in a separate .md file called "How-To-Use.md"

## Third Pass
please rewrite this to manually enumerate and traverse the directory instead of using chmod -R

## 4
modify this script to allow for the case where the user does not want to modify any permissions. Additionally, modify this script so that one set of permissions can be provided for directories and a different set of permissions can be provided for files.

## 5
update this to combine all the settings into a single file rather than 4 separate files. Also, update the usage information in the "print_usage()" function to include instructions on how to use the environment variable option and how to use the file option. Please also update the "How-To-Use.md" file with the latest information




