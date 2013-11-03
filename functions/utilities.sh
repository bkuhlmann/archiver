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

# Creates a full backup.
function rsync_full() {
  rsync \
    --archive \
    --recursive \
    --compress \
    --numeric-ids \
    --links \
    --hard-links \
    --delete \
    --delete-excluded \
    --one-file-system \
    --files-from="$ARCHIVER_MANIFEST" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    / "$BACKUP_SERVER_CONNECTION:$BACKUP_PATH"
}
export -f rsync_full

# Creates an incremental backup based on previous backup.
# Parameters:
# $1 = Required. The previous backup name.
function rsync_incremental() {
  previous_backup="$1"

  rsync \
    --archive \
    --recursive \
    --compress \
    --numeric-ids \
    --links \
    --hard-links \
    --delete \
    --delete-excluded \
    --one-file-system \
    --files-from="$ARCHIVER_MANIFEST" \
    --link-dest="$previous_backup" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    / "$BACKUP_SERVER_CONNECTION:$BACKUP_PATH"
}
export -f rsync_incremental

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
  backup_count=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | wc -l)

  create_remote_path "$BACKUP_PATH"

  if [ "$backup_count" -eq '0' ]; then
    echo "Creating full backup..."
    rsync_full
  else
    echo "Creating incremental backup..."
    previous_backup=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | tail -n 1)
    rsync_incremental "$previous_backup"
  fi

  backup_log "$BACKUP_PATH"
  clean_backups

  echo "Backup complete!"
}
export -f backup_machine

function clean_backups() {
  echo "Cleaning backups..."

  backup_count=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | wc -l)

  if [ "$backup_count" -gt "$BACKUP_LIMIT" ]; then
    backup_overage_count=$(expr $backup_count - $BACKUP_LIMIT)
    backups_for_cleaning=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | head -n $backup_overage_count)

    for backup in $backups_for_cleaning; do
      echo "Deleting: $backup..."
      ssh "$BACKUP_SERVER_CONNECTION" "rm -rf $BACKUP_ROOT/$backup"
      echo "Deleted: $backup."
    done
  else
    echo "Nothing to do."
  fi

  echo "Backups cleaned!"
}
export -f clean_backups
