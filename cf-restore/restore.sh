#!/bin/bash

# Cloud Freedom Restore Script
# Features: OS Detection, Config Integration, Validation

set -e

# Load configuration
source ./cf-config.sh

# OS Detection
OS=$(uname -s)
case $OS in
    Linux*) echo "Running on Linux";;
    Darwin*) echo "Running on macOS";;
    CYGWIN*|MINGW*) echo "Running on Windows";;
    *) echo "Unknown OS"; exit 1;;
esac

# Welcome Message
echo "Welcome to the $PROJECT_NAME Restore Tool!"

# Prompt for backup file
read -p "Enter the full path to your backup file (default: latest in $DEFAULT_BACKUP_DIR): " BACKUP_FILE
BACKUP_FILE="${BACKUP_FILE/#\~/$HOME}"

# Use the latest backup file in the default directory if none provided
if [[ -z $BACKUP_FILE ]]; then
    BACKUP_FILE=$(ls -t "$DEFAULT_BACKUP_DIR"/*.zip 2>/dev/null | head -n 1)
    if [[ -z $BACKUP_FILE ]]; then
        echo "❌ Error: No backup files found in $DEFAULT_BACKUP_DIR."
        exit 1
    fi
    echo "Using latest backup file: $BACKUP_FILE"
fi

# Validate the backup file
if [[ ! -f $BACKUP_FILE ]]; then
    echo "❌ Error: Backup file not found at $BACKUP_FILE. Please check the path and try again."
    exit 1
fi

# Prompt for restore destination directory
read -p "Enter the full path to the restore destination directory (default: $RESTORE_DESTINATION): " RESTORE_DIR
RESTORE_DIR="${RESTORE_DIR/#\~/$HOME}"

# Use default destination directory if none provided
if [[ -z $RESTORE_DIR ]]; then
    RESTORE_DIR=$RESTORE_DESTINATION
fi

# Ensure destination directory exists
if [[ ! -d $RESTORE_DIR ]]; then
    echo "Creating restore destination directory at: $RESTORE_DIR"
    mkdir -p "$RESTORE_DIR" || {
        echo "❌ Error: Failed to create restore destination directory. Check permissions and try again."
        exit 1
    }
fi

# Start restore process
echo "Restoring backup from: $BACKUP_FILE"
echo "Restoring to: $RESTORE_DIR"
(
    tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"
) && echo "🎉 Restore Completed Successfully!" || echo "❌ Restore failed. Please check the logs."
