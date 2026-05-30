#!/bin/bash

set -e

TERRAFORM_DIR="/home/emo3/code/proxmox/terraform"
ANSIBLE_DIR="/home/emo3/code/proxmox/ansible"
INVENTORY_FILE="$ANSIBLE_DIR/inventory.ini"

echo "=================================================="
echo "Proxmox Lab - Ansible Configuration (Automated)"
echo "=================================================="

# Step 1: Generate inventory from terraform output
echo "[1/4] Generating Ansible inventory from Terraform output..."

# Create header
cat > $INVENTORY_FILE << 'EOF'
[kvm_vms]
EOF

# Get VM IPs from terraform and append to inventory
cd $TERRAFORM_DIR
VM_IPS_JSON="$(terraform output -json vm_ips 2>/dev/null || true)"

if [ -z "$VM_IPS_JSON" ] || [ "$VM_IPS_JSON" = "{}" ]; then
  echo "ERROR: terraform output vm_ips is empty. Ensure VM networking/cloud-init is working before running Ansible." >&2
  echo "terraform output vm_ips:" >&2
  terraform output vm_ips >&2 || true
  exit 1
fi

# Append inventory entries
echo "$VM_IPS_JSON" | jq -r 'to_entries[] | "\(.key) ansible_host=\(.value) ansible_user=root"' >> $INVENTORY_FILE

# Fail fast if inventory ended up empty
if ! grep -q 'ansible_host=' "$INVENTORY_FILE"; then
  echo "ERROR: No inventory entries were generated from terraform output vm_ips." >&2
  exit 1
fi


# Add vars section
cat >> $INVENTORY_FILE << 'EOF'

[kvm_vms:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF

echo "Inventory generated:"
cat $INVENTORY_FILE

# Step 2: Test connectivity
echo ""
echo "[2/4] Testing Ansible connectivity to VMs (waiting for SSH)..."
cd $ANSIBLE_DIR

# Retry loop - VMs might still be booting
for i in {1..10}; do
    echo "Attempt $i/10: Testing connectivity..."
    if ansible kvm_vms -m ping -q 2>/dev/null | grep -q "pong"; then
        echo "✓ All VMs are reachable"
        break
    else
        echo "  VMs not ready yet, waiting 10 seconds..."
        sleep 10
    fi
done

# Step 3: Run Ansible playbook (no prompts, no vault)
echo ""
echo "[3/4] Running Ansible playbook (configuration in progress)..."
ansible-playbook site.yml --no-color -q

# Step 4: Verify configuration
echo ""
echo "[4/4] Verifying system configuration..."
ansible kvm_vms -m command -a "hostname" -q

echo ""
echo "=================================================="
echo "Ansible Configuration Complete!"
echo "=================================================="
echo ""
echo "VMs are configured and ready."
echo ""
echo "Available commands:"
echo "  # View system info:"
echo "  ansible kvm_vms -m command -a '/opt/scripts/sysinfo.sh'"
echo ""
echo "  # Create snapshots:"
echo "  ./snapshot-vms.sh"
echo ""
echo "  # Destroy everything:"
echo "  ./teardown.sh"
