# v6.0.0 (2018-01-01)

- Added Gemfile.lock to .gitignore.
- Updated Gemfile.lock file.
- Updated to Apache 2.0 license.
- Updated to Bundler 1.16.0.
- Updated to Git Cop 1.7.0.
- Updated to Rake 12.3.0.
- Updated to Rubocop 0.51.0.
- Updated to Ruby 2.4.2.
- Updated to Ruby 2.4.3.
- Updated to Ruby 2.5.0.
- Removed black/white lists (use include/exclude lists instead).

# v5.0.0 (2017-08-27)

- Added Git Cop support.
- Added versioning section to README.
- Updated CONTRIBUTING documentation.
- Updated GitHub templates.
- Updated README headers.
- Updated README semantic versioning order.
- Updated contributing documentation.
- Updated gem dependencies.
- Updated settings location (i.e. `~/.config/archiver`).
- Updated to Git Cop 1.3.0.
- Updated to Git Cop 1.5.0.
- Updated to Git Cop 1.6.0.
- Removed CHANGELOG.md (use CHANGES.md instead).

# v4.0.0 (2016-10-11)

- Fixed Bash script header to dynamically load correct environment.
- Fixed contributing guideline links.
- Added GitHub issue and pull request templates.
- Updated GitHub issue and pull request templates.
- Updated README cloning instructions to use HTTPS scheme.
- Updated to Code of Conduct, Version 1.4.0.
- Removed `run.sh` (use `bin/run` instead).
- Refactored run scripts to use break statements.

# v3.3.0 (2015-12-13)

- Fixed hanging script with invalid option.
- Added Bashsmith generation to README history.
- Added Patreon badge to README.
- Added code of conduct documentation.
- Added project name to README.
- Added table of contents to README.
- Updated Code of Conduct 1.3.0.
- Updated README with Tocer generated Table of Contents.
- Removed GitTip badge from README.
- Refactored script source from functions to lib folder.
- Refactored shell scripts to remove deprecated function definition.

# v3.2.0 (2015-01-01)

- Updated README, CHANGELOG, LICENSE, and CONTRIBUTING documentation.
- Added Bash strict mode.
- Added preservation of file permissions.

# v3.1.0 (2014-05-04)

- Fixed bash script header.
- Refactored scripts to enable better error checking.
- Refactored scripts to explicitly define local variables where appropriate.
- Refactored scripts to use double backets [[...]] instead of single brackets [...] for if statements.
- Refactored scripts to use  instead of backticks  for command substitution.
- Refactored scripts to use printf instead of echo.

# v3.0.0 (2013-11-05)

- Fixed backup root path to be / instead of $HOME.
- Fixed incremental backups so they are based off the previous backup rather than the "base" directory.
- Added the --numeric-ids, --links, --hard-links, --delete-excluded, and --one-file-system rsync options.

# v2.1.0 (2013-08-11)

- Fixed bug where backup log would not be copied correctly to the 'base' backup folder for new machine backups.
- Fixed bug when ~/.archiver directory doesn't exist and settings are not installed properly.
- Fixed bug where if a remote path did not exist, the backup would fail.
- Added compression and file permission preservation when copying backup log to backup folder.
- Refactored the backup server connection details to a single variable.
- Refactored the duplication of archiver home directory and setting/manifest files to ARCHIVER_HOME, ARCHIVER_SETTINGS,
  and ARCHIVER_MANIFEST variables.
- Simplified manifest.txt.example to just the .archiver and Downloads folders.
- Switched to generic 'archiver' as the backup user for settings.sh example.
- Updated README with run.sh option list.
- Applied minor readability tweaks to the README.
- Added SSH connection closed troubleshooting tips to the README.

# v2.0.0 (2013-08-07)

- Added Troubleshooting section to README.
- Added Crontab setup and examples to README.
- Added SSH section to README and re-arranged the Setup and Usage sections with related info.
- Updated README requirements.
- Added automatic backup cleanup and max limits (only the oldest are destroyed when limit is reached).
- Enchanced backup process to detect if base directory exits and create (if necessary).

# v1.0.0 (2013-08-04)

- Initial version.
