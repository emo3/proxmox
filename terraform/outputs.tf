output "vm_names" {
  description = "Names of created VMs"
  value       = [for vm in libvirt_domain.vm : vm.name]
}

output "vm_macs" {
  description = "MAC addresses of created VMs (placeholder; requires libvirt domain interface attributes)"
  value       = []
}

# NOTE:
# The libvirt Terraform provider does not expose guest IP addresses directly.
# Until we switch to a seed-ISO + cloud-init + in-host discovery workflow,
# we return an empty map so downstream scripts can fail fast.
output "vm_ips" {
  description = "IP addresses of created VMs (empty until IP discovery is implemented)"
  value       = {}
}


output "network_info" {
  description = "Network information"
  value = {
    name = var.network_name
    cidr = var.network_cidr
  }
}


output "deploy_command" {
  description = "Command to deploy with Ansible"
  value       = "cd /home/emo3/code/proxmox && ./scripts/terraform-deploy.sh"
}
