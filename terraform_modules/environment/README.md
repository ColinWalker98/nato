<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.application](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/eip) | resource |
| [aws_eip.database](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/eip) | resource |
| [aws_eip.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/eip) | resource |
| [aws_instance.application](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/instance) | resource |
| [aws_instance.database](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/instance) | resource |
| [aws_instance.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/instance) | resource |
| [aws_internet_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/key_pair) | resource |
| [aws_lb.loadbalancer](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.http](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/lb_target_group) | resource |
| [aws_route.internet_access](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route) | resource |
| [aws_security_group.application_access](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/security_group) | resource |
| [aws_security_group.database_access](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/security_group) | resource |
| [aws_security_group.jumphost_access](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/security_group) | resource |
| [aws_security_group.loadbalancer_access](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/security_group) | resource |
| [aws_subnet.default_private](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/subnet) | resource |
| [aws_subnet.default_public](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/subnet) | resource |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/vpc) | resource |
| [local_file.host_vars_app](https://registry.terraform.io/providers/hashicorp/local/2.5.1/docs/resources/file) | resource |
| [local_file.host_vars_db](https://registry.terraform.io/providers/hashicorp/local/2.5.1/docs/resources/file) | resource |
| [local_file.host_vars_jumphost](https://registry.terraform.io/providers/hashicorp/local/2.5.1/docs/resources/file) | resource |
| [null_resource.add_servers_to_ansible_hosts_ini](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [null_resource.add_servers_to_ssh_config](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [null_resource.provision_automation_user_on_instances](https://registry.terraform.io/providers/hashicorp/null/3.2.2/docs/resources/resource) | resource |
| [random_shuffle.random_private_subnet](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/shuffle) | resource |
| [random_shuffle.random_public_subnet](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/shuffle) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/availability_zones) | data source |
| [template_file.host_vars_app](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |
| [template_file.host_vars_db](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |
| [template_file.host_vars_jumphost](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accountid"></a> [accountid](#input\_accountid) | Defines the aws account in which to deploy the resources. | `string` | `"743558884073"` | no |
| <a name="input_allowed_ssh_access"></a> [allowed\_ssh\_access](#input\_allowed\_ssh\_access) | IP to allow access over ssh. Defaults to quad zero. | `list(string)` | <pre>[<br>  "45.80.136.238/32"<br>]</pre> | no |
| <a name="input_app_instance_type"></a> [app\_instance\_type](#input\_app\_instance\_type) | Instance type override for app instance, by default free tier. | `string` | `""` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Defines the region where to deploy the resources. | `string` | `"eu-central-1"` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | Main CIDR Blocks for vpc based on stage of the environment. | `object({ dev : string, acc : string, prod : string })` | <pre>{<br>  "acc": "10.1.0.0/16",<br>  "dev": "10.2.0.0/16",<br>  "prod": "10.0.0.0/16"<br>}</pre> | no |
| <a name="input_custom_cidr"></a> [custom\_cidr](#input\_custom\_cidr) | Option to provide custom CIDR range if desired, this overrides the default provided lists based on the environment stage. | `string` | `""` | no |
| <a name="input_custom_subnet_priv_cidrs"></a> [custom\_subnet\_priv\_cidrs](#input\_custom\_subnet\_priv\_cidrs) | Option to override with custom private subnet CIDR. | `list(string)` | `[]` | no |
| <a name="input_custom_subnet_pub_cidrs"></a> [custom\_subnet\_pub\_cidrs](#input\_custom\_subnet\_pub\_cidrs) | Option to override with custom public subnet CIDR. | `list(string)` | `[]` | no |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type) | Instance type override for db instance, by default free tier. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for both app and db servers, by default free tier. | `string` | `"t2.micro"` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to the public key, update this path if your key is located elsewhere. | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage of the environments (dev / acceptance / production). | `string` | `"dev"` | no |
| <a name="input_sub_count"></a> [sub\_count](#input\_sub\_count) | Amount of subnets (Subnet group per availability zone that is used). | `string` | `"2"` | no |
| <a name="input_subnet_priv_cidrs"></a> [subnet\_priv\_cidrs](#input\_subnet\_priv\_cidrs) | Private subnet ranges (requires 3 entries). | `object({ dev : list(string), acc : list(string), prod : list(string) })` | <pre>{<br>  "acc": [<br>    "10.1.4.0/24",<br>    "10.1.5.0/24",<br>    "10.1.6.0/24",<br>    "10.1.10.0/24",<br>    "10.1.11.0/24",<br>    "10.1.12.0/24"<br>  ],<br>  "dev": [<br>    "10.2.4.0/24",<br>    "10.2.5.0/24",<br>    "10.2.6.0/24",<br>    "10.2.10.0/24",<br>    "10.2.11.0/24",<br>    "10.2.12.0/24"<br>  ],<br>  "prod": [<br>    "10.0.4.0/24",<br>    "10.0.5.0/24",<br>    "10.0.6.0/24",<br>    "10.0.10.0/24",<br>    "10.0.11.0/24",<br>    "10.0.12.0/24"<br>  ]<br>}</pre> | no |
| <a name="input_subnet_pub_cidrs"></a> [subnet\_pub\_cidrs](#input\_subnet\_pub\_cidrs) | Public subnet ranges (requires 3 entries). | `object({ dev : list(string), acc : list(string), prod : list(string) })` | <pre>{<br>  "acc": [<br>    "10.1.1.0/24",<br>    "10.1.2.0/24",<br>    "10.1.3.0/24",<br>    "10.1.7.0/24",<br>    "10.1.8.0/24",<br>    "10.1.9.0/24"<br>  ],<br>  "dev": [<br>    "10.2.1.0/24",<br>    "10.2.2.0/24",<br>    "10.2.3.0/24",<br>    "10.2.7.0/24",<br>    "10.2.8.0/24",<br>    "10.2.9.0/24"<br>  ],<br>  "prod": [<br>    "10.0.1.0/24",<br>    "10.0.2.0/24",<br>    "10.0.3.0/24",<br>    "10.0.7.0/24",<br>    "10.0.8.0/24",<br>    "10.0.9.0/24"<br>  ]<br>}</pre> | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the vpc. | `string` | `"vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->