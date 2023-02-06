provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter-01"
}

data "data.vsphere_distributed_virtual_switch" "vds" {
  name = "vds-trunk"
}

data "vsphere_host" "host" {
  count         = length(var.esxi_hosts)
  name          = var.esxi_hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_vnic" "v1" {
  count = "${length(var.esxi_hosts)}"
  host = "${element(data.vsphere_host.host.*.id, count.index)}"
  distributed_switch_port = data.vsphere_distributed_virtual_switch.vds.id
  distributed_port_group  = vsphere_distributed_port_group.p1.id
  ipv4 {
    ip = "10.6.98.${50 + count.index}"
    netmask = "255.255.255.0"
    gw = "10.6.98.15"
  }
  netstack = "defaultTcpipStack"
}

resource "vsphere_distributed_port_group" "p2" {
  name                            = "pg-vmotion"
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.vds.id

  vlan_id = 60

  active_uplinks  = ["uplink3", "uplink4"]
  standby_uplinks = ["uplink1", "uplink2"]
  allow_forged_transmits = true
  allow_mac_changes = true
  allow_promiscuous = true
}
resource "vsphere_vnic" "v2" {
  count = "${length(var.esxi_hosts)}"
  host = "${element(data.vsphere_host.host.*.id, count.index)}"
  distributed_switch_port = data.vsphere_distributed_virtual_switch.vds.id
  distributed_port_group  = vsphere_distributed_port_group.p2.id
  ipv4 {
    ip = "10.80.98.${50 + count.index}"
    netmask = "255.255.255.0"
  }
  netstack = "vmotion"
}
