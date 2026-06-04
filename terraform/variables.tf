variable "proxmox_host" {
  type        = string
  description = "Proxmox API host (DNS name or IP)."
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token identifier (e.g., user!tokenid)."
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API token secret."
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "If true, allow self-signed TLS certificates."
  default     = true
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name."
}

variable "lxc_template" {
  type        = string
  description = "LXC template (e.g. local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst)."
}

variable "lxc_storage" {
  type        = string
  description = "LXC root filesystem storage."
}

variable "lxc_network_bridge" {
  type        = string
  description = "Network bridge (e.g. vmbr0)."
}

variable "lxc_architecture" {
  type        = string
  description = "Architecture (amd64/arm64)."
  default     = "amd64"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key installed into the LXC."
}

variable "gitlab_old_name" {
  type        = string
  default     = "gitlab-old"
}

variable "gitlab_new_name" {
  type        = string
  default     = "gitlab-new"
}

variable "use_static_ip" {
  type        = bool
  description = "Require static IPs for deterministic Ansible targeting. DHCP-less automation currently expects true."
  default     = true
}


variable "lxc_static_ip_old" {
  type        = string
  default     = "192.168.122.200/24"
}

variable "lxc_static_ip_new" {
  type        = string
  default     = "192.168.122.201/24"
}

variable "lxc_gateway" {
  type        = string
  default     = "192.168.122.1"
}

