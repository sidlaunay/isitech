connection {
      type     = "ssh"
      user     = "jeremy"
      password = "321$oleiL"  # Remplacez par le mot de passe root
      host     = data.vsphere_virtual_machine.vm.guest_ip_address
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${data.vsphere_virtual_machine.vm.guest_ip_address},' /root/new_terraform/ansible/setup.yml"
  }
