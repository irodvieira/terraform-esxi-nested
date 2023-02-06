provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Datacenter-01"
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "Cluster-01"
  datacenter_id   = data.vsphere_datacenter.dc.id

  drs_enabled          = true
  drs_automation_level = "fullyAutomated"

  ha_enabled = true
}