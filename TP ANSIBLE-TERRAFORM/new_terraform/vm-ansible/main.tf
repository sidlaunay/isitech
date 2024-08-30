provider "vsphere" {
  user                 = "administrator@slaunay.com"
  password             = "&2i*nE#67Lgw2%2@A7"
  vsphere_server       = "vsphere.het.slaunay.com"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_virtual_machine" "vm" {
  moid          = "vm-2292"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm_power_on" {
  name             = data.vsphere_virtual_machine.vm.name
  resource_pool_id = data.vsphere_virtual_machine.vm.resource_pool_id
  datastore_id     = data.vsphere_virtual_machine.vm.datastore_id

  lifecycle {
    ignore_changes = all
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'VM is powered on'"
    ]

    connection {
      type     = "ssh"
      user     = "jeremy"
      password = "321$oleiL"
      host     = "10.254.254.237"
    }
  }
}

output "vm_state" {
  value = data.vsphere_virtual_machine.vm.power_state
}
