source "vsphere-iso" "ubuntu" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = true
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  datastore           = var.vcenter_datastore
  convert_to_template = true
  folder              = var.vcenter_folder

  # VM Settings
  vm_name               = "${ var.os_family }-${ var.os_version }-{{ isotime \"2006-01-02\" }}"
  firmware              = var.vm_firmware
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "12h"
  ssh_port              = "22"
  ssh_handshake_attempts = "20"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_url               = var.os_iso_url
  iso_checksum          = var.iso_checksum

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

  # cloud-init configuration
  # When using the CDROM for the cloud-init files, it must be named 'cidata'
  # and to continue the autoinstall automatically the boot command needs 'autoinstall' added
  # https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
  cd_files = [
    "./boot_config/ubuntu-20.04/meta-data",
    "./boot_config/ubuntu-20.04/user-data"
  ]
  cd_label = "cidata"
  boot_wait             = "5s"
  boot_command = [
    "<esc><wait>",
    "linux /casper/vmlinuz --- autoinstall ds\"=nocloud\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
}

build {
  sources = [
      "source.vsphere-iso.ubuntu",
  ]
  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/main.yml"
    roles_path    = "${path.cwd}/ansible/roles"
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg"
    ]
    extra_arguments = [
      "--extra-vars", "display_skipped_hosts=false",
      "--extra-vars", "BUILD_USERNAME=${var.build_username}",
      "--extra-vars", "BUILD_SECRET='${var.build_key}'",
      "--extra-vars", "ANSIBLE_USERNAME=${var.build_username}",
      "--extra-vars", "ANSIBLE_SECRET='${var.build_key}'",
    ]
  }
}
