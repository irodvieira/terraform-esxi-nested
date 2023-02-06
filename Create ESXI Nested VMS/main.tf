provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

## Data
data "vsphere_datacenter" "dc" {
  name = "Earthrealm"
}

data "vsphere_host" "host" {
  name          = "scorpion.earthrealm.local"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "LAB_ESXI2-STO1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "iso" {
  name          = "LAB_ESXI2-STO1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "scorpion.earthrealm.local/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net1" {
  name          = "EXT_TRUNK"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "net2" {
  name          = "EXT_TRUNK"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "net3" {
  name          = "EXT_TRUNK"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "net4" {
  name          = "EXT_TRUNK"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

### Resource

resource "vsphere_host" "scorpion" {
  hostname = "scorpion.earthrealm.local"
  username = "${var.esxi2_user}"
  password = "${var.esxi2_password}"
  datacenter = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "esxi" {
  count            = var.count_vm
  name             = "${var.vm_name}${count.index + 1}.lab.local"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus   = 8
  num_cores_per_socket = 8
  memory     = 24516
  wait_for_guest_net_timeout = 0
  guest_id = "vmkernel7Guest"
  nested_hv_enabled = true

  network_interface {
   network_id     = "${data.vsphere_network.net1.id}"
   adapter_type   = "vmxnet3"
  }
  network_interface {
   network_id     = "${data.vsphere_network.net2.id}"
   adapter_type   = "vmxnet3"
  }
   network_interface {
   network_id     = "${data.vsphere_network.net3.id}"
   adapter_type   = "vmxnet3"
  }
   network_interface {
   network_id     = "${data.vsphere_network.net4.id}"
   adapter_type   = "vmxnet3"
  }

  disk {
   size             = 40
   label             = "${var.disk}1"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 0
  }
  disk {
   size             = 60
   label             = "${var.disk}2"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 1
  }
  disk {
   size             = 60
   label             = "${var.disk}3"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 2
  }
  disk {
   size             = 80
   label             = "${var.disk}4"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 3
  }
  disk {
   size             = 80
   label             = "${var.disk}5"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 4
  }
  disk {
   size             = 80
   label             = "${var.disk}6"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 5
  }
  disk {
   size             = 80
   label             = "${var.disk}7"
   eagerly_scrub    = false
   thin_provisioned = true
   unit_number = 6
  }
  cdrom {
    datastore_id = data.vsphere_datastore.iso.id
    path         = "/ISO/VMware-VMvisor-Installer-7.0U3d-19482537.x86_64.iso"
  }
}