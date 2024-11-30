#!/bin/bash

# Cloud Freedom Master Script
# Features: Dry-Run, Installation, Backup, Restore, Troubleshooting
set -e

# Global Variables
CONFIG_FILE="./cf-config.sh"
LOG_DIR="$HOME/Documents/cloud-freedom/logs"
LOG_FILE="$LOG_DIR/cloud-freedom.log"
dev_mode=false  # Default: Developer mode disabled

# Ensure the configuration file exists
if [[ ! -f $CONFIG_FILE ]]; then
    echo "ERROR: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Load configuration
source $CONFIG_FILE

# Create log directory and file
if [[ ! -d $LOG_DIR ]]; then
    echo "Creating log directory at $LOG_DIR"
    mkdir -p "$LOG_DIR"
fi

if [[ ! -f $LOG_FILE ]]; then
    echo "Initializing log file at $LOG_FILE"
    touch "$LOG_FILE"
fi

# Logging function
log() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

# Developer Mode Check
if [[ $1 == "--dev" ]]; then
    dev_mode=true
    log "Developer mode enabled. Skipping access code validation."
fi

# Spinner function for animations
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Dry-Run Mode
perform_dry_run() {
    log "Starting dry-run mode..."
    if [[ -f "./cf-dry-run/dry-run.sh" ]]; then
        ./cf-dry-run/dry-run.sh
    else
        log "ERROR: Dry-run script not found in ./cf-dry-run"
        exit 1
    fi
}

# Installation Mode
perform_installation() {
    log "Starting installation mode..."
    if [[ -f "./cf-install/install.sh" ]]; then
        ./cf-install/install.sh
    else
        log "ERROR: Installation script not found in ./cf-install"
        exit 1
    fi
}

# Backup Mode
perform_backup() {
    log "Starting backup process..."
    if [[ -f "./cf-backup/backup.sh" ]]; then
        ./cf-backup/backup.sh
    else
        log "ERROR: Backup script not found in ./cf-backup"
        exit 1
    fi
}

# Restore Mode
perform_restore() {
    log "Starting restore process..."
    if [[ -f "./cf-restore/restore.sh" ]]; then
        ./cf-restore/restore.sh
    else
        log "ERROR: Restore script not found in ./cf-restore"
        exit 1
    fi
}

# Troubleshooting Mode
perform_troubleshooting() {
    log "Starting troubleshooting mode..."
    if [[ -f "./cf-troubleshoot/troubleshoot.sh" ]]; then
        ./cf-troubleshoot/troubleshoot.sh
    else
        log "ERROR: Troubleshooting script not found in ./cf-troubleshoot"
        exit 1
    fi
}

# Menu for user actions
display_menu() {
    echo "==========================================="
    echo "   Welcome to the Cloud Freedom Project    "
    echo "==========================================="
    echo "1) Dry-Run Mode"
    echo "2) Installation Mode"
    echo "3) Backup Mode"
    echo "4) Restore Mode"
    echo "5) Troubleshooting Mode"
    echo "6) Exit"
    echo "==========================================="
    read -p "Choose an option (1-6): " CHOICE

    case $CHOICE in
        1) perform_dry_run ;;
        2) perform_installation ;;
        3) perform_backup ;;
        4) perform_restore ;;
        5) perform_troubleshooting ;;
        6) log "Exiting script. Goodbye!"; exit 0 ;;
        *) log "Invalid option. Please try again."; display_menu ;;
    esac
}

# Access Code Validation (Skip in Dev Mode)
validate_access_code() {
    if $dev_mode; then
        log "Skipping access code validation in developer mode."
        return
    fi

    log "Validating access code..."
    # Simulated validation logic
    valid=true
    if ! $valid; then
        log "ERROR: Access code invalid."
        exit 1
    fi
    log "Access code validated successfully."
}

# Main Execution
log "Starting Cloud Freedom Master Script..."
validate_access_code  # Access code validation step
display_menu
