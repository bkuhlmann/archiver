#!/bin/bash

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
process_option() {
  case $1 in
    's')
      install_settings
      break;;
    'b')
      backup_machine
      break;;
    'c')
      clean_backups
      break;;
    'q')
      break;;
    *)
      printf "ERROR: Invalid option.\n"
      break;;
  esac
}
export -f process_option