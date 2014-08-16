# v3.1.0 (2014-05-04)

* Fixed bash script header.
* Refactored scripts to enable better error checking.
* Refactored scripts to explicitly define local variables where appropriate.
* Refactored scripts to use double backets [[...]] instead of single brackets [...] for if statements.
* Refactored scripts to use  instead of backticks  for command substitution.
* Refactored scripts to use printf instead of echo.

# v3.0.0 (2013-11-05)

* Fixed backup root path to be / instead of $HOME.
* Fixed incremental backups so they are based off the previous backup rather than the "base" directory.
* Added the --numeric-ids, --links, --hard-links, --delete-excluded, and --one-file-system rsync options.

# v2.1.0 (2013-08-11)

* Fixed bug where backup log would not be copied correctly to the 'base' backup folder for new machine backups.
* Fixed bug when ~/.archiver directory doesn't exist and settings are not installed properly.
* Fixed bug where if a remote path did not exist, the backup would fail.
* Added compression and file permission preservation when copying backup log to backup folder.
* Refactored the backup server connection details to a single variable.
* Refactored the duplication of archiver home directory and setting/manifest files to ARCHIVER_HOME, ARCHIVER_SETTINGS,
  and ARCHIVER_MANIFEST variables.
* Simplified manifest.txt.example to just the .archiver and Downloads folders.
* Switched to generic 'archiver' as the backup user for settings.sh example.
* Updated README with run.sh option list.
* Applied minor readability tweaks to the README.
* Added SSH connection closed troubleshooting tips to the README.

# v2.0.0 (2013-08-07)

* Added Troubleshooting section to README.
* Added Crontab setup and examples to README.
* Added SSH section to README and re-arranged the Setup and Usage sections with related info.
* Updated README requirements.
* Added automatic backup cleanup and max limits (only the oldest are destroyed when limit is reached).
* Enchanced backup process to detect if base directory exits and create (if necessary).

# v1.0.0 (2013-08-04)

* Initial version.
