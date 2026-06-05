# Proxmox

This directory contains infrastructure automation for a Proxmox environment using **Terraform**, **Ansible**, and helper **shell scripts**.

## What’s here

ANSIBLE_DIR="/home/emo3/code/proxmox/ansible"

cd "$ANSIBLE_DIR"

ansible-playbook create-initial-box.yml

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

## Docs / references

- Terraform docs: https://developer.hashicorp.com/terraform/docs
- Ansible docs: https://docs.ansible.com/
