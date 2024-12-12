# DevOps Project Directory Setup Script

[![ Script](https://img.shields.io/badge/script--green.svg)](https://www.gnu.org/software//)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A robust, production-ready script that automatically creates a comprehensive DevOps project directory structure with proper error handling, logging, and validation.

## 🚀 Features

- **Comprehensive Directory Structure**: Creates a complete DevOps project layout including:

  - Terraform configurations with environment separation
  - Ansible playbooks and roles
  - Kubernetes manifests and Helm charts
  - CI/CD configurations
  - Security policies
  - Testing frameworks
  - Documentation

- **Built-in Safety Features**:

  - Automatic backup of existing directories
  - Comprehensive error handling and logging
  - Input validation for directory and file names
  - Prerequisite tools checking

- **Intelligent Logging**:

  - Color-coded console output
  - Detailed timestamped logs
  - Different log levels (INFO, SUCCESS, WARNING, ERROR)
  - Log file generation for debugging

- **Security Considerations**:
  - Secure file permissions
  - Gitignore templates for sensitive files
  - Security policy templates
  - Vault integration preparation

## 📋 Prerequisites

The script checks for the following tools:

- git
- terraform
- ansible
- kubectl
- helm

> Note: The script will warn if tools are missing but can continue with user confirmation.

## 🛠️ Installation

1. Clone this repository:

   ```
   git clone https://github.com/sean-njela/Devops_directory_setup.git
   cd Devops_directory_setup
   ```

2. Make the script executable:

   ```
   chmod +x directory_setup.sh
   ```

3. Run the setup script:

   ```
   ./directory_setup.sh
   ```

## 🧩 Usage

To use the script, simply run it from the root of your cloned repository:

```
./directory_setup.sh
```

The script will:

1. Check for required tools
2. Create the directory structure
3. Set up initial configuration files
4. Initialize a git repository
5. Generate comprehensive documentation

## 📁 Directory Structure

```
project/
├── ansible/
│   ├── roles/
│   ├── inventories/
│   ├── group_vars/
│   └── host_vars/
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── prod/
│   │   └── test/
│   └── modules/
├── kubernetes/
│   ├── manifests/
│   ├── helm-charts/
│   └── environments/
├── security/
│   └── policies/
├── tests/
│   ├── integration/
│   └── unit/
├── docs/
├── ci-cd/
├── scripts/
├── monitoring/
└── config/
```

## 🔍 Health Check

The script includes a comprehensive health check tool that verifies:

- Directory structure integrity
- Presence of essential files
- File permissions
- Git repository status
- Empty directory detection

Run the health check:

```bash
./scripts/health_check.sh
```

## 📝 Logging

Logs are stored in the format: `setup_YYYYMMDD_HHMMSS.log`

The logging system provides:

- Timestamp for each operation
- Operation status (SUCCESS/ERROR/WARNING/INFO)
- Detailed error messages
- Color-coded console output

## 🔒 Security Features

- Secure file permission settings
- Comprehensive `.gitignore` file
- Vault integration preparation
- Security policy templates
- Sensitive file handling

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Acknowledgments

- Inspired by DevOps best practices and industry standards
- Built with security and scalability in mind
- Designed for both small and large-scale projects

## ��� Support

For support, please open an issue in the GitHub repository or contact [seannjela@outlook.com](mailto:seannjela@outlook.com).

---

Made with ❤️ for the DevOps community
