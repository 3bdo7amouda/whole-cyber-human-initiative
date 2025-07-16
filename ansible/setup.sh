#!/bin/bash

# Infrastructure Setup Script for Whole Cyber Human Initiative
# Installs Ansible and runs the infrastructure playbook

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Whole Cyber Human Initiative Setup${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Change to ansible directory
cd "$(dirname "$0")"

print_header

# Install Ansible if not present
if ! command -v ansible &> /dev/null; then
    print_status "Installing Ansible..."
    sudo pip3 install ansible psycopg2-binary --break-system-packages
else
    print_status "Ansible is already installed"
fi

# Run syntax check
print_status "Validating playbook syntax..."
if ! ansible-playbook playbooks/setup-infrastructure.yml --syntax-check; then
    print_error "Playbook syntax check failed!"
    exit 1
fi

# Show what would be changed
print_status "Showing what would be installed/configured..."
ansible-playbook playbooks/setup-infrastructure.yml --check --diff

# Confirm before proceeding
echo -e "\n${YELLOW}Proceed with infrastructure setup? (y/N):${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    print_status "Running infrastructure setup..."
    ansible-playbook playbooks/setup-infrastructure.yml
    
    print_status "✅ Setup completed successfully!"
    print_status "Verify services: systemctl status docker postgresql redis nginx fail2ban"
else
    print_status "Setup cancelled"
fi