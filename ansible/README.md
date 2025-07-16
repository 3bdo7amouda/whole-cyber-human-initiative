# Ansible Infrastructure Setup

This Ansible project automates the installation and configuration of essential infrastructure components on Ubuntu/Debian systems.

## 🚀 Quick Start

1. **Install Ansible** (if not already installed):
   ```bash
   ./scripts/install-ansible.sh
   ```

2. **Run the infrastructure setup**:
   ```bash
   ansible-playbook playbooks/setup-infrastructure.yml
   ```

## 📦 Installed Components

This playbook installs and configures the following components:

### System Packages
- curl
- wget
- gnupg
- lsb-release
- ca-certificates
- software-properties-common
- apt-transport-https

### Container Platform
- **Docker** (latest or configurable version)
- **Docker Compose** (v2.23.0 or configurable)

### Databases
- **PostgreSQL** (v15 or configurable)
- **Redis** (v7 or configurable)

### Web Server
- **Nginx** (latest or configurable)

### Security Tools
- **UFW** (Uncomplicated Firewall)
- **Fail2ban** (intrusion prevention)

## 🔧 Configuration

### Versions and Settings
All versions and configurations are managed in `group_vars/all.yml`. Key settings include:

- Software versions (Docker, PostgreSQL, Redis, etc.)
- Database configurations
- Firewall rules
- Fail2ban jail settings

### Inventory
The inventory file `inventory/hosts` is configured for localhost deployment by default. Modify it to target remote servers.

### Variables
- **group_vars/all.yml**: Global variables and versions
- **host_vars/**: Host-specific variables (create as needed)

## 🛡️ Security Features

### UFW Firewall
- Default deny incoming policy
- Allows SSH (22), HTTP (80), and HTTPS (443)
- Configurable rules in variables

### Fail2ban
- SSH brute force protection
- Configurable ban times and retry limits
- Custom jail configurations

## 📁 Project Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── group_vars/
│   └── all.yml              # Global variables and versions
├── host_vars/               # Host-specific variables
├── inventory/
│   └── hosts               # Inventory file
├── playbooks/
│   └── setup-infrastructure.yml  # Main playbook
├── roles/                   # Custom roles (for future use)
├── scripts/
│   └── install-ansible.sh   # Ansible installation script
└── templates/
    └── jail.local.j2        # Fail2ban configuration template
```

## 🔄 Usage Examples

### Basic Installation
```bash
# Install Ansible first
./scripts/install-ansible.sh

# Run the full infrastructure setup
ansible-playbook playbooks/setup-infrastructure.yml
```

### Check What Would Be Changed (Dry Run)
```bash
ansible-playbook playbooks/setup-infrastructure.yml --check
```

### Run with Verbose Output
```bash
ansible-playbook playbooks/setup-infrastructure.yml -v
```

### Override Variables
```bash
ansible-playbook playbooks/setup-infrastructure.yml -e "postgresql.version=14"
```

## 🔒 Security Best Practices

1. **Use Ansible Vault** for sensitive data:
   ```bash
   ansible-vault create group_vars/vault.yml
   ```

2. **SSH Key Authentication**: Configure SSH keys for remote hosts

3. **Regular Updates**: Keep software versions updated in variables

4. **Backup Configurations**: The playbook creates backups of modified config files

## 🚨 Important Notes

- The playbook checks for existing installations before proceeding
- All services are started and enabled automatically
- Configuration files are backed up before modification
- The playbook is idempotent - safe to run multiple times

## 🛠️ Customization

### Adding New Software
1. Add version variables to `group_vars/all.yml`
2. Create installation tasks in the playbook
3. Add service management tasks
4. Include configuration templates if needed

### Modifying Firewall Rules
Edit the `ufw.rules` section in `group_vars/all.yml`:
```yaml
ufw:
  rules:
    - rule: allow
      port: 8080
      proto: tcp
```

### Database Configuration
Modify database settings in `group_vars/all.yml`:
```yaml
postgresql:
  databases:
    - name: "my_app"
      user: "app_user"
      password: "{{ vault_db_password }}"
```

## 🔍 Troubleshooting

### Common Issues
1. **Permission Errors**: Ensure user has sudo privileges
2. **Network Issues**: Check internet connectivity for package downloads
3. **Version Conflicts**: Verify version compatibility in variables

### Logging
Check Ansible logs and service status:
```bash
systemctl status docker postgresql redis nginx fail2ban
```

## 📝 Contributing

1. Test changes in a development environment
2. Update version numbers in variables
3. Add new components following existing patterns
4. Update documentation