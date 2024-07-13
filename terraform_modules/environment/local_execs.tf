provisioner "local-exec" {
  command = <<-EOT
    bash -c "scripts/update_ssh_config.sh ${aws_instance.jumphost.private_ip} ${aws_instance.application.private_ip} ${aws_instance.database.private_ip} ${var.stage}"
  EOT
  when    = "apply"
}

#resource "null_resource" "add_automation_user" {
#  provisioner "local-exec" {
#    command = "ansible-playbook books/provision_automation_user.yaml -e 'ansible_user=ubuntu' -e 'ansible_ssh_private_key_file=~/.ssh/id_rsa' -e 'target_servers=${join(",",data.terraform_remote_state.setup-state.outputs.servers)}'"
#    environment = {
#      ANSIBLE_HOST_KEY_CHECKING = "False"
#      ANSIBLE_USER = "ubuntu"
#      ANSIBLE_SSH_PRIVATE_KEY = "~/.ssh/id_rsa"
#    }
#    working_dir = "../../ansible"
#  }
#}