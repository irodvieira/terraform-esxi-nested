provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

resource "vsphere_datacenter" "prod_datacenter" {
  name = "Datacenter-01"
}
