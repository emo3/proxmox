#!/bin/bash

set -e

TERRAFORM_DIR="/home/emo3/code/proxmox/terraform"

echo "=================================================="
echo "WARNING: Destroying all VMs and infrastructure!"
echo "=================================================="
echo ""
echo "This will delete:"
echo "  - All VMs"
echo "  - Disks"
echo "  - Network"
echo "  - Snapshots"
echo ""

# Only destroy if user explicitly runs with --confirm flag
if [ "$1" != "--confirm" ]; then
    echo "To confirm destruction, run:"
    echo "  ./teardown.sh --confirm"
    exit 0
fi

cd $TERRAFORM_DIR

echo "Destroying infrastructure (auto-approved)..."
terraform destroy -auto-approve -no-color

echo ""
echo "=================================================="
echo "All infrastructure destroyed!"
echo "=================================================="
