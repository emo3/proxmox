# Proxmox Ansible

This directory contains Ansible automation for configuring Proxmox resources (and/or the VMs/LXCs created by Terraform).

## Quick start

### 1) Run the initial box creation playbook

Run from this directory so Ansible paths work as expected:

```bash
cd /home/emo3/code/proxmox/ansible
ansible-playbook create-initial-box.yml
```

### 2) Run the main site playbook

> Details depend on your environment and inventory.

```bash
cd /home/emo3/code/proxmox/ansible
ansible-playbook site.yml
```

## Inventory

- Inventory is typically defined in `inventory.ini`.
- If your workflow generates/updates the inventory, ensure `inventory.ini` exists before running the playbooks.

## SSH / credentials

- Ansible-specific secrets are stored in files like `.passwd`.
- `proxmox/.gitignore` ignores `.passwd`, so regenerate/manage it locally as needed.

## Useful files

- `ansible.cfg` - Ansible configuration
- `answer.toml` - configuration used by playbooks/roles (if applicable)
- `tmp/` - working directory used during runs


