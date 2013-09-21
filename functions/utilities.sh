#!/bin/sh

# DESCRIPTION
# Defines general utility functions.

function install_settings() {
  echo "\nInstalling settings..."

  for source_file in `ls -1 settings`; do
    dest_file="$ARCHIVER_HOME/${source_file%.*}"

    if [ -e "$dest_file" ]; then
      echo "  Exists: $dest_file"
    else
      mkdir -p "$ARCHIVER_HOME"
      cp "settings/$source_file" "$dest_file"
      echo "  + $dest_file"
    fi
  done

  echo "Settings installed! See README for customization."
}
export -f install_settings

# Creates remote path on remote server.
# Parameters:
# $1 = Required. The remote directory path. Example: "/Backups/my_machine"
function create_remote_path() {
  ssh "$BACKUP_SERVER_CONNECTION" mkdir -p "$1"
}
export -f create_remote_path

function rsync_and_create_base() {
  rsync --archive \
    --recursive \
    --compress \
    --delete \
    --files-from="$ARCHIVER_MANIFEST" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    $HOME "$BACKUP_SERVER_CONNECTION:$BACKUP_BASE"
}
export -f rsync_and_create_base

function rsync_and_link_base() {
  rsync --archive \
    --recursive \
    --compress \
    --delete \
    --files-from="$ARCHIVER_MANIFEST" \
    --link-dest="$BACKUP_BASE" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    $HOME "$BACKUP_SERVER_CONNECTION:$BACKUP_PATH"
}
export -f rsync_and_link_base

# Backs up the current machine log to remote server.
# Parameters:
# $1 = Required. The backup directory path. Example: "/Backups/my_machine"
function backup_log() {
  remote_log_path="$BACKUP_SERVER_CONNECTION:$1/backup.log"
  scp -Cp "$BACKUP_LOG" "$remote_log_path"
  rm -f "$BACKUP_LOG"
}
export -f backup_log

function backup_machine() {
  echo "Backup processing..."

  if ssh "$BACKUP_SERVER_CONNECTION" test -d "${BACKUP_BASE}"; then
    create_remote_path "$BACKUP_PATH"
    rsync_and_link_base
    backup_log "$BACKUP_PATH"
  else
    create_remote_path "$BACKUP_BASE"
    rsync_and_create_base
    backup_log "$BACKUP_BASE"
  fi

  clean_backups

  echo "Backup complete!"
}
export -f backup_machine

function clean_backups() {
  echo "Cleaning backups..."

  current_backup_count=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | wc -l)

  if [ "$current_backup_count" -gt "$BACKUP_LIMIT" ]; then
    backup_base="$(basename $BACKUP_BASE)"
    backup_overage_count=$(expr $current_backup_count - $BACKUP_LIMIT)
    backups_for_cleaning=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | head -n $backup_overage_count)

    for backup in $backups_for_cleaning; do
      if [ $backup != $backup_base ]; then
        echo "Deleting: $backup..."
        ssh "$BACKUP_SERVER_CONNECTION" "rm -rf $BACKUP_ROOT/$backup"
        echo "Deleted: $backup."
      fi
    done
  else
    echo "Nothing to do."
  fi

  echo "Backup cleaning complete!"
}
export -f clean_backups
