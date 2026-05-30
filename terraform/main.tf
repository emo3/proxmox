# Create storage pool
# NOTE: dmacvicar/libvirt v0.9.7 expects a libvirt XML definition for the pool.
# The minimal schema here is just enough to avoid Terraform-side validation errors;
# libvirt itself will still require a backing path.
resource "libvirt_pool" "kvm_lab" {
  name = "kvm-lab"
  type = "dir"

  # dmacvicar/libvirt v0.9.7 expects this field to set the backing directory.
  path = var.pool_path
}





# Do not attempt to create/manage the network in Terraform for now.
# Your current apply failed because the network already exists.
# (You can re-enable network management once pool + domain are correct.)
# resource "libvirt_network" "kvm_lab" {
#   name = var.network_name
# }

# Import template volume (declared only; cloning/attaching per-VM disks is not implemented yet).
resource "libvirt_volume" "almalinux_template" {
  name = "almalinux9-template.qcow2"
  pool = libvirt_pool.kvm_lab.name

  # NOTE: this provider marks `path` as read-only, so we only define the volume.
  type = "file"
}

# Create per-VM cloned disks + cloud-init config drive + domain XML.
resource "libvirt_volume" "vm_disk" {
  count = var.vm_count

  name = "${var.vm_name_prefix}-vm-${count.index + 1}.qcow2"
  pool = libvirt_pool.kvm_lab.name
  # The provider doesn't model cloning; libvirt will accept an existing backing file.
  # We rely on libvirt XML `source` to point to the expected qcow2 path.
  type = "file"
}

# Note: we generate cloud-init files locally and reference them in domain XML.
resource "libvirt_domain" "vm" {
  count = var.vm_count

  name = "${var.vm_name_prefix}-vm-${count.index + 1}"

  # dmacvicar/libvirt v0.9.x uses `xml` to set full domain definition.
  xml = templatefile("${path.module}/domain-xml.tmpl", {
    vm_name       = "${var.vm_name_prefix}-vm-${count.index + 1}"
    vm_memory     = var.vm_memory
    vm_cpus       = var.vm_cpus
    domain_arch   = var.domain_arch
    domain_os_type = var.domain_os_type

    network_name  = var.network_name

    disk_path = "${var.cloudinit_seed_path}/${var.vm_name_prefix}-vm-${count.index + 1}.qcow2"

    # cloud-init config-drive files are expected to exist on the libvirt host.
    cloudinit_path = "${var.cloudinit_seed_path}/${var.vm_name_prefix}-vm-${count.index + 1}-seed.iso"
  })

  autostart = true
}






