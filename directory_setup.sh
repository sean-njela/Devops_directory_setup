#!/bin/bash

# Basic configuration
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Simple logging setup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="setup_${TIMESTAMP}.log"
BACKUP_DIR="backup_${TIMESTAMP}"

# Basic logging functions
echo_log() {
    echo "$1" >> "$LOG_FILE"
    echo -e "$1"
}

log_info() {
    echo_log "${BLUE}[INFO] $1${NC}"
}

log_success() {
    echo_log "${GREEN}[SUCCESS] $1${NC}"
}

log_warning() {
    echo_log "${YELLOW}[WARNING] $1${NC}"
}

log_error() {
    echo_log "${RED}[ERROR] $1${NC}"
}

# Check tools
check_tools() {
    log_info "Checking required tools..."
    tools="git terraform ansible kubectl helm"
    missing=""
    
    for tool in $tools; do
        if ! command -v "$tool" > /dev/null 2>&1; then
            missing="$missing $tool"
        fi
    done
    
    if [ ! -z "$missing" ]; then
        log_warning "Missing tools:$missing"
        echo -n "Continue anyway? (y/N) "
        read answer
        if [ "$answer" != "y" ]; then
            log_error "Setup aborted by user"
            exit 1
        fi
    fi
}

# Base directory setup
BASE_DIR="project"

# Directory structure
DIRS="$BASE_DIR
$BASE_DIR/terraform
$BASE_DIR/terraform/environments
$BASE_DIR/terraform/environments/dev
$BASE_DIR/terraform/environments/prod
$BASE_DIR/terraform/environments/test
$BASE_DIR/terraform/modules
$BASE_DIR/terraform/modules/networking
$BASE_DIR/terraform/modules/compute
$BASE_DIR/terraform/modules/database
$BASE_DIR/ansible
$BASE_DIR/ansible/roles
$BASE_DIR/ansible/inventories
$BASE_DIR/ansible/group_vars
$BASE_DIR/ansible/host_vars
$BASE_DIR/scripts
$BASE_DIR/docs
$BASE_DIR/monitoring
$BASE_DIR/ci-cd
$BASE_DIR/tests
$BASE_DIR/tests/integration
$BASE_DIR/tests/unit
$BASE_DIR/security
$BASE_DIR/security/policies
$BASE_DIR/vault
$BASE_DIR/config
$BASE_DIR/kubernetes
$BASE_DIR/kubernetes/manifests
$BASE_DIR/kubernetes/helm-charts
$BASE_DIR/kubernetes/environments"

# Files structure
FILES="$BASE_DIR/terraform/environments/dev/main.tf
$BASE_DIR/terraform/environments/prod/main.tf
$BASE_DIR/terraform/environments/test/main.tf
$BASE_DIR/terraform/environments/dev/variables.tf
$BASE_DIR/terraform/environments/prod/variables.tf
$BASE_DIR/terraform/environments/test/variables.tf
$BASE_DIR/terraform/environments/dev/outputs.tf
$BASE_DIR/terraform/environments/prod/outputs.tf
$BASE_DIR/ansible/site.yml
$BASE_DIR/ansible/inventories/dev.ini
$BASE_DIR/ansible/inventories/prod.ini
$BASE_DIR/ansible/inventories/test.ini
$BASE_DIR/ansible/group_vars/all.yml
$BASE_DIR/docs/README.md
$BASE_DIR/docs/CONTRIBUTING.md
$BASE_DIR/docs/ARCHITECTURE.md
$BASE_DIR/ci-cd/Jenkinsfile
$BASE_DIR/ci-cd/docker-compose.yml
$BASE_DIR/tests/README.md
$BASE_DIR/kubernetes/manifests/deployment.yml
$BASE_DIR/kubernetes/manifests/service.yml
$BASE_DIR/kubernetes/manifests/ingress.yml
$BASE_DIR/README.md
$BASE_DIR/Makefile
$BASE_DIR/.gitignore"

# Basic directory validation
check_base_dir() {
    if [ -d "$BASE_DIR" ]; then
        log_warning "Directory $BASE_DIR already exists"
        mkdir -p "$BACKUP_DIR"
        cp -r "$BASE_DIR" "$BACKUP_DIR/"
        log_info "Backup created in $BACKUP_DIR"
    fi
}

# Directory creation
create_directories() {
    log_info "Creating directories..."
    echo "$DIRS" | while read -r dir; do
        if [ ! -z "$dir" ]; then
            if mkdir -p "$dir" 2>/dev/null; then
                log_success "Created directory: $dir"
            else
                log_error "Failed to create directory: $dir"
                exit 1
            fi
        fi
    done
}

# File creation
create_files() {
    log_info "Creating files..."
    echo "$FILES" | while read -r file; do
        if [ ! -z "$file" ]; then
            dir=$(dirname "$file")
            mkdir -p "$dir" 2>/dev/null
            if touch "$file" 2>/dev/null; then
                log_success "Created file: $file"
            else
                log_error "Failed to create file: $file"
                exit 1
            fi
        fi
    done
}

# Create gitignore
create_gitignore() {
    cat > "$BASE_DIR/.gitignore" << 'EOL'
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

# IDE
.idea/
.vscode/
*.swp
*.swo

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
EOL
    log_success "Created .gitignore file"
}

# Create health check script
create_health_check() {
    local health_script="$BASE_DIR/scripts/health_check.sh"
    mkdir -p "$BASE_DIR/scripts"
    cat > "$health_script" << 'EOL'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Starting health check..."

# Check empty directories
echo -e "\n${YELLOW}Checking empty directories:${NC}"
empty_dirs=$(find . -type d -empty -print)
if [ -n "$empty_dirs" ]; then
    echo -e "${RED}Empty directories found:${NC}\n$empty_dirs"
else
    echo -e "${GREEN}No empty directories found${NC}"
fi

# Check essential files
echo -e "\n${YELLOW}Checking essential files:${NC}"
for file in .gitignore README.md Makefile; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file exists${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
    fi
done

# Check git repository
echo -e "\n${YELLOW}Checking Git repository:${NC}"
if [ -d ".git" ]; then
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${RED}✗ Git repository not initialized${NC}"
fi
EOL
    chmod +x "$health_script"
    log_success "Created health check script"
}

# Initialize git repository
init_git() {
    if command -v git >/dev/null 2>&1; then
        cd "$BASE_DIR"
        git init >/dev/null 2>&1
        git add . >/dev/null 2>&1
        git commit -m "Initial commit" >/dev/null 2>&1
        cd - >/dev/null 2>&1
        log_success "Initialized Git repository"
    fi
}

# Main execution
main() {
    log_info "Starting directory setup script..."
    
    check_tools
    check_base_dir
    create_directories
    create_files
    create_gitignore
    create_health_check
    
    # Set permissions
    find "$BASE_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    
    # Initialize git
    init_git
    
    # Report completion
    log_success "Setup completed successfully!"
    log_info "You can run './scripts/health_check.sh' to verify the setup"
}

# Run main function
main


