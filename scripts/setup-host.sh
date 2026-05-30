#!/bin/bash

set -e

echo "=================================================="
echo "Installing Prerequisites on RHEL 9 AlmaLinux"
echo "=================================================="

# KVM/libvirt stack
echo "[1/4] Installing KVM/libvirt..."
sudo dnf install -y qemu-kvm libvirt libvirt-daemon-driver-qemu virt-manager virt-install

# Terraform
echo "[2/4] Installing Terraform..."
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf install -y terraform

# Ansible
echo "[3/4] Installing Ansible..."
sudo dnf install -y ansible-core

# Helper tools
echo "[4/4] Installing helper tools..."
sudo dnf install -y openssh-clients curl git jq

# Start and enable libvirt
echo "Starting libvirtd service..."
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

# Add user to libvirt group
echo "Adding $USER to libvirt group..."
sudo usermod -a -G libvirt $USER
newgrp libvirt

echo ""
echo "=================================================="
echo "Verifying installations..."
echo "=================================================="
terraform version
ansible --version
virsh list

echo ""
echo "=================================================="
echo "IMPORTANT: You may need to logout and login again"
echo "for group permissions (libvirt) to take effect."
echo "=================================================="
