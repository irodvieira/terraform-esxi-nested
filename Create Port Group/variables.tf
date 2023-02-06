variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "esxi_hosts" {
  default = [
    "esxi-1.lab.local",
    "esxi-2.lab.local",
    "esxi-3.lab.local",
  ]
}
variable "network_interfaces" {
  default = [
    "vmnic0",
    "vmnic1",
    "vmnic2",
    "vmnic3",
  ]
}