# Proxmox

This directory contains infrastructure automation for a Proxmox environment using **Terraform**, **Ansible**, and helper **shell scripts**.

## What’s here

- `terraform/`
  - Terraform configuration for provisioning / managing Proxmox resources.
  - Files:
    - `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`
    - `.terraform.lock.hcl`
- `ansible/`
  - Ansible playbooks/roles to configure hosts and deploy services.
  - Files:
    - `site.yml`
    - `ansible.cfg`
    - `group_vars/`
    - `roles/`
- `scripts/`
  - Convenience scripts to set up hosts, deploy with Terraform, snapshot, teardown, etc.
  - Files:
    - `configure-vms.sh`, `setup-host.sh`, `terraform-deploy.sh`, `snapshot-vms.sh`, `teardown.sh`
- `notes.txt`
  - Project notes / reminders.

## Typical workflow

> Exact steps depend on your Proxmox environment.

1. **Provision resources (Terraform)**
   - Update Terraform variables as needed (example: `terraform.tfvars` if present).
   - Run Terraform to create/update infrastructure.

2. **Configure resources (Ansible)**
   - Generate/update inventory (if your setup creates `inventory.ini`).
   - Run the playbook in `ansible/site.yml`.

3. **Operational helpers (scripts)**
   - Use scripts in `scripts/` for repeatable tasks (configure VMs, snapshot, teardown).

## Local development / safety notes

- Terraform state and plans are not meant to be committed.
- Avoid committing secrets (Terraform/Ansible variables containing credentials).

## Docs / references

- Terraform docs: https://developer.hashicorp.com/terraform/docs
- Ansible docs: https://docs.ansible.com/

