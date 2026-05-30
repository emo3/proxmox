#!/bin/bash

set -e

TERRAFORM_DIR="/home/emo3/code/proxmox/terraform"
ANSIBLE_DIR="/home/emo3/code/proxmox/ansible"
TEMPLATE_PATH="/home/emo3/kvm-images/almalinux9-template.qcow2"

echo "=================================================="
echo "Proxmox Lab - Terraform Deployment (Automated)"
echo "=================================================="

# Check template exists (download if missing)
TEMPLATE_URL="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "Template not found at $TEMPLATE_PATH"
    echo "Downloading AlmaLinux cloud image template..."
    mkdir -p "$(dirname "$TEMPLATE_PATH")"
    wget -O "$TEMPLATE_PATH" "$TEMPLATE_URL"
fi

# Final sanity check
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "ERROR: Template download failed; still missing at $TEMPLATE_PATH"
    exit 1
fi

# Step 1: Terraform init

echo "[1/4] Initializing Terraform..."
cd $TERRAFORM_DIR
terraform init -no-color

# Step 2: Terraform plan
echo "[2/4] Planning infrastructure (no prompts)..."
terraform plan -out=tfplan -no-color

# Step 3: Terraform apply (AUTO-APPROVE - NO PROMPTS)
echo "[3/4] Applying Terraform configuration (auto-approved)..."
terraform apply -auto-approve -no-color tfplan

# Step 4: Wait and get output
echo "[4/4] Waiting for terraform output vm_ips to become available..."
# Wait (instead of fixed sleep) so downstream inventory generation is deterministic
for i in {1..30}; do
    VM_IPS_JSON="$(terraform output -json vm_ips 2>/dev/null || true)"
    if [ -n "$VM_IPS_JSON" ] && [ "$VM_IPS_JSON" != "{}" ]; then
        echo "✓ vm_ips is available"
        break
    fi
    echo "  Attempt $i/30: vm_ips not ready yet; waiting 10 seconds..."
    sleep 10
    # If Terraform output still isn’t ready, we’ll still proceed; configure-vms.sh will fail fast.
    if [ "$i" -eq 30 ]; then
        echo "WARNING: vm_ips never became available during the wait window. configure-vms.sh will fail fast." >&2
    fi
done


echo ""
echo "=================================================="
echo "VMs Created Successfully!"
echo "=================================================="

# Get VM info
cd $TERRAFORM_DIR
echo ""
echo "VM Information:"
terraform output -no-color vm_ips

echo ""
echo "Network Information:"
terraform output -no-color network_info

echo ""
echo "=================================================="
echo "Terraform Deployment Complete!"
echo "=================================================="
echo ""
echo "Next: Run Ansible configuration"
echo "  cd $ANSIBLE_DIR"
echo "  ./configure-vms.sh"
