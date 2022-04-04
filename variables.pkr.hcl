variable "vcenter_server" {
    description = "vCenter server to build the VM on"
}
variable "vcenter_username" {
    description = "Username to authenticate to vCenter"
}
variable "vcenter_password" {
    description = "Password to authenticate to vCenter"
}
variable "vcenter_cluster" {}
variable "vcenter_datacenter" {}
variable "vcenter_datastore" {}
variable "vcenter_folder" {
    description = "The vcenter folder to store the template"
}
variable "connection_username" {
    default = "packer"
}
variable "connection_password" {
    default = "packer"
}
variable "vm_hardware_version" {
    default = "18"
}
variable "iso_checksum" {}
variable "os_version" {}
variable "guest_os_type" {}
variable "root_disk_size" {
    default = 16384
}
variable "nic_type" {
    default = "vmxnet3"
}
variable "vm_network" { }
variable "num_cpu" {
    default = 2
}
variable "num_cores" {
    default = 1
}
variable "vm_ram" {
    default = 4096
}
variable "os_family" {
    description = "OS Family builds the paths needed for packer"
    default = ""
}
variable "os_iso_url" {
    description = "The download url for the ISO"
    default = ""
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. (e.g. 'efi-secure'. 'efi', or 'bios')"
  default     = "efi"
}

variable "build_key" {}
variable "build_username" {}
