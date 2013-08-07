# Overview

Shell scripts for the automated backup of UNIX-based operation systems.

# Features

* Uses rsync for reliable, compressed, and fast backups.
* Uses date/time-stamped backup folders by default.
* Customizable settings for defining the local machine and remote server to backup to.
* Customizable file manifest (whitelist) for defining what files and directories to backup.

# Requirements

0. A UNIX-system capable of running rsync.
0. Knowledge of shell scripts.
0. Knowledge of SSH and authorized_keys.

# Setup

Open a terminal window and execute one of the following setup sequences depending on your version preference:

Current Version (stable):

    git clone git://github.com/bkuhlmann/archiver.git
    cd archiver
    git checkout v1.0.0

Master Version (unstable):

    git clone git://github.com/bkuhlmann/archiver.git
    cd archiver

# Usage

Type the following from the command line to run:

    ./run.sh

Running the run.sh script will present the following options:

    s: Setup machine for backup.
    b: Backup machine.
    q: Quit/Exit.

The options prompt can be skipped by passing the desired option directly to the run.sh script.
For example, executing "./run.sh s" will setup the machine for backup.

Applying custom, machine-specific settings is required prior to performing a backup. The setup installs the
following files:

* ~/.archiver/settings.sh - Informs the Archiver how and where to perform the backup (see the
  settings/settings.sh.example file for examples). It consists of the following settings:
    * BACKUP_NAME - The name used for each backup (in this case a datetime). Example: 2013-01-15_10-30-55.
    * BACKUP_USER - The user account name used for both the current machine and backup server.
    * BACKUP_MACHINE - The name of machine to be backed up. This is also used to create the root folder for all machine
      backups and related logs.
    * BACKUP_SERVER - The backup server network name or IP address (where all backups will be stored).
    * BACKUP_ROOT - Root path for all backup folders on backup server for current machine.
    * BACKUP_BASE - The base backup (i.e. initial backup) for current machine for which all other backups are based off of.
* ~/.archiver/manifest.txt - Defines all files to be backed up (whitelist). Only list a files or directories relative
  to the current user's home directory. See the settings/manifest.txt.example file for examples.

Once backups are configured and running properly it might be a good idea to add this script to your
[crontab](https://en.wikipedia.org/wiki/Crontab) for daily backup automation. Example:

    * 1 * * * cd $HOME/Dropbox/Development/archiver && ./run.sh b 2>&1

...which translates to running the script at 1am every morning.

# Troubleshooting

* Rsync Error Code 23 - If you see this in the log, it is most likely because the source file/directory no longer exists.
  Update your manifest.txt to fix accordingly.

# Contributions

Read CONTRIBUTING for details.

# Credits

Developed by [Brooke Kuhlmann](http://www.redalchemist.com) at [Red Alchemist](http://www.redalchemist.com).

# License

Copyright (c) 2013 [Red Alchemist](http://www.redalchemist.com).
Read the LICENSE for details.

# History

Read the CHANGELOG for details.
