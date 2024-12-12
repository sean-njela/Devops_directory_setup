# DevOps Project Directory Setup Script

[![Script](https://img.shields.io/badge/script--green.svg)](https://www.gnu.org/software//)
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
  - Basic error handling and logging
  - Tool prerequisite checking

- **Simple Logging System**:

  - Color-coded console output
  - Timestamped logs
  - Different log levels (INFO, SUCCESS, WARNING, ERROR)
  - Log file generation

- **Security Considerations**:
  - Basic file permissions
  - Gitignore templates
  - Security policy templates

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

   ```bash
   git clone https://github.com/sean-njela/Devops_directory_setup.git
   cd Devops_directory_setup
   ```

2. Make the script executable:

   ```bash
   chmod +x directory_setup.sh
   ```

3. Run the setup script:

   ```bash
   ./directory_setup.sh
   ```

## 📁 Directory Structure

```plaintext
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

The script includes a basic health check tool that verifies:

- Directory structure integrity
- Presence of essential files
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
- Color-coded console output

## 🔒 Security Features

- Basic `.gitignore` file
- Security policy templates
- Simple file handling

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Acknowledgments

- Inspired by DevOps best practices
- Built with basic security in mind
- Designed for both small and large-scale projects

## 💡 Support

For support, please open an issue in the GitHub repository.

---

Made with ❤️ for the DevOps community
