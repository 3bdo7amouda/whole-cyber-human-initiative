#!/bin/bash

# Ansible Installation Script
# Author: System Administrator
# Description: Installs Ansible on Ubuntu/Debian systems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update

# Install required packages
print_status "Installing required packages..."
sudo apt install -y software-properties-common

# Check if Ansible is already installed
if command -v ansible &> /dev/null; then
    CURRENT_VERSION=$(ansible --version | head -n1 | cut -d' ' -f2)
    print_warning "Ansible is already installed (version: $CURRENT_VERSION)"
    read -p "Do you want to continue with the installation? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled"
        exit 0
    fi
fi

# Add Ansible PPA
print_status "Adding Ansible PPA..."
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
print_status "Installing Ansible..."
sudo apt install -y ansible

# Verify installation
print_status "Verifying Ansible installation..."
if command -v ansible &> /dev/null; then
    INSTALLED_VERSION=$(ansible --version | head -n1 | cut -d' ' -f2)
    print_status "Ansible successfully installed (version: $INSTALLED_VERSION)"
else
    print_error "Ansible installation failed"
    exit 1
fi

# Create ansible.cfg in user's home directory
print_status "Creating Ansible configuration file..."
cat > ~/.ansible.cfg << EOF
[defaults]
host_key_checking = False
inventory = ./inventory/hosts
roles_path = ./roles
remote_user = $(whoami)
private_key_file = ~/.ssh/id_rsa
timeout = 30
gather_facts = True
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF

print_status "Ansible installation completed successfully!"
print_status "Configuration file created at ~/.ansible.cfg"
print_status "You can now run Ansible playbooks!"