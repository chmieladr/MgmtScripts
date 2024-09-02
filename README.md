# MgmtScripts
My collection of simple system management scripts for particular shells. Currently there are 3 available shells:
* `/bin/bash`
* `/bin/sh`
* PowerShell

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

The scripts in `bin` directory are supposed to be placed in one of the directories that appear in your `$PATH` environmental variable. Other scripts are usually supposed to be used just once.