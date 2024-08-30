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

  name          = "/Datacenter/host/esxi.het.slaunay.com/Resources"  # Chemin complet du Resource Pool

  datacenter_id = data.vsphere_datacenter.Datacenter.id

}
 
data "vsphere_network" "network" {

  name          = "ESXiHET-MICROSOC-CLIENT-Network"

  datacenter_id = data.vsphere_datacenter.Datacenter.id

}
 
resource "vsphere_virtual_machine" "vm" {

  name             = "TF_TEST"

  resource_pool_id = data.vsphere_resource_pool.pool.id

  datastore_id     = data.vsphere_datastore.datastore.id
 
  num_cpus = 2

  memory   = 2048

  guest_id = "otherLinux64Guest"
 
  network_interface {

    network_id = data.vsphere_network.network.id

  }
 
  disk {

    label = "disk0"

    size  = 20

  }

}

 
