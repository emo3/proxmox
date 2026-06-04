# GitLab (Docker) with Chainguard/Wolfi-style hardened base

This folder contains a *template* for building a custom GitLab image.

## Important
GitLab is typically installed via the official Omnibus packages which are Debian/Ubuntu-oriented.
A Wolfi/alpine base may require non-trivial adjustments.

The goal of this automation is to:
- build a hardened image
- run GitLab with persistent volumes
- support A/B rollout (old/new) managed by Ansible

## Next steps (implementation work)
1) Replace `Dockerfile` with a working, environment-appropriate GitLab installation.
   - Either:
     - use a compatible hardened base that supports omnibus deps, or
     - use a prebuilt GitLab image and layer hardening on top.
2) Use `compose.yml` (or a rollout-specific compose template) to run old/new on different ports.

## Rollout
Actual rollout and data migration should be implemented in Ansible:
- start old
- start new on different ports
- migrate `/etc/gitlab` and `/var/opt/gitlab`
- verify
- cutover
- stop/delete old

