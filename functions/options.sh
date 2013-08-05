#!/bin/sh

# DESCRIPTION
# Defines command line prompt options.

# Process option selection.
# Parameters:
# $1 = The option to process.
function process_option {
  case $1 in
    's')
      install_settings
      break;;
    'b')
      backup_machine
      break;;
    'q')
      break;;
  esac
}
export -f process_option
