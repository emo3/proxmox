variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "kvm"
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vm_cpus" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "vm_disk_size" {
  description = "Disk size in bytes (default 20GB)"
  type        = number
  default     = 21474836480
}

variable "network_name" {
  description = "KVM network name"
  type        = string
  default     = "kvm-lab"
}

variable "network_cidr" {
  description = "Network CIDR"
  type        = string
  default     = "192.168.122.0/24"
}

variable "template_path" {
  description = "Path to AlmaLinux template image"
  type        = string
  default     = "/home/emo3/kvm-images/almalinux9-template.qcow2"
}

variable "ssh_public_key" {
  description = "SSH public key to inject into cloud-init"
  type        = string
  default     = ""
}

variable "cloudinit_seed_path" {
  description = "Directory to store generated cloud-init config-drive files"
  type        = string
  default     = "/var/lib/libvirt/images/kvm-lab"
}


variable "pool_path" {
  description = "Filesystem path backing the libvirt storage pool"
  type        = string
  default     = "/var/lib/libvirt/images/kvm-lab"
}

variable "domain_os_type" {
  description = "Libvirt domain os type"
  type        = string
  default     = "hvm"
}

variable "domain_arch" {
  description = "Libvirt domain architecture"
  type        = string
  default     = "x86_64"
}

