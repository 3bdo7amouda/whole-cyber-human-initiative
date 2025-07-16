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

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    print_error "Cannot detect OS version"
    exit 1
fi

print_status "Detected OS: $OS"

# Update system packages
print_status "Updating system packages..."
sudo apt update

# Install required packages
print_status "Installing required packages..."
sudo apt install -y software-properties-common python3-pip

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

# Install Ansible based on OS
if [[ "$OS" == *"Ubuntu"* ]]; then
    print_status "Installing Ansible on Ubuntu..."
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
elif [[ "$OS" == *"Debian"* ]]; then
    print_status "Installing Ansible on Debian..."
    # For Debian, we'll use pip3 to install Ansible
    sudo apt install -y python3-pip python3-venv
    print_status "Installing Ansible via pip3..."
    sudo pip3 install ansible
else
    print_status "Installing Ansible via pip3 (generic method)..."
    sudo pip3 install ansible
fi

# Verify installation
print_status "Verifying Ansible installation..."
if command -v ansible &> /dev/null; then
    INSTALLED_VERSION=$(ansible --version | head -n1 | cut -d' ' -f2)
    print_status "Ansible successfully installed (version: $INSTALLED_VERSION)"
else
    print_error "Ansible installation failed"
    exit 1
fi

# Install additional Python packages needed for the playbook
print_status "Installing additional Python packages..."
sudo pip3 install psycopg2-binary

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