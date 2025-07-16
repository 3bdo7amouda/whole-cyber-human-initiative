# Whole Cyber Human Initiative - Infrastructure Setup

This project provides automated infrastructure setup for the Whole Cyber Human Initiative using Ansible.

## 🚀 Quick Start

Run the complete infrastructure setup:
```bash
cd ansible
./setup.sh
```

## 📦 What Gets Installed

### System Packages
- curl, wget, gnupg, lsb-release, ca-certificates, software-properties-common, apt-transport-https

### Infrastructure Components
- **Docker** + **Docker Compose** (containerization platform)
- **PostgreSQL** (database)
- **Redis** (caching/session store)
- **Nginx** (web server)
- **UFW** (firewall)
- **Fail2ban** (intrusion prevention)

## 🔧 Configuration

All versions and settings are managed in `ansible/group_vars/all.yml`

## 📁 Project Structure

```
ansible/
├── setup.sh                    # Main setup script
├── ansible.cfg                 # Ansible configuration
├── group_vars/all.yml          # Software versions & settings
├── inventory/hosts             # Target hosts
├── playbooks/setup-infrastructure.yml  # Main playbook
└── templates/jail.local.j2     # Fail2ban template
```

## 🛡️ Security Features

- UFW firewall with SSH/HTTP/HTTPS access
- Fail2ban SSH protection
- Secure service configurations

## 🔄 Usage

**Full setup:**
```bash
./setup.sh
```

**Dry run (see what would change):**
```bash
ansible-playbook playbooks/setup-infrastructure.yml --check
```

**Manual run:**
```bash
ansible-playbook playbooks/setup-infrastructure.yml
```

## 🎯 About

This infrastructure setup supports the Whole Cyber Human Initiative website, which promotes human-centered cybersecurity and digital well-being.

- **Original Website:** https://www.wholecyberhumaninitiative.org/
- **Focus:** Human factors in cybersecurity, digital wellness, technology-human behavior intersection

---

*Last Updated: July 16, 2025*