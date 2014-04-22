#!/bin/bash

# DESCRIPTION
# Executes the command line interface.

# USAGE
# ./run.sh OPTION

# SETTINGS
set -o nounset
set -o errexit
set -o pipefail
export ARCHIVER_HOME="$HOME/.archiver"
export ARCHIVER_SETTINGS="$ARCHIVER_HOME/settings.sh"
export ARCHIVER_MANIFEST="$ARCHIVER_HOME/manifest.txt"
if [ -e "$ARCHIVER_SETTINGS" ]; then
  source "$ARCHIVER_SETTINGS"
fi
export BACKUP_SERVER_CONNECTION="$BACKUP_USER@$BACKUP_SERVER"
export BACKUP_PATH="$BACKUP_ROOT/$BACKUP_NAME"
export BACKUP_LOG="/tmp/$BACKUP_MACHINE-$BACKUP_NAME-backup.txt"

# FUNCTIONS
source functions/utilities.sh
source functions/options.sh

# EXECUTION
while true; do
  if [[ $# == 0 ]]; then
    printf "\nUsage: run OPTION\n"
    printf "\nArchiver Options:\n"
    printf "  s: Setup current machine.\n"
    printf "  b: Backup to remote server.\n"
    printf "  c: Clean backups (enforces backup limit).\n"
    printf "  q: Quit/Exit.\n\n"
    read -p "Enter selection: " response
    printf "\n"
    process_option $response
  else
    process_option $1
  fi
done
