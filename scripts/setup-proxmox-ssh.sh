#!/bin/bash
# ================================================
# Proxmox SSH Key Setup - Safe & Complete
# ================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ANSIBLE_DIR="$(cd "$SCRIPT_DIR/../ansible" && pwd)"
INVENTORY="$ANSIBLE_DIR/inventory.ini"
PLAYBOOK="$ANSIBLE_DIR/setup-ssh-key.yml"
PASSWD_FILE="$ANSIBLE_DIR/.passwd"
KEY_PATH="$HOME/.ssh/id_ed25519_proxmox"

echo "=== Proxmox SSH Key Authentication Setup ==="
echo "Ansible directory: $ANSIBLE_DIR"

# Create ansible directory if missing
mkdir -p "$ANSIBLE_DIR"

# 1. Create inventory.ini if missing
if [ ! -f "$INVENTORY" ]; then
    echo "→ Creating inventory.ini"
    cat > "$INVENTORY" << 'INVENTORY_EOF'
[kvm_vms]
proxmox-lab ansible_host=192.168.122.159 ansible_user=root

[kvm_vms:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
INVENTORY_EOF
else
    echo "→ inventory.ini already exists"
fi

# 2. Create setup-ssh-key.yml if missing
if [ ! -f "$PLAYBOOK" ]; then
    echo "→ Creating setup-ssh-key.yml"
    cat > "$PLAYBOOK" << 'PLAYBOOK_EOF'
---
- name: Bootstrap SSH Key Authentication for Proxmox
  hosts: kvm_vms
  gather_facts: no
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    ssh_key_path: "{{ lookup('env', 'HOME') }}/.ssh/id_ed25519_proxmox"

  tasks:

    - name: Deploy SSH public key
      authorized_key:
        user: root
        state: present
        key: "{{ lookup('file', ssh_key_path + '.pub') }}"
        comment: "ansible-proxmox"
        manage_dir: yes

    - name: Disable password authentication
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^#?PasswordAuthentication'
        line: 'PasswordAuthentication no'
      notify: Restart SSH

  handlers:
    - name: Restart SSH
      service:
        name: sshd
        state: restarted
PLAYBOOK_EOF
else
    echo "→ setup-ssh-key.yml already exists"
fi

# 3. Create .passwd if missing
if [ ! -f "$PASSWD_FILE" ]; then
    echo "→ Creating .passwd file"
    echo "SuperSecretPassword123!" > "$PASSWD_FILE"
    chmod 600 "$PASSWD_FILE"
else
    echo "→ .passwd already exists"
fi

# 4. Generate SSH key if missing
if [ ! -f "$KEY_PATH" ]; then
    echo "→ Generating SSH key..."
    ssh-keygen -t ed25519 -C "ansible-proxmox" -f "$KEY_PATH" -N "" -q
else
    echo "→ SSH key already exists"
fi

echo ""
echo "✅ File setup completed."
echo ""
echo "→ Running Ansible playbook to deploy SSH key..."

# Run the playbook
if [ -f "$PASSWD_FILE" ]; then
    ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --extra-vars "ansible_ssh_pass=$(cat $PASSWD_FILE)"
else
    ansible-playbook -i "$INVENTORY" "$PLAYBOOK" --ask-pass
fi

# 5. Add to ~/.ssh/config if not present
if ! grep -q "Host proxmox-lab" ~/.ssh/config 2>/dev/null; then
    echo "→ Adding easy SSH alias to ~/.ssh/config..."
    cat >> ~/.ssh/config << CONFIG_EOF

Host proxmox-lab
    HostName 192.168.122.159
    User root
    IdentityFile $KEY_PATH
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
CONFIG_EOF
fi

echo ""
echo "🎉 Setup Finished!"
echo ""
echo "=== How to Test the Connection ==="
echo ""
echo "1. Test with full key path:"
echo "   ssh -i $KEY_PATH root@192.168.122.159"
echo ""
echo "2. Test with alias (recommended):"
echo "   ssh proxmox-lab"
echo ""
echo "If both work without asking for password → Success!"
echo ""
echo "You can now run Ansible playbooks without --ask-pass."
