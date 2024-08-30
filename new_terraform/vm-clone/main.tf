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

resource "vsphere_virtual_machine" "cloned_vm" {
  name             = "TF_CLONE-V3"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 25
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = "423b0c92-0afd-b220-67b4-23661831cf83"  # Utilisation de l'UUID spécifié
  }

  provisioner "local-exec" {
    command = "echo ${self.default_ip_address} > /tmp/terraform_ip.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-pip",
      "pip3 install ansible",
    ]

    connection {
      type        = "ssh"
      user        = "jeremy"
      password    = "321$oleiL"
      host        = self.default_ip_address
      port        = 22
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    ansible-playbook -i ${self.default_ip_address}, -u jeremy --private-key /etc/ssh/ssh_host_rsa_key /root/new_terraform/ansible/setup.yml
    EOT
  }

  lifecycle {
    ignore_changes = [network_interface]
  }
}
