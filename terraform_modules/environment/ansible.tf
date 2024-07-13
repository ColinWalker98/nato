# Triggers a local bash script that will add the provisioned servers to your personal ssh configuration file.
# This will be at ~/.ssh/config. In case there are any existing configurations present with the same hostname,
# these will be removed and the new configuration will be added to ensure the latest and updated values.
# Upon a terraform destroy, the entries will be removed from the ssh config.
resource "null_resource" "modify_ssh_config" {
  triggers = {
    stage = var.stage
    env_name = var.env_name
    j_pub_ip = aws_eip.jumphost.public_ip
    app_priv_ip = aws_instance.application.private_ip
    db_priv_ip = aws_instance.database.private_ip
  }

  provisioner "local-exec" {
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ssh_config.sh addition ${self.triggers.j_pub_ip} ${self.triggers.app_priv_ip} ${self.triggers.db_priv_ip} ${self.triggers.stage} ${self.triggers.env_name}"
  EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ssh_config.sh removal ${self.triggers.j_pub_ip} ${self.triggers.app_priv_ip} ${self.triggers.db_priv_ip} ${self.triggers.stage} ${self.triggers.env_name}"
  EOT
  }
}

# Triggers a bash script that will add the new servers to the ansible inventory host file.
# Upon a terraform destroy, the entries will be removed from the ansible inventory host file.
resource "null_resource" "modify_ansible_hosts_ini" {
  triggers = {
    stage = var.stage
    env_name = var.env_name
  }

  #${self.triggers.project_id}
  provisioner "local-exec" {
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ansible_hosts.sh addition ${self.triggers.stage}-${self.triggers.env_name}"
  EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
    bash -c "../../terraform_modules/environment/scripts/update_ansible_hosts.sh removal ${self.triggers.stage}-${self.triggers.env_name}"
  EOT
  }
}

# Prepare template file for the host variables for the jumphost server.
data "template_file" "host_vars_jumphost" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST        = "${var.stage}-${var.env_name}-jumphost"
    SERVER__HOSTNAME = "${var.stage}-${var.env_name}-jumphost@local"
  }
}

# Prepare template file for the host variables for the application server.
data "template_file" "host_vars_app" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST        = "${var.stage}-${var.env_name}-app"
    SERVER__HOSTNAME = "${var.stage}-${var.env_name}-app@local"
  }
}

# Prepare template file for the host variables for the database server.
data "template_file" "host_vars_db" {
  template = file("../../terraform_modules/environment/templates/ansible_hostvar.tpl")
  vars = {
    SSH__HOST        = "${var.stage}-${var.env_name}-db"
    SERVER__HOSTNAME = "${var.stage}-${var.env_name}-db@local"
  }
}

# Renders the jumphost server host vars template.
resource "local_file" "host_vars_jumphost" {
  content  = data.template_file.host_vars_jumphost.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-${var.env_name}-jumphost"
}

# Renders the application server host vars template.
resource "local_file" "host_vars_app" {
  content  = data.template_file.host_vars_app.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-${var.env_name}-app"
}

# Renders the database server host vars template.
resource "local_file" "host_vars_db" {
  content  = data.template_file.host_vars_db.rendered
  filename = "../../ansible/inventory/${var.stage}/host_vars/${var.stage}-${var.env_name}-db"
}

# Triggers an ansible playbook to provision the automation user, permissions and authorised key.
# This is to avoid using personal keys after the setup has been completed.
# Ansible will use a dedicated automation user and keypair.
resource "null_resource" "provision_automation_user_on_instances" {
  provisioner "local-exec" {
    command = "ansible-playbook books/provision_automation_user.yaml -e 'ansible_user=ubuntu' -e 'ansible_ssh_private_key_file=~/.ssh/id_rsa' -e 'target_servers=${var.stage}-${var.env_name}-jumphost,${var.stage}-${var.env_name}-app,${var.stage}-${var.env_name}-db'"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_USER              = "ubuntu"
      ANSIBLE_SSH_PRIVATE_KEY   = "~/.ssh/id_rsa"
    }
    working_dir = "../../ansible"
  }
}