# MgmtScripts
My collection of simple system management scripts for particular shells. Currently there are 3 available shells:
* `/bin/bash`
* `/bin/sh`
* PowerShell

> **Note!** Use these scripts at your own risk! Feel free to adjust them to your needs and remember it isn't always the best idea to run the script without fully understanding it first! All of these scripts have been tested by me, however they might work with some differences in your environment!

### My testing environment
* Linux openSUSE Leap 15.6 (`/bin/bash`)
* ArchLinux (`/bin/sh`)
* Microsoft Windows 11 23H2 with **PowerShell** 7.4.5

### PowerShell execution policy
PowerShell normally doesn't allow you to run scripts downloaded from the Internet to protect you from malicious actions! Before executing any of the scripts you'll have to change the execution policy for your current PowerShell process using the following command:
```pwsh
Set-ExecutionPolicy Unrestricted -Scope Process -Force
```
After that you can use `pwsh/UnblockAll.ps1` script to unblock all the scripts available in this repository in order to reduce the amount of received prompts! (however, this step is fully optional)

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

## Example scripts
This section quickly summarises the most outstanding scripts existent within this project that offer the most interesting (or stupidly funny) functionalities.

#### declutter_suse _(openSUSE /bin/bash)_
* advanced customizable uninstaller script that lets you easily get rid of unnecessary preinstalled software
* allows you to select which programs exactly you want to erase from your installation

#### GodlyShortcuts _(PowerShell for Windows)_
* script that creates shortcuts for (usually) hidden or difficult to access menus inside of Windows 11 that might come in handy for more advanced users
* includes "God Mode", all applications and more

#### Win10ify _(PowerShell for Windows)_
* script that reverts some Windows 11 changes to their Windows 10 versions
* includes old context menu and old taskbar

#### WinDebloat _(PowerShell for Windows)_
* work in progress

#### zdhcp _(Linux /bin/sh)_
* overcomplicated script to showcase exactly all 4 different DHCP packets
* just have a look at it and be surprised that it actually works...