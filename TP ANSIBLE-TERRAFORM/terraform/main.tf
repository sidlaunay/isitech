provider "vsphere" {
  user                 = "administrator@slaunay.com"
  password             = "&2i*nE#67Lgw2%2@A7"
  vsphere_server       = "vsphere.het.slaunay.com"
  allow_unverified_ssl = true
}
 
data "vsphere_datacenter" "Datacenter" {
  name = "Datacenter"
}
 
data "vsphere_datastore" "datastore" {
  name          = "ESXi-HET-HDD01"
  datacenter_id = data.vsphere_datacenter.Datacenter.id
}
 
data "vsphere_host" "host" {
  name          = "esxi.het.slaunay.com"
  datacenter_id = data.vsphere_datacenter.Datacenter.id
}
 
data "vsphere_resource_pool" "pool" {
  name          = "/Datacenter/host/esxi.het.slaunay.com/Resources"
  datacenter_id = data.vsphere_datacenter.Datacenter.id
}
 
data "vsphere_network" "network" {
  name          = "ESXiHET-MICROSOC-CLIENT-Network"
  datacenter_id = data.vsphere_datacenter.Datacenter.id
}
 
data "vsphere_virtual_machine" "template_vm" {
  name          = "example-vm-terraform"
  datacenter_id = data.vsphere_datacenter.Datacenter.id
}
 
resource "vsphere_virtual_machine" "cloned_vm" {
  name             = "copie-vm-terraform"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = data.vsphere_virtual_machine.template_vm.num_cpus
  memory   = data.vsphere_virtual_machine.template_vm.memory
  guest_id = data.vsphere_virtual_machine.template_vm.guest_id
 
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template_vm.network_interfaces[0].adapter_type
   }
 
  disk {
    label            = "disk0"
    size = data.vsphere_virtual_machine.template_vm.disks[0].size
    eagerly_scrub    = false
    thin_provisioned = true
  }
 
  clone {
    template_uuid = data.vsphere_virtual_machine.template_vm.id
 
    customize {
      linux_options {
        host_name = "cloned-vm"
        domain    = "slaunay.com"
      }
 
      network_interface {
        ipv4_address = "192.168.1.101"
        ipv4_netmask = 24
      }
 
      ipv4_gateway = "192.168.1.1"
    }
  }
}
