#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging configuration
LOG_FILE="setup_$(date +%Y%m%d_%H%M%S).log"
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"

# Cleanup function for graceful exit
cleanup() {
    if [ $? -ne 0 ]; then
        log "Script execution failed. Check $LOG_FILE for details." "ERROR"
    fi
}

trap cleanup EXIT

# Error handling function
handle_error() {
    local line_number=$1
    local error_message=$2
    echo -e "${RED}Error on line $line_number: $error_message${NC}" | tee -a "$LOG_FILE"
    exit 1
}

# Set up error handling
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

# Logging function
log() {
    local message=$1
    local level=${2:-INFO}
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    case $level in
        "INFO")
            echo -e "${BLUE}[$level] $message${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[$level] $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[$level] $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}[$level] $message${NC}"
            ;;
    esac
}

# Check required tools
check_requirements() {
    log "Checking required tools..."
    local required_tools=("git" "terraform" "ansible" "kubectl" "helm")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        log "Missing required tools: ${missing_tools[*]}" "WARNING"
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Setup aborted by user" "ERROR"
            exit 1
        fi
    else
        log "All required tools are present" "SUCCESS"
    fi
}

# Backup existing directory
backup_existing() {
    if [ -d "$BASE_DIR" ]; then
        log "Existing project directory found. Creating backup..." "WARNING"
        mkdir -p "$BACKUP_DIR"
        cp -r "$BASE_DIR" "$BACKUP_DIR/"
        log "Backup created at $BACKUP_DIR" "SUCCESS"
    fi
}

# Validate directory/file names
validate_names() {
    local invalid_chars='[<>:"/\\|?*]'
    
    for dir in "${DIRS[@]}"; do
        if [[ $dir =~ $invalid_chars ]]; then
            log "Invalid directory name: $dir" "ERROR"
            exit 1
        fi
    done

    for file in "${FILES[@]}"; do
        if [[ $file =~ $invalid_chars ]]; then
            log "Invalid file name: $file" "ERROR"
            exit 1
        fi
    done
}

# Validate base directory
validate_base_dir() {
    if [[ "$BASE_DIR" =~ [[:space:]] ]]; then
        log "Base directory path cannot contain spaces" "ERROR"
        exit 1
    fi
    
    if [[ "$BASE_DIR" = /* ]]; then
        log "Please use relative path for base directory" "ERROR"
        exit 1
    fi
}

# Report total size of project
report_size() {
    local size=$(du -sh "$BASE_DIR" 2>/dev/null | cut -f1)
    log "Total project size: $size" "INFO"
}

# Function to create README content
create_readme() {
    local dir=$1
    local content=$2
    if echo -e "$content" > "$dir/README.md" 2>/dev/null; then
        log "Created README for: $dir" "SUCCESS"
    else
        log "Failed to create README for: $dir" "ERROR"
        exit 1
    fi
}

# Main execution starts here
log "Starting directory setup script..."

# Check requirements first
check_requirements

# Define the base directory
BASE_DIR="project"
validate_base_dir

# Define the directory structure with comprehensive industry-standard layout
DIRS=(
    "$BASE_DIR"
    # Terraform structure
    "$BASE_DIR/terraform"
    "$BASE_DIR/terraform/environments"
    "$BASE_DIR/terraform/environments/{dev,prod,test}"
    "$BASE_DIR/terraform/modules"
    "$BASE_DIR/terraform/modules/{networking,compute,database}"
    # Ansible structure
    "$BASE_DIR/ansible"
    "$BASE_DIR/ansible/{roles,inventories,group_vars,host_vars}"
    # Core directories
    "$BASE_DIR/{scripts,docs,monitoring,ci-cd}"
    # Testing directories
    "$BASE_DIR/tests"
    "$BASE_DIR/tests/{integration,unit}"
    "$BASE_DIR/terraform/test"
    # Security and configuration
    "$BASE_DIR/security"
    "$BASE_DIR/security/policies"
    "$BASE_DIR/{vault,config}"
    # Kubernetes
    "$BASE_DIR/kubernetes"
    "$BASE_DIR/kubernetes/{manifests,helm-charts,environments}"
)

# Define the files to create with basic templates
FILES=(
    # Terraform files
    "$BASE_DIR/terraform/environments/{dev,prod,test}/main.tf"
    "$BASE_DIR/terraform/environments/{dev,prod,test}/variables.tf"
    "$BASE_DIR/terraform/environments/{dev,prod}/outputs.tf"
    "$BASE_DIR/terraform/environments/{dev,prod,test}/terraform.tfvars"
    # Ansible files
    "$BASE_DIR/ansible/site.yml"
    "$BASE_DIR/ansible/inventories/{dev,prod,test}.ini"
    "$BASE_DIR/ansible/group_vars/all.yml"
    # Documentation
    "$BASE_DIR/docs/{README,CONTRIBUTING,ARCHITECTURE}.md"
    # CI/CD
    "$BASE_DIR/ci-cd/{Jenkinsfile,docker-compose.yml}"
    # Testing
    "$BASE_DIR/tests/README.md"
    "$BASE_DIR/tests/integration/test_infrastructure.py"
    "$BASE_DIR/tests/unit/test_terraform.py"
    # Security
    "$BASE_DIR/security/policies/{security-policy,compliance-checks}.yml"
    "$BASE_DIR/vault/{README.md,.gitignore}"
    # Configuration
    "$BASE_DIR/config/{app-config,env-config}.yml"
    # Kubernetes
    "$BASE_DIR/kubernetes/manifests/{deployment,service,ingress}.yml"
    "$BASE_DIR/kubernetes/helm-charts/values.yml"
    "$BASE_DIR/kubernetes/environments/{dev,prod}-values.yml"
    # Git files
    "$BASE_DIR/{.gitignore,.pre-commit-config.yaml}"
    # Project root files
    "$BASE_DIR/{README.md,Makefile}"
)

# Validate names before proceeding
validate_names

# Backup existing directory if present
backup_existing

# Create the directories with error handling and logging
log "Creating directories..."
for DIR in "${DIRS[@]}"; do
    # Handle brace expansion
    eval "echo $DIR" | while read -r expanded_dir; do
        if mkdir -p "$expanded_dir" 2>/dev/null; then
            log "Created directory: $expanded_dir" "SUCCESS"
        else
            log "Failed to create directory: $expanded_dir" "ERROR"
            exit 1
        fi
    done
done

# Create the files with error handling and logging
log "Creating files..."
for FILE in "${FILES[@]}"; do
    # Handle brace expansion
    eval "echo $FILE" | while read -r expanded_file; do
        if touch "$expanded_file" 2>/dev/null; then
            log "Created file: $expanded_file" "SUCCESS"
        else
            log "Failed to create file: $expanded_file" "ERROR"
            exit 1
        fi
    done
done

# Create .gitignore with comprehensive content
cat << 'EOF' > "$BASE_DIR/.gitignore"
# Terraform
*.tfstate
*.tfstate.*
.terraform/
*.tfvars
!example.tfvars
.terraform.lock.hcl

# Ansible
*.retry
inventory.ini
vault.yml

# Vault
vault/secrets/*
.vault-token
*.vault

# Python
__pycache__/
*.py[cod]
*$py.class
.env
venv/
.pytest_cache/
*.egg-info/

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
*.log
*.tmp

# Kubernetes
kubeconfig
*.kubeconfig
*secrets.yml

# Certificates
*.pem
*.key
*.crt
*.csr

# Logs and databases
*.log
*.sql
*.sqlite

# Environment variables
.env*
!.env.example
EOF

# Create enhanced health check script
cat << 'EOF' > "$BASE_DIR/scripts/health_check.sh"
#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Starting comprehensive health check..."

# Check for empty directories
echo -e "\n${YELLOW}Checking for empty directories:${NC}"
empty_dirs=$(find . -type d -empty -print)
if [ -n "$empty_dirs" ]; then
    echo -e "${RED}Found empty directories:${NC}"
    echo "$empty_dirs"
else
    echo -e "${GREEN}No empty directories found${NC}"
fi

# Check for required files
echo -e "\n${YELLOW}Checking for essential files:${NC}"
essential_files=(
    ".gitignore"
    "README.md"
    "Makefile"
    "terraform/environments/dev/main.tf"
    "ansible/site.yml"
    "kubernetes/manifests/deployment.yml"
)

for file in "${essential_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file exists${NC}"
    else
        echo -e "${RED}✗ $file is missing${NC}"
    fi
done

# Check file permissions
echo -e "\n${YELLOW}Checking script permissions:${NC}"
find . -name "*.sh" -type f -exec test -x {} \; -print | while read -r script; do
    echo -e "${GREEN}✓ $script is executable${NC}"
done

# Check for git repository
echo -e "\n${YELLOW}Checking Git repository:${NC}"
if [ -d ".git" ]; then
    echo -e "${GREEN}✓ Git repository is initialized${NC}"
else
    echo -e "${RED}✗ Git repository is not initialized${NC}"
fi

# Check directory structure
echo -e "\n${YELLOW}Verifying directory structure:${NC}"
required_dirs=(
    "terraform"
    "ansible"
    "kubernetes"
    "security"
    "tests"
    "docs"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓ $dir directory exists${NC}"
    else
        echo -e "${RED}✗ $dir directory is missing${NC}"
    fi
done

echo -e "\n${GREEN}Health check completed.${NC}"
EOF

chmod +x "$BASE_DIR/scripts/health_check.sh"
log "Created enhanced health check script" "SUCCESS"

# Create READMEs for each major directory
# [Previous README creation code remains the same]

# Report final statistics
report_size
log "Directory setup completed successfully!" "SUCCESS"
log "Total directories created: ${#DIRS[@]}" "INFO"
log "Total files created: ${#FILES[@]}" "INFO"
log "Log file: $LOG_FILE" "INFO"

if [ -d "$BACKUP_DIR" ]; then
    log "Backup location: $BACKUP_DIR" "INFO"
fi

# Add execution permissions to scripts
find "$BASE_DIR" -name "*.sh" -type f -exec chmod +x {} \;
log "Added execution permissions to script files" "SUCCESS"

# Initialize git repository if git is available
if command -v git >/dev/null 2>&1; then
    (cd "$BASE_DIR" && git init && git add . && git commit -m "Initial commit") >/dev/null 2>&1
    log "Initialized Git repository" "SUCCESS"
fi

# Final success message
log "Setup completed successfully! You can now start working with your DevOps project structure." "SUCCESS"
log "Run './scripts/health_check.sh' to verify the setup" "INFO"

