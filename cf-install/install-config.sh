#!/bin/bash
# Cloud Freedom Configuration File

# General Settings
PROJECT_NAME="Cloud Freedom"
AUTHOR="Your Name"
VERSION="1.0"
DEFAULT_BACKUP_DIR="$HOME/Documents/cloud-freedom/backups"
TIMESTAMP_FORMAT="%Y-%m-%d-%H-%M-%S"

# Paths
NEXTCLOUD_INSTALL_DIR="/var/www/nextcloud"
NEXTCLOUD_ARCHIVE_PATH="../cf-install/nextcloud-22.2.0.zip"  # Updated for consistency

# Dependencies
APACHE_SERVICE_NAME="httpd"
PHP_SERVICE_NAME="php"
MARIADB_SERVICE_NAME="mariadb"

# Backup & Restore Settings
BACKUP_FILE_PREFIX="cloud-freedom-backup"
EXCLUDE_PATHS=("$DEFAULT_BACKUP_DIR" "/tmp" "/dev")
RESTORE_DESTINATION="$HOME/Documents/cloud-freedom/restored/"

# Resource Thresholds
MIN_DISK_SPACE_GB=20
MIN_RAM_MB=1024

# User Access Code (for testing purposes)
DEFAULT_ACCESS_CODE="test-access-code-123"

# Logging
LOG_DIR="$HOME/Documents/cloud-freedom/logs"
LOG_FILE="$LOG_DIR/cloud-freedom.log"

# Development Mode (disable access code validation)
DEV_MODE=true  # Set to false for production

# Default URLs
LOCALHOST_URL="http://localhost/nextcloud"

# Additional Variables for Future Expansion
VPN_SETUP_ENABLED=true
DEFAULT_VPN_PROVIDER="openvpn"

# Ensure log directory exists
if [[ ! -d $LOG_DIR ]]; then
    mkdir -p "$LOG_DIR"
fi

# Ensure default backup directory exists
if [[ ! -d $DEFAULT_BACKUP_DIR ]]; then
    mkdir -p "$DEFAULT_BACKUP_DIR"
fi
