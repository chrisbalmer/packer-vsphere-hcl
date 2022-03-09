source "vsphere-iso" "ubuntu" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = true #TODO: Add ca to docker
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  datastore           = var.vcenter_datastore
  convert_to_template = true
  folder              = var.vcenter_folder

  # VM Settings
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "12h"
  ssh_port              = "22"
  ssh_handshake_attempts = "20"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_url             = var.os_iso_url
  iso_checksum          = var.iso_checksum
  cd_files = [
    "./boot_config/ubuntu-20.04/meta-data",
    "./boot_config/ubuntu-20.04/user-data"
  ]
  cd_label = "cidata"
  vm_name               = "${ var.os_family }-${ var.os_version }-{{ isotime \"2006-01-02\" }}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"]
  network_adapters {
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  boot_wait             = "5s"
  boot_command = [
    "<esc><esc><esc>",
    "<enter><wait>",
    "/casper/vmlinuz ",
    "initrd=/casper/initrd ",
    "autoinstall ",
    "<enter>"
  ]
}

build {
    sources = [
        "source.vsphere-iso.ubuntu",
    ]
    provisioner "shell" {
      execute_command = "echo '${var.connection_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'" # This runs the scripts with sudo
      scripts = [
          "scripts/apt.sh",
          "scripts/cleanup.sh",
          "scripts/ubuntu-prep.sh",
          "scripts/clean-ssh-hostkeys.sh"
      ]
    }
}
