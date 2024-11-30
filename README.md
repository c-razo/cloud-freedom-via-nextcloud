# Cloud Freedom via Nextcloud

**Cloud Freedom Tools** is a comprehensive suite of scripts designed to help users set up, manage, and troubleshoot their private cloud storage system. This project is part of the broader **Cloud Freedom Project**, which aims to empower individuals and businesses with the tools and knowledge needed to maintain data privacy and independence.

## Features

- **Dry-Run Mode**: Validates system readiness before installation.
- **Installation**: Automates the setup of a private cloud using Nextcloud and other dependencies.
- **Backup**: Securely back up your cloud storage data with progress indicators.
- **Restore**: Restore your data from backup files with ease.
- **Troubleshooting**: Diagnose and resolve issues with dependencies and services.

---

## Directory Structure

```plaintext
.
├── cf-master.sh          # Master script for managing all features
├── cf-config.sh          # Configuration file with project settings
├── cf-dry-run/           # Directory containing the dry-run script
├── cf-install/           # Directory containing installation scripts
├── cf-backup/            # Directory containing the backup script
├── cf-restore/           # Directory containing the restore script
├── cf-troubleshoot/      # Directory containing the troubleshooting script
├── logs/                 # Directory for log files
└── README.md             # Project documentation
```

---

## Getting Started

### Prerequisites

Before you begin, ensure your system meets the following requirements:

- **Operating System**: macOS, Linux, or Windows with WSL.
- **Dependencies**: `php`, `httpd` (Apache), `mysql` (MariaDB), and `sqlite3`.
- **Disk Space**: At least 20GB free.

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/cloud-freedom-tools.git
   cd cloud-freedom-tools
   ```

2. **Configure the Project**:
   Open `cf-config.sh` and customize the settings as needed.

3. **Run the Master Script**:
   Start the master script to access all features:
   ```bash
   ./cf-master.sh
   ```

---

## Usage

### Menu Options

The master script provides a user-friendly menu for managing the tools:

1. **Dry-Run Mode**:
   - Validates system readiness before installation.

2. **Installation Mode**:
   - Automates the installation of Nextcloud and other dependencies.

3. **Backup Mode**:
   - Creates a secure backup of your cloud data.

4. **Restore Mode**:
   - Restores data from a backup file.

5. **Troubleshooting Mode**:
   - Diagnoses and resolves system issues.

6. **Exit**:
   - Exits the script.

---

## Logging

Logs are stored in the `logs/` directory:
- **Default Path**: `$HOME/Documents/cloud-freedom/logs/cloud-freedom.log`
- Logs include details of all actions performed by the scripts.

---

## Contributing

We welcome contributions to enhance the Cloud Freedom Tools. Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes and open a pull request.

---

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it.

---

## Support

If you encounter any issues or have questions, please contact support at [support@cloudfreedomproject.com](mailto:support@cloudfreedomproject.com).
```

---

### Next Steps:
1. **Replace**:
   Copy the above content into your `README.md` file in your repository.

2. **Customize**:
   Update placeholders like `your-username` and `support@cloudfreedomproject.com` with your actual details.

3. **Push to GitHub**:
   ```bash
   git add README.md
   git commit -m "Update README with project details"
   git push origin main
   ```
