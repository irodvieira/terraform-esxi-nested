provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter-01"
}

data "vsphere_host" "host" {
  count         = length(var.esxi_hosts)
  name          = var.esxi_hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_distributed_virtual_switch" "vds" {
  name          = "vds-trunk"
  datacenter_id = data.vsphere_datacenter.datacenter.id

  uplinks         = ["uplink1", "uplink2", "uplink3", "uplink4"]
  active_uplinks  = ["uplink1", "uplink2"]
  standby_uplinks = ["uplink3", "uplink4"]

  host {
    host_system_id = data.vsphere_host.host.0.id
    devices        = "${var.network_interfaces}"
  }

  host {
    host_system_id = data.vsphere_host.host.1.id
    devices        = "${var.network_interfaces}"
  }

  host {
    host_system_id = data.vsphere_host.host.2.id
    devices        = "${var.network_interfaces}"
  }
}

resource "vsphere_distributed_port_group" "pg" {
  name                            = "pg-mgmt"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.vds.id

  vlan_id = 1
}