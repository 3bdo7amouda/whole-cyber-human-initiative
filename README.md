# Whole Cyber Human Initiative - Infrastructure Setup

Automated infrastructure setup using Ansible for the Whole Cyber Human Initiative.

## 🚀 Quick Start

```bash
cd ansible
./setup.sh
```

## 📦 Components Installed

- **System packages**: curl, wget, gnupg, lsb-release, ca-certificates, software-properties-common, apt-transport-https
- **Docker** + **Docker Compose** (containerization)
- **PostgreSQL** (database with `app_db` database and `app_user` user)
- **Redis** (caching, configured with 256MB memory limit)
- **Nginx** (web server on port 80)

## 📁 Project Structure

```
ansible/
├── setup.sh                           # Main setup script
├── ansible.cfg                        # Ansible configuration
├── group_vars/all.yml                 # Software versions & settings
├── inventory/hosts                    # Target hosts
└── playbooks/setup-infrastructure.yml # Main playbook
```

## 🔧 Configuration

Edit `ansible/group_vars/all.yml` to customize:
- Software versions
- Database settings
- Redis configuration
- Nginx settings

## 🔄 Usage Options

**Full setup:**
```bash
./setup.sh
```

**Dry run (preview changes):**
```bash
ansible-playbook playbooks/setup-infrastructure.yml --check
```

**Manual execution:**
```bash
ansible-playbook playbooks/setup-infrastructure.yml
```

## 🎯 About

Infrastructure automation for the Whole Cyber Human Initiative - advancing human-centered cybersecurity and digital well-being.

**Website:** https://www.wholecyberhumaninitiative.org/

---

*Last Updated: July 16, 2025*