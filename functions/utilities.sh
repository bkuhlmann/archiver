#!/bin/sh

# DESCRIPTION
# Defines general utility functions.

# Installs settings for performing backups.
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

# Backs up log.
function backup_log {
  scp "$BACKUP_LOG" "$BACKUP_USER"@"$BACKUP_SERVER":"$BACKUP_PATH/backup.log"
  rm -f "$BACKUP_LOG"
}
export -f backup_log

# Backs up files.
function backup_files {
  rsync --archive \
    --recursive \
    --compress \
    --delete \
    --files-from="$HOME/.archiver/manifest.txt" \
    --link-dest="$BACKUP_BASE" \
    --log-file="$BACKUP_LOG" \
    --human-readable \
    --verbose \
    $HOME "$BACKUP_USER"@"$BACKUP_SERVER":"$BACKUP_PATH"
}
export -f backup_files

# Backs up machine files and logs.
function backup_machine {
  echo "Backup processing..."
  backup_files
  backup_log
  echo "Backup complete!"
}
export -f backup_machine
