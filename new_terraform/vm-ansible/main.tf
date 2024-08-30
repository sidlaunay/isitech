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

resource "null_resource" "vm_power_on" {
  provisioner "local-exec" {
    command = "export PATH=$PATH:/usr/local/bin/govc && govc vm.power -on -vm.uuid=503bc9be-14f6-6d1f-ef31-422123c3b272"
  }

  depends_on = [data.vsphere_virtual_machine.vm]
}

resource "null_resource" "vm_operations" {
  provisioner "remote-exec" {
    inline = [
      "echo 'Connected via SSH'"
    ]

    connection {
      type     = "ssh"
      user     = "user"
      password = "user"
      host     = "10.254.254.237"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '10.254.254.237,' /root/new_terraform/ansible/setup.yml"
  }

  depends_on = [null_resource.vm_power_on]
}
