#!/bin/bash

# Cloud Freedom Backup Script
# Features: Progress Indicators, OS Detection, Config Integration

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

# Spinner function for progress
spin() {
    local -a marks=("|" "/" "-" "\\")
    while kill -0 "$1" 2>/dev/null; do
        for mark in "${marks[@]}"; do
            echo -ne "\r$mark Creating Backup... "
            sleep 0.2
        done
    done
    echo -ne "\r✅ Backup completed successfully! \n"
}

# Welcome Message
echo "Welcome to the $PROJECT_NAME Backup Tool!"

# Prompt for custom location
read -p "Do you want to specify a custom location for your backup? (y/N): " CUSTOM_LOCATION

if [[ $CUSTOM_LOCATION =~ ^[Yy]$ ]]; then
    read -p "Enter the full path to your desired backup directory: " BACKUP_DIR
    # Expand ~ to full path
    BACKUP_DIR="${BACKUP_DIR/#\~/$HOME}"
    if [[ ! -d $BACKUP_DIR ]]; then
        echo "❌ Error: Specified directory does not exist. Please create it and try again."
        exit 1
    fi
else
    BACKUP_DIR=$DEFAULT_BACKUP_DIR
fi

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Generate Backup File Name
TIMESTAMP=$(date +"$TIMESTAMP_FORMAT")
BACKUP_FILE="${BACKUP_FILE_PREFIX}-${TIMESTAMP}.zip"

# Display starting message
echo "Starting backup of $PROJECT_NAME components..."
echo "Backup will be saved at: $BACKUP_DIR/$BACKUP_FILE"

# Start backup process
(
    tar --exclude="$BACKUP_DIR" \
        --exclude="${EXCLUDE_PATHS[@]}" \
        -czf "$BACKUP_DIR/$BACKUP_FILE" \
        "$NEXTCLOUD_INSTALL_DIR" \
        "$DEFAULT_BACKUP_DIR" \
        "$HOME/Downloads"
) &
SPIN_PID=$!
spin $SPIN_PID
wait $SPIN_PID

# Completion Message
if [[ -f "$BACKUP_DIR/$BACKUP_FILE" ]]; then
    echo "🎉 Backup Completed Successfully!"
    echo "Backup file saved at: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "❌ Backup failed: No backup file found at the specified location."
fi
