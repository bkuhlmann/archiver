#!/bin/sh

# DESCRIPTION
# Defines general utility functions.

function install_settings {
  echo "\nInstalling settings..."

  for source_file in `ls -1 settings`; do
    dest_file="$HOME/.archiver/${source_file%.*}"

    if [ -e "$dest_file" ]; then
      echo "  Exists: $dest_file"
    else
      cp "settings/$source_file" "$dest_file"
      echo "  + $dest_file"
    fi
  done

  echo "Settings installed! See README for customization."
}
export -f install_settings

function backup_log {
  scp -Cp "$BACKUP_LOG" "$BACKUP_USER@$BACKUP_SERVER:$BACKUP_PATH/backup.log"
  rm -f "$BACKUP_LOG"
}
export -f backup_log

function rsync_and_create_base {
  rsync --archive \
    --recursive \
    --compress \
    --delete \
    --files-from="$HOME/.archiver/manifest.txt" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    $HOME "$BACKUP_USER@$BACKUP_SERVER:$BACKUP_BASE"
}
export -f rsync_and_create_base

function rsync_and_link_base {
  rsync --archive \
    --recursive \
    --compress \
    --delete \
    --files-from="$HOME/.archiver/manifest.txt" \
    --link-dest="$BACKUP_BASE" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    $HOME "$BACKUP_USER@$BACKUP_SERVER:$BACKUP_PATH"
}
export -f rsync_and_link_base

function backup_files {
  if ssh "$BACKUP_USER@$BACKUP_SERVER" test -d "${BACKUP_BASE}"; then
    rsync_and_link_base
  else
    rsync_and_create_base
  fi
}
export -f backup_files

function backup_machine {
  echo "Backup processing..."
  backup_files
  backup_log
  clean_backups
  echo "Backup complete!"
}
export -f backup_machine

function clean_backups {
  echo "Cleaning backups..."

  current_backup_count=$(ssh $BACKUP_USER@$BACKUP_SERVER ls -1 $BACKUP_ROOT | wc -l)

  if [ "$current_backup_count" -gt "$BACKUP_LIMIT" ]; then
    backup_base="$(basename $BACKUP_BASE)"
    backup_overage_count=$(expr $current_backup_count - $BACKUP_LIMIT)
    backups_for_cleaning=$(ssh $BACKUP_USER@$BACKUP_SERVER ls -1 $BACKUP_ROOT | head -n $backup_overage_count)

    for backup in $backups_for_cleaning; do
      if [ $backup != $backup_base ]; then
        echo "Deleting: $backup..."
        ssh "$BACKUP_USER@$BACKUP_SERVER" "rm -rf $BACKUP_ROOT/$backup"
        echo "Deleted: $backup."
      fi
    done
  else
    echo "Nothing to do."
  fi

  echo "Backup cleaning complete!"
}
export -f clean_backups
