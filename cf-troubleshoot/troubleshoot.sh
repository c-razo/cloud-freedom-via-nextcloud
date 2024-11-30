#!/bin/bash

# Cloud Freedom Troubleshooting Script
# Purpose: Diagnose and fix issues related to Cloud Freedom dependencies

set -e

# Load configuration
source ./cf-config.sh

echo "=== Cloud Freedom Troubleshooting Script ==="

# Function to log messages
log_message() {
    echo "[$(date)] $1" >> "$LOG_FILE"
}

# Function to check and install a tool if missing
check_and_install() {
    local tool=$1
    local install_cmd=$2

    echo "Checking $tool installation..."
    log_message "Checking $tool installation..."

    if ! command -v "$tool" &>/dev/null; then
        echo "$tool is not installed. Attempting to install..."
        log_message "$tool is not installed. Attempting to install..."
        eval "$install_cmd" || {
            echo "ERROR: Failed to install $tool. Please install it manually."
            log_message "ERROR: Failed to install $tool."
            return 1
        }
        echo "$tool installed successfully!"
        log_message "$tool installed successfully."
    else
        echo "$tool is already installed!"
        log_message "$tool is already installed."
    fi
}

# Function to check Nextcloud installation
check_nextcloud() {
    echo "Checking Nextcloud installation..."
    log_message "Checking Nextcloud installation..."

    if [[ ! -d "$NEXTCLOUD_INSTALL_DIR" ]]; then
        echo "Nextcloud directory not found at $NEXTCLOUD_INSTALL_DIR."
        log_message "Nextcloud directory not found at $NEXTCLOUD_INSTALL_DIR."
        echo "Please verify the installation and ensure the directory exists."
    else
        echo "Nextcloud is installed successfully at $NEXTCLOUD_INSTALL_DIR!"
        log_message "Nextcloud is installed successfully at $NEXTCLOUD_INSTALL_DIR."
    fi
}

# Function to test if services are running
check_services() {
    echo "Checking Apache service status..."
    log_message "Checking Apache service status..."
    if systemctl is-active "$APACHE_SERVICE_NAME" &>/dev/null || brew services list | grep -q "$APACHE_SERVICE_NAME.*started"; then
        echo "Apache is running."
        log_message "Apache is running."
    else
        echo "Apache is not running. Attempting to start..."
        log_message "Apache is not running. Attempting to start..."
        (systemctl start "$APACHE_SERVICE_NAME" 2>/dev/null || brew services start "$APACHE_SERVICE_NAME") || {
            echo "ERROR: Failed to start Apache."
            log_message "ERROR: Failed to start Apache."
        }
    fi

    echo "Checking MariaDB service status..."
    log_message "Checking MariaDB service status..."
    if systemctl is-active "$MARIADB_SERVICE_NAME" &>/dev/null || brew services list | grep -q "$MARIADB_SERVICE_NAME.*started"; then
        echo "MariaDB is running."
        log_message "MariaDB is running."
    else
        echo "MariaDB is not running. Attempting to start..."
        log_message "MariaDB is not running. Attempting to start..."
        (systemctl start "$MARIADB_SERVICE_NAME" 2>/dev/null || brew services start "$MARIADB_SERVICE_NAME") || {
            echo "ERROR: Failed to start MariaDB."
            log_message "ERROR: Failed to start MariaDB."
        }
    fi
}

# Start troubleshooting
log_message "Starting Cloud Freedom Troubleshooting Script..."

# Check and install PHP
check_and_install "php" "brew install php"

# Check and install Apache
check_and_install "apachectl" "brew install httpd"

# Check and install MariaDB
check_and_install "mysql" "brew install mariadb"

# Check Nextcloud installation
check_nextcloud

# Check service statuses
check_services

# Troubleshooting complete
echo "Troubleshooting complete. Logs saved to $LOG_FILE."
log_message "Troubleshooting complete."
