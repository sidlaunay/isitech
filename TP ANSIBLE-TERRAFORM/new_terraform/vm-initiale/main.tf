provider "vsphere" {
  user                 = "administrator@slaunay.com"
  password             = "&2i*nE#67Lgw2%2@A7"
  vsphere_server       = "vsphere.het.slaunay.com"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "ESXi-HET-NVMe01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "esxi.het.slaunay.com"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "/Datacenter/host/esxi.het.slaunay.com/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "ESXiHET-MICROSOC-CLIENT-Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "vm-test-terra"  # Nom du template que vous souhaitez utiliser
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "TF-TEST-NVME"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template.guest_id

  wait_for_guest_net_timeout = 0  # Disables waiting for IP address

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = 25
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  lifecycle {
    ignore_changes = [network_interface]
  }
}
