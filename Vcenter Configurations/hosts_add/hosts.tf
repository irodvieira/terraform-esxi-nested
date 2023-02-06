provider "vsphere" {
    vsphere_server = "${var.vsphere_server}"
    user = "${var.vsphere_user}"
    password = "${var.vsphere_password}"
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter-01"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host_thumbprint" "esxi-1" {
  address = "esxi-1.lab.local"
  insecure = true
}

data "vsphere_host_thumbprint" "esxi-2" {
  address = "esxi-2.lab.local"
  insecure = true
}

data "vsphere_host_thumbprint" "esxi-3" {
  address = "esxi-3.lab.local"
  insecure = true
}

resource "vsphere_host" "esxi-1" {
  hostname = "esxi-1.lab.local"
  username = "root"
  password = var.password_esxi
  thumbprint = data.vsphere_host_thumbprint.esxi-1.id
  cluster  = data.vsphere_compute_cluster.cluster.id
  maintenance = true
}

resource "vsphere_host" "esxi-2" {
  hostname = "esxi-2.lab.local"
  username = "root"
  password = var.password_esxi
  thumbprint = data.vsphere_host_thumbprint.esxi-2.id
  cluster  = data.vsphere_compute_cluster.cluster.id
  maintenance = true
}

resource "vsphere_host" "esxi-3" {
  hostname = "esxi-3.lab.local"
  username = "root"
  password = var.password_esxi
  thumbprint = data.vsphere_host_thumbprint.esxi-3.id
  cluster  = data.vsphere_compute_cluster.cluster.id
  maintenance = true
}