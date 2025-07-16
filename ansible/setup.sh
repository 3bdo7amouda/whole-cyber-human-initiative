#!/bin/bash

# Complete Infrastructure Setup Script
# This script will install Ansible and run the infrastructure playbook

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Infrastructure Setup Script${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Change to ansible directory
cd "$(dirname "$0")"

print_header

# Step 1: Install Ansible
print_status "Step 1: Checking Ansible installation..."
if ! command -v ansible &> /dev/null; then
    print_status "Installing Ansible..."
    ./scripts/install-ansible.sh
else
    print_status "Ansible is already installed"
fi

# Step 2: Verify inventory
print_status "Step 2: Verifying inventory configuration..."
if [ ! -f "inventory/hosts" ]; then
    print_error "Inventory file not found!"
    exit 1
fi

# Step 3: Run syntax check
print_status "Step 3: Checking playbook syntax..."
if ! ansible-playbook playbooks/setup-infrastructure.yml --syntax-check; then
    print_error "Playbook syntax check failed!"
    exit 1
fi

# Step 4: Show what would be changed (dry run)
print_status "Step 4: Performing dry run to show what would be changed..."
echo -e "${YELLOW}Press Enter to continue with dry run, or Ctrl+C to exit${NC}"
read -r

ansible-playbook playbooks/setup-infrastructure.yml --check --diff

# Step 5: Ask for confirmation
echo -e "${YELLOW}Do you want to proceed with the actual installation? (y/n):${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    print_status "Step 5: Running infrastructure setup playbook..."
    ansible-playbook playbooks/setup-infrastructure.yml
    
    print_status "Setup completed successfully!"
    print_status "You can verify the installation by checking service status:"
    echo -e "${BLUE}  systemctl status docker postgresql redis nginx fail2ban${NC}"
else
    print_status "Installation cancelled by user"
fi