provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_host}:8006/api2/json"
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token
  pm_tls_insecure     = true
  pm_debug            = true
}

locals {
  default_cores     = 2
  default_memory_mb = 4096
  default_disk_gb   = 30
  old_vmid          = 3000
  new_vmid          = 3001
}

resource "proxmox_lxc" "gitlab_old" {
  target_node = var.proxmox_node
  hostname    = var.gitlab_old_name
  ostemplate  = var.lxc_template
  ostype      = "debian"

  vmid         = local.old_vmid
  unprivileged = true
  cores        = local.default_cores
  memory       = local.default_memory_mb
  swap         = 1024

  rootfs {
    storage = var.lxc_storage
    size    = "${local.default_disk_gb}G"
  }

  network {
    name   = "eth0"
    bridge = var.lxc_network_bridge
    ip     = var.use_static_ip ? var.lxc_static_ip_old : "dhcp"
    gw     = var.use_static_ip ? var.lxc_gateway : null
  }

  ssh_public_keys = var.ssh_public_key
  onboot          = true

  lifecycle {
    ignore_changes = [network]
  }
}

resource "proxmox_lxc" "gitlab_new" {
  target_node = var.proxmox_node
  hostname    = var.gitlab_new_name
  ostemplate  = var.lxc_template
  ostype      = "debian"

  vmid         = local.new_vmid
  unprivileged = true
  cores        = local.default_cores
  memory       = local.default_memory_mb
  swap         = 1024

  rootfs {
    storage = var.lxc_storage
    size    = "${local.default_disk_gb}G"
  }

  network {
    name   = "eth0"
    bridge = var.lxc_network_bridge
    ip     = var.use_static_ip ? var.lxc_static_ip_new : "dhcp"
    gw     = var.use_static_ip ? var.lxc_gateway : null
  }

  ssh_public_keys = var.ssh_public_key
  onboot          = true

  lifecycle {
    ignore_changes = [network]
  }
}