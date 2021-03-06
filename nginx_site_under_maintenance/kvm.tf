terraform {
  required_version = "= 0.12.30"
}

provider "libvirt" {
  uri = "qemu:///system"
}

# get the latest ubuntu kvm image
resource "libvirt_volume" "os_image" {
  name   = "${var.hostname}-os_image"
  pool   = "default"
  source = var.image
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.hostname
    fqdn     = "${var.hostname}.${var.domain}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network.cfg")
}

# Use CloudInit ISO
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.hostname}-commoninit.iso"
  pool           = "default"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  name   = var.hostname
  memory = var.memory
  vcpu   = var.cpu

  disk {
    volume_id = libvirt_volume.os_image.id
  }
  network_interface {
    network_name = "default"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}

# If there is no output run "terraform refresh"
output "metadata" {
  value = libvirt_domain.domain-ubuntu.network_interface.*.addresses
}
