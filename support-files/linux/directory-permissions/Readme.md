# Creation
This directory permissions script was created using GitHub Copilot.

# Overview
When using QNAP QTS, QNAP has disabled the default admin account. This is good. However, QNAP has not adjusted their software to stop using the default admin account and use the one created during initialization.
This results in a lot of services creating files and directories with the "admin" user as the owner. 
Many times the administrators group is not given adequate permissions for accessing these directories and files.
One example is Container Station which creates the directories for volumes. You're supposed to be able to access these volumes from the host, but no one except for the disabled admin user has access.
I decided to test out GitHub Copilot by getting it to make me a script that would set the permissions of the specified directories for the specified groups




The following prompt was used:
write me a linux bash script that does the following:
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
- The command line parameters Have the highest precedence. This means that if command lime parameters are detected, do not try to read from files or environment variables.
- Environment variables have the second highest precedence. This means that command line parameters are higher precedence. However, reading from files is lower precedence.
- Only try to read from files if no command line parameters are passed and no environment variables are found
- The script should output messages to standard out that adequately indicate each step of the process as it's being executed.
- Add appropriate comments within the script file to document the purpose of each line of code and/or each block of code.
The environment variables should be called "MDP_PATHS", "MDP_GROUP", and "MDP_PERMISSIONS".
the script will be called "mod_directory_permissions.sh".
Please also provide examples of how to use this script via the file approach, the command line approach, and the environment variable approach.
