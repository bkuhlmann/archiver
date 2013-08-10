#!/bin/sh

# DESCRIPTION
# Executes the command line interface.

# USAGE
# ./run.sh OPTION

# SETTINGS
set -e # Exit if any command returns non-zero.
if [ -e "$HOME/.archiver/settings.sh" ]; then
  source "$HOME/.archiver/settings.sh"
fi
export BACKUP_SERVER_CONNECTION="$BACKUP_USER@$BACKUP_SERVER"
export BACKUP_PATH="$BACKUP_ROOT/$BACKUP_NAME"
export BACKUP_LOG="/tmp/$BACKUP_MACHINE-$BACKUP_NAME-backup.txt"

# FUNCTIONS
source functions/utilities.sh
source functions/options.sh

# EXECUTION
if [ -z "$1" ]; then
  echo ''
  while true; do
    echo "Usage: run OPTION"
    echo "\nArchiver Options:"
    echo "  s: Setup current machine."
    echo "  b: Backup to remote server."
    echo "  c: Clean backups (enforces backup limit)."
    echo "  q: Quit/Exit."
    echo ''
    read -p "Enter selection: " response
    process_option $response
  done
else
  process_option $1
fi
echo ''
