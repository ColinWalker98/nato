resource "null_resource" "add_servers_to_ssh_config" {
  provisioner "local-exec" {
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ssh_config.sh ${aws_eip.jumphost.public_ip} ${aws_instance.application.private_ip} ${aws_instance.database.private_ip} ${var.stage}"
  EOT
  }
}

resource "null_resource" "add_servers_to_ansible_hosts_ini" {
  provisioner "local-exec" {
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ansible_hosts.sh ${var.stage}"
  EOT
  }
}

data "template_file" "host_vars_jumphost" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST = "${var.stage}-jumphost"
    SERVER__HOSTNAME = "${var.stage}-jumphost@local"
  }
}

data "template_file" "host_vars_app" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST = "${var.stage}-app"
    SERVER__HOSTNAME = "${var.stage}-app@local"
  }
}

data "template_file" "host_vars_db" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST = "${var.stage}-db"
    SERVER__HOSTNAME = "${var.stage}-db@local"
  }
}

resource "local_file" "host_vars_jumphost" {
  content  = data.template_file.host_vars_jumphost.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-jumphost"
}

resource "local_file" "host_vars_app" {
  content  = data.template_file.host_vars_app.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-app"
}

resource "local_file" "host_vars_db" {
  content  = data.template_file.host_vars_db.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-db"
}


resource "null_resource" "provision_automation_user_on_instances" {
  provisioner "local-exec" {
    command = "ansible-playbook books/provision_automation_user.yaml -e 'ansible_user=ubuntu' -e 'ansible_ssh_private_key_file=~/.ssh/id_rsa' -e 'target_servers=${var.stage}-jumphost,${var.stage}-app,${var.stage}-db'"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_USER = "ubuntu"
      ANSIBLE_SSH_PRIVATE_KEY = "~/.ssh/id_rsa"
    }
    working_dir = "../../ansible"
  }
}