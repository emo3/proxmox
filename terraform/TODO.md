# TODO: Terraform Proxmox (LXC) + Automated GitLab (Chainguard/Wolfi-style) Rollouts

## Goal
Automate GitLab Docker deployments on Proxmox via Terraform (LXC) and Ansible, with a safe lifecycle:
1) update as needed
2) bring up new GitLab and copy data
3) verify new
4) turn off old
5) delete old when allowed

## Work items

### A) Terraform (Proxmox LXC)
- [ ] Create Terraform scaffolding under `proxmox/terraform/`.
- [ ] Configure Proxmox provider (API token / user+password, TLS settings).
- [ ] Create an LXC container for GitLab.
- [ ] Configure cloud-init / SSH access for Ansible.
- [ ] Output container name + IP for Ansible.

### B) GitLab container image build (Chainguard base)
- [ ] Create `proxmox/gitlab/` folder.
- [ ] Add `Dockerfile` using a Chainguard/Wolfi-style hardened base.
- [ ] Add runtime configuration (env + ports) via compose or scripts.

### C) Automated GitLab rollout strategy
- [ ] Implement Ansible playbook(s) for:
  - [ ] Detect current (old) GitLab container/installation.
  - [ ] Deploy a new GitLab instance (new container name / new volumes).
  - [ ] Copy/migrate GitLab persistent data from old to new.
  - [ ] Run health checks / verification steps.
  - [ ] Switch traffic (or symbolic “active” container) if applicable.
  - [ ] Stop old instance.
  - [ ] Delete old instance when allowed (flag).

### D) Docs + examples
- [ ] `terraform/README.md` with prerequisites + usage.
- [ ] `terraform/terraform.tfvars.example` (no secrets).
- [ ] `gitlab/README.md` with build + deploy instructions.

### E) Validation
- [ ] `terraform init && terraform validate && terraform plan`
- [ ] Run Ansible playbook against a provisioned LXC
- [ ] Verify GitLab health + data availability

