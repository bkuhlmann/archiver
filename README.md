# Overview

Shell scripts for the automated backup of UNIX-based operation systems.

# Features

* Uses rsync for reliable, compressed, and fast backups.
* Uses date/time-stamped backup folders by default.
* Enforces backup limits so only a max number of backups can exist.
* Customizable settings for defining the local machine and remote server to backup to.
* Customizable file manifest (whitelist) for defining what files and directories to backup.

# Requirements

0. A UNIX-system capable of running rsync.
0. Knowledge of shell scripts, cron, and SSH.

# Setup

Open a terminal window and execute one of the following setup sequences depending on your version preference:

Current Version (stable):

    git clone git://github.com/bkuhlmann/archiver.git
    cd archiver
    git checkout v2.0.0

Master Version (unstable):

    git clone git://github.com/bkuhlmann/archiver.git
    cd archiver

Applying machine-specific settings is required prior to performing a backup. The shell script (see Usage section below
for details) will install templates to get you started but will require further customization. The following is a
breakdown of each setting file and how to use it:

* ~/.archiver/settings.sh - Informs the Archiver how and where to perform the backup (see the
  settings/settings.sh.example file for examples). It consists of the following settings:
    * BACKUP_NAME - The name used for each backup (in this case a datetime). Example: 2013-01-15_10-30-55.
    * BACKUP_USER - The user account name used for both the current machine and backup server.
    * BACKUP_MACHINE - The name of machine to be backed up. This is also used to create the root folder for all machine
      backups and related logs.
    * BACKUP_SERVER - The backup server network name or IP address (where all backups will be stored).
    * BACKUP_ROOT - Root path for all backup folders on backup server for current machine.
    * BACKUP_BASE - The base backup (i.e. initial backup) for current machine for which all other backups are based off of.
    * BACKUP_LIMIT - The max number of backups to keep at a time.
* ~/.archiver/manifest.txt - Defines all files to be backed up (whitelist). Only list a files or directories relative
  to the current user's home directory. See the settings/manifest.txt.example file for examples.

# Usage

Type the following from the command line to run:

    ./run.sh

Running the run.sh script will present the following options:

    s: Setup current machine.
    b: Backup to remote server.
    c: Clean backups (enforces backup limit).
    q: Quit/Exit.

The options prompt can be skipped by passing the desired option directly to the run.sh script.
For example, executing "./run.sh s" will perform setup for the current machine.

## Cron

Once backups are configured and running properly it is a good idea to add this script to your
[crontab](https://en.wikipedia.org/wiki/Crontab) for daily backup automation. Example:

    * 1 * * * cd $HOME/Dropbox/Development/archiver && ./run.sh b 2>&1

...which translates to running the script at 1am every morning.

## SSH

It is a good idea to install your public key on the backup server so that cron does not have authentication
issues when performing a backup. Assuming you have a public key located at the following location:

    ~/.ssh/id_rsa.pub

...you can then perform the following to install it on the backup server (assumes an authorized_key file does not
already exists):

    scp  ~/.ssh/id_rsa.pub bkuhlmann@archiver.local:.ssh/authorized_keys

That's it! For more info on SSH key generation, check out the
[GitHub Generating SSH Keys](https://help.github.com/articles/generating-ssh-keys) page.

# Troubleshooting

* Rsync Error 23 - If you see this in the backup log, it is most likely because the source file/directory no longer exists.
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
