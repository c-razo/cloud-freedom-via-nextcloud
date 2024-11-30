#!/bin/bash

# Cloud Freedom Install Script
# Purpose: Install Nextcloud and initialize required components.

source ../cf-config.sh  # Load configuration variables

# Initialize the database if it doesn't exist
initialize_database() {
    if [[ ! -f $DB_FILE ]]; then
        echo "Creating database file at: $DB_FILE"
        sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    access_code TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'unused',
    registration_date TEXT
);
INSERT INTO users (username, access_code, status) VALUES ('TestUser', 'test-access-code-123', 'unused');
EOF
        echo "Database initialized with a default test access code!"
    else
        echo "Database already exists at: $DB_FILE"
    fi
}

# Install Nextcloud
install_nextcloud() {
    if [[ ! -d $NEXTCLOUD_DIR ]]; then
        echo "Installing Nextcloud to $NEXTCLOUD_DIR..."
        mkdir -p /var/www
        unzip $NEXTCLOUD_ARCHIVE -d /var/www || {
            echo "ERROR: Failed to extract Nextcloud archive. Ensure the archive is in the correct location: $NEXTCLOUD_ARCHIVE."
            exit 1
        }
        mv /var/www/nextcloud-22.2.0 $NEXTCLOUD_DIR
        echo "Nextcloud installed successfully!"
    else
        echo "Nextcloud is already installed at: $NEXTCLOUD_DIR"
    fi
}

# Verify Nextcloud Installation
verify_installation() {
    echo "Verifying Nextcloud installation..."
    if curl -s "http://localhost/nextcloud" | grep -q "Nextcloud"; then
        echo "Nextcloud is accessible at http://localhost/nextcloud"
    else
        echo "ERROR: Nextcloud is not accessible. Please check Apache and PHP configurations."
        exit 1
    fi
}

# Main Execution
echo "Starting Cloud Freedom Install Script..."
initialize_database
install_nextcloud
verify_installation
echo "Cloud Freedom installation process is complete!"
