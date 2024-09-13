# MgmtScripts
My collection of simple system management scripts for particular shells. Currently there are 3 available shells:
* `/bin/bash`
* `/bin/sh`
* PowerShell

> **Note!** Use these scripts at your own risk! Feel free to adjust them to your needs and remember it isn't always the best idea to run the script without fully understanding it first! All of these scripts have been tested by me, however they might look differently in your environment!

### PowerShell execution policy
PowerShell normally doesn't allow you to run scripts downloaded from the Internet to protect you from malicious actions! Before executing any of the scripts you'll have to change the execution policy for your current PowerShell process using the following command:
```pwsh
Set-ExecutionPolicy Unrestricted -Scope Process -Force
```
After that you can use `pwsh/unblock.ps1` script to unblock all the scripts available in this repository in order to reduce the amount of received prompts!

### Structure
Every subfolder has the following structure:
```sh
.
├── bin
│   ├── script1
│   └── script2
├── script3
└── script4
```

The scripts in `bin` directory are supposed to be placed in one of the directories that appear in your `$PATH` environmental variable. Other scripts are usually meant to be used just once.
