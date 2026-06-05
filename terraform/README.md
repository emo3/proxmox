# Proxmox Terraform (LXC) + Automated GitLab Rollouts

This directory will contain Terraform code to provision Proxmox **LXC** containers for GitLab, and expose IPs for Ansible-based GitLab deployment.

## Prerequisites
- Terraform installed locally.
- Access to Proxmox API:
  - Option A: API token credentials
  - Option B: username/password
- SSH key to be installed into the LXCs so Ansible can manage them.

## Suggested usage
1) Configure `terraform.tfvars` (or `terraform.tfvars.example` first).
2) Run:

```bash
cd proxmox/terraform
terraform init
terraform validate
terraform plan
terraform apply
```

## Outputs
Terraform will output (names + IPs) for `gitlab-old` and `gitlab-new` so Ansible can deploy and do the rollout.

## Notes
- Do not commit secrets.
- Terraform state should be stored remotely for safety in real environments.

