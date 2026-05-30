#!/bin/bash

set -e

echo "=================================================="
echo "Creating VM Snapshots"
echo "=================================================="

# Get VM names from terraform
cd /home/emo3/code/proxmox/terraform
VMS=$(terraform output -json vm_names | jq -r '.[]')

SNAPSHOT_NAME="snapshot-$(date +%Y%m%d-%H%M%S)"

for vm in $VMS; do
    echo "Creating snapshot '$SNAPSHOT_NAME' for $vm..."
    virsh snapshot-create-as "$vm" "$SNAPSHOT_NAME" "Automated snapshot - $(date)" --no-metadata
done

echo ""
echo "=================================================="
echo "Snapshots created successfully!"
echo "=================================================="
echo ""
echo "Restore from snapshot:"
echo "  virsh snapshot-revert vm-name snapshot-name"
echo ""
echo "List snapshots:"
echo "  virsh snapshot-list vm-name"
