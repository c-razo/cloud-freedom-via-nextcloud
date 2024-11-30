#!/bin/bash

# Cloud Freedom Dry-Run Script
# Purpose: Validate system readiness for Cloud Freedom installation

source ./cf-config.sh  # Load configuration variables

# Initialize database if not exists
initialize_database() {
    if [[ ! -f $DB_FILE ]]; then
        echo "Initializing database: $DB_FILE"
        sqlite3 $DB_FILE "CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            access_code TEXT NOT NULL,
            status TEXT NOT NULL DEFAULT 'unused',
            registration_date TEXT
        );"
        sqlite3 $DB_FILE "INSERT INTO users (username, access_code, status) VALUES ('TestUser', 'test-access-code-123', 'unused');"
        echo "Database initialized with a default test access code."
    fi
}

# Check Dependencies Dynamically
check_dependencies() {
    echo "DEBUG: Checking Apache..."
    apache_status=$(command -v apachectl >/dev/null 2>&1 && echo "✅ Validated" || echo "❌ Missing")

    echo "DEBUG: Checking PHP..."
    php_status=$(command -v php >/dev/null 2>&1 && echo "✅ Validated" || echo "❌ Missing")

    echo "DEBUG: Checking MariaDB..."
    mariadb_status=$(command -v mysql >/dev/null 2>&1 && echo "✅ Validated" || echo "❌ Missing")

    echo "DEBUG: Checking Nextcloud Directory..."
    nextcloud_status=$([[ -d $NEXTCLOUD_DIR ]] && echo "✅ Installed" || echo "❌ Missing")

    echo "DEBUG: Checking Storage Space..."
    storage_space=$(df -h / | awk 'NR==2 {print $4}' | sed 's/[A-Za-z]//g')
    storage_status=$([[ -n $storage_space && $storage_space -gt 20 ]] && echo "✅ Sufficient" || echo "❌ Insufficient")
}

# Display Results Table
display_results_table() {
    echo "--------------------------------------------------"
    printf "| %-20s | %-20s |\n" "Dependency" "Status"
    echo "--------------------------------------------------"
    printf "| %-20s | %-20s |\n" "Apache" "$apache_status"
    printf "| %-20s | %-20s |\n" "PHP" "$php_status"
    printf "| %-20s | %-20s |\n" "MariaDB" "$mariadb_status"
    printf "| %-20s | %-20s |\n" "Nextcloud" "$nextcloud_status"
    printf "| %-20s | %-20s |\n" "Storage" "$storage_status"
    echo "--------------------------------------------------"
}

# Execute Dry-Run Logic
echo "[$(date)] Starting Cloud Freedom Dry-Run..."
initialize_database  # Ensure the database is ready (does not interfere with dry-run)
check_dependencies
display_results_table
echo "[$(date)] Dry-Run Complete!"
