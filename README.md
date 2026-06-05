# Proxmox

This directory contains infrastructure automation for a Proxmox environment using **Terraform**, **Ansible**, and helper **shell scripts**.

## What’s here

Terraform lives in `proxmox/terraform/` (see `proxmox/terraform/README.md`).
Ansible lives in `proxmox/ansible/` (see `proxmox/ansible/README.md`).

## Typical workflow

> Exact steps depend on your Proxmox environment.

**Configure resources (Ansible)**
   - Generate/update inventory (if your setup creates `inventory.ini`).
   - Run the playbook in `ansible/site.yml`.

**Operational helpers (scripts)**
   - Use scripts in `scripts/` for repeatable tasks (configure VMs, snapshot, teardown).

## Local development / safety notes

- Terraform state and plans are not meant to be committed.
- Avoid committing secrets (Terraform/Ansible variables containing credentials).
- `proxmox/ansible/.passwd` is gitignored (see `proxmox/.gitignore`); regenerate/manage it locally as needed.

## Docs / references

- Terraform docs: https://developer.hashicorp.com/terraform/docs
- Ansible docs: https://docs.ansible.com/
