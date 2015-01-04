#!/bin/bash

# DESCRIPTION
# Defines general utility functions.

install_settings() {
  printf "\nInstalling settings...\n"

  for source_file in $(ls -1 settings); do
    local dest_file="$ARCHIVER_HOME/${source_file%.*}"

    if [[ -e "$dest_file" ]]; then
      printf "  Exists: $dest_file\n"
    else
      mkdir -p "$ARCHIVER_HOME"
      cp "settings/$source_file" "$dest_file"
      printf "  + $dest_file\n"
    fi
  done

  printf "Settings installed! See README for customization.\n"
}
export -f install_settings

# Creates remote path on remote server.
# Parameters:
# $1 = Required. The remote directory path. Example: "/Backups/my_machine"
create_remote_path() {
  ssh "$BACKUP_SERVER_CONNECTION" mkdir -p "$1"
}
export -f create_remote_path

# Creates a full backup.
rsync_full() {
  rsync \
    --archive \
    --perms \
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
rsync_incremental() {
  local previous_backup="$1"

  rsync \
    --archive \
    --perms \
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
backup_log() {
  local remote_log_path="$BACKUP_SERVER_CONNECTION:$1/backup.log"
  scp -Cp "$BACKUP_LOG" "$remote_log_path"
  rm -f "$BACKUP_LOG"
}
export -f backup_log

backup_machine() {
  local backup_count=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | wc -l)

  create_remote_path "$BACKUP_PATH"

  if [[ "$backup_count" == '0' ]]; then
    printf "Creating full backup...\n"
    rsync_full
  else
    printf "Creating incremental backup...\n"
    local previous_backup=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | tail -n 1)
    rsync_incremental "$previous_backup"
  fi

  backup_log "$BACKUP_PATH"
  clean_backups

  printf "Backup complete!\n"
}
export -f backup_machine

clean_backups() {
  printf "Cleaning backups...\n"

  local backup_count=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | wc -l)

  if [[ "$backup_count" -gt "$BACKUP_LIMIT" ]]; then
    local backup_overage_count=$(($backup_count - $BACKUP_LIMIT))
    local backups_for_cleaning=$(ssh $BACKUP_SERVER_CONNECTION ls -1 $BACKUP_ROOT | head -n $backup_overage_count)

    for backup in $backups_for_cleaning; do
      printf "Deleting: $backup...\n"
      ssh "$BACKUP_SERVER_CONNECTION" "rm -rf $BACKUP_ROOT/$backup"
      printf "Deleted: $backup.\n"
    done
  else
    printf "Nothing to do.\n"
  fi
}
export -f clean_backups
