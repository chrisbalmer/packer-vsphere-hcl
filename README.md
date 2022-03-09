# Packer with HCL and vsphere-iso

I used this as a template to build out a working Ubuntu 20.04 build with cloud-init. In this branch, everything else has been removed. There are some tweaks left to get a minimal and clean install, I still need to validate what is required for VMware Tools and other items.

I removed the http configurations and the legacy seed process to auto install Ubuntu and finished building out the cloud-init items. These are loaded on a cdrom which is attached to the VM instead of using the packer http server. I also changed the Ubuntu ISO to be loaded from a URL instead of storage in vSphere. Packer will download the ISO and then upload it to a cache on vSphere using the same datastore the VM is being built on.

Also all user information was changed over to `ansible` instead of `vagrant`.

For building this, there is an expectation that you're using 1Password and the CLI tool for that is logged in. Swap out the path to your vCenter credentials in the `env.sh` file which will populate them into environment variables to be used by Packer.

```bash
source env.sh
packer build --only vsphere-iso.ubuntu --var-file=20.04.pkrvars.hcl .
```
