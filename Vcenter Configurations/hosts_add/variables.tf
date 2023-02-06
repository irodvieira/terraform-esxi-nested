variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "license_esxi" {}
variable "password_esxi" {}
variable "hosts" {
  default = [
    "esxi-01.lab.local",
    "esxi-02.lab.local",
    "esxi-03.lab.local",
  ]
}