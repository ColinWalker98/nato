# Table of Contents
1. [Introduction](#introduction)
2. [Assignment](#assignment)
3. [Assumptions made during exercise](#assumptions-made-during-exercise)
   - [Repository](#repository)
   - [Infrastructure](#infrastructure)
   - [Automation](#automation)
   - [Application](#application)
   - [Database](#database)
4. [Requirements](#requirements)
  - [Tools and Packages](#tools-and-packages) 
  - [Manually Provisioned AWS Resources](#manually-provisioned-AWS-resources)
    - [AWS IAM](#aws-iam)
    - [AWS S3](#aws-s3)
    - [AWS DynamoDB](#aws-dynamodb)
4. [Project structure](#project-structure)
  - [ansible](#ansible)
  - [environments](#environments)
  - [flask_app](#flask_app)
  - [terraform_modules](#terraform_modules)
5. [Setup instructions](#setup-instructions)
  - [SSH keypairs](#ssh-keypairs)
  - [AWS IAM](#aws-iam-1)
  - [AWS S3](#aws-s3-1)
  - [AWS DynamoDB](#aws-dynamodb-1)
  - [Tools and Packages](#tools-and-packages)
6. [Execution instructions](#execution-instructions)
  - [Automated deployment](#automated-deployment)
  - [Manual deployment](#manual-deployment)
  - [Validation](#validation)
  
# Introduction
This repository serves as a comprehensive guide and toolkit for deploying and managing an infrastructure environment using 
a combination of Terraform, Ansible, and a Flask web application. It includes all necessary scripts, configurations 
and instructions to set up and maintain a robust and scalable environment. <br/>

The repository is organized into several key components:
- Ansible: Used for configuration management and automation of server provisioning. 
- Terraform: Utilized for infrastructure as code, enabling the deployment and management of cloud resources. 
- Flask App: A web application to demonstrate the deployment process and integration with the infrastructure. <br/>

By following the guidelines and utilizing the provided tools and scripts, you will be able to automate the deployment process,
ensure consistent configurations, and manage your infrastructure efficiently. <br/>

The subsequent sections provide detailed instructions on the required tools, packages, and manual provisioning steps necessary to get started.

# Assignment
You are the engineer tasked to deploy and configure a system composed of two VMs, a webserver and a database. <br/>
The activity will target two environments at the same time.

Requirements:
- Deployment of the two VMs will be automated using Terraform
- Configuration of the two VMs will be automated using Ansible
- Write a simple REST call to read any data of the database

Output: A GitHub project containing the code and a README file. You are free to make assumptions related to the environments, webserver, database and any other missing information regarding this task.
The assumptions shall be properly stated within the README file.

Provide your work as a GitHub link towards a public project and as a .zip package, that contains all your GitHub project files. <br/>
The assignment version assessed will be the one received in the .zip package and it should be provided no later than 24 hours before the interview appointment. <br/>
Prepare to present it during the next phase interview. The interview panel might ask questions related to the assignment output.

# Assumptions made during exercise
Throughout the readme, the complete solution of the application, database, webservice and other components requested in the assignment, will be referred to as `environment`.

In context of the assignment, the engineer has intermediate to advanced knowledge of:
- AWS
- Terraform
- Ansible
- UNIX operating systems
- Bash
- Python
- Web application development
- Networking

Therefore, the engineer is able to set up the required tools and packages on their local device in order to execute the setup of the assignment based on the readme.

In order to deploy the environment, the following decisions have been made.
## Repository
- Ideally I would create a separate git repository to store terraform modules as it would allow us to version them. However, for the sake of usability in this assignment, a single repository is created to collect all required files to set up the environment.

### Infrastructure
- Infrastructure will be deployed on the AWS Cloud provider.
- Infrastructure resides in a public subnet. At first, the desire was to place the application and database instance in a private subnet. However, this would require a NAT gateway to allow internet access from these instances. Therefore, in order to reduce personal costs, I have placed the instances in a public subnet.
- Besides the application and database instance, I have provisioned a jumphost instance which is used to provide SSH port 22 access to the application and database servers. By doing this we refuse any direct access to the application and database instances.
- Additionally, A loadbalancer is deployed to serve as entrypoint to the application for HTTP 80 traffic.
- Access to the instances has been restricted by utilising AWS Security Groups as follows;
  - Loadbalancer is accessible 
    - from the internet on HTTP port 80 (HTTPS 443 was not used as I did not provision the required certificate for tls validation).
  - Jumphost instance is accessible 
    - from the provided CIDR on SSH port 22 (the desired CIDR is passed as a Terraform variable).
  - Application instance is accessible 
    - from the jumphost  on SSH port 22.
    - from the load balancer on HTTP port 80
  - Database instance is accessible 
    - from the jumphost on SSH port 22.
    - from the application instance on TCP port 27017.
- No additional DNS name has been created. To access the application, refer to the ansible playbook output or fetch the DNS from the Ansible host variables.

### Automation
- Ansible hosts and host variables will be provisioned by Terraform through a template to reduce manual tasks and limit human errors.
- SSH Configuration on the local device will be provisioned by Terraform to reduce manual tasks and limit human errors.
- Ansible will use the ami defined user to initially set up an automation user. We should not use personal users for automation purposes. All subsequent playbooks will use the automation user.
- Ansible playbooks can be run manually or automated by Terraform based on `fully_automated_deployment = true | false` variable.
- Playbookas are made idempotent, therefore, no matter how many times a playbook is ran on the host, it will not fail or cause issues.

### Application
- Python Flask framework is used to act as webservice.
- The website content itself is quite basic as I believed the main focus of the exercise to be infrastructure. However, I have created the website in a best practice way, regardless of the content.
- I have kept in mind the dockerisation of the application and this is possible with few minor changes but, I have not dockerised it. As of now it is run as a systemd service on the instance.
- Provisioning of the application instance is done by the playbook `provision_app_server.yaml`. This installs packages, creates directory structure and the systemd service. 
> Deployment of the application is done by the playbook `deploy_application.yaml`. This copies the `flask_app` folder to the instance, installs necessary packages and restarts the service. Important to note here is that the playbook will build the dotenv file from a template. The flask application uses the dotenv file to load the environment variables.

### Database
- MongoDB is used to act as database server.
- Provisioning of the database instance is done by the playbook `provision_db_server.yaml` it ensures the correct mongodb version and dependencies are installed and creates the `database` and `collection` that will be used by the application.
- Populating the database with mock data done by the playbook `populate_mongodb.yaml` it copies a python script to the application server and runs it. In turn, this inserts some basic mock data into mongodb.


# Requirements
## Tools and Packages
<table>
  <tr>
    <td><strong>tfenv</strong></td>
    <td>3.0.0</td>
    <td>Allows user to switch between various Terraform versions.</td>
  </tr>
  <tr>
    <td><strong>terraform</strong></td>
    <td>1.9.2</td>
    <td>Terraform (installed using tfenv install 1.9.2).</td>
  </tr>
  <tr>
    <td><strong>tflint</strong></td>
    <td>0.52.0</td>
    <td>Ensures proper conventions are used and identifies any deprecated usage of the HCL.</td>
  </tr>
  <tr>
    <td><strong>terraform-docs</strong></td>
    <td>v0.18.0</td>
    <td>Generates documentation for hcl code on demand.</td>
  </tr>
  <tr>
    <td><strong>git</strong></td>
    <td>2.35.1</td>
    <td>Versioning tool.</td>
  </tr>  
  <tr>
    <td><strong>awscli</strong></td>
    <td>2.17.11</td>
    <td>Setup your AWS profile.</td>
  </tr>
  <tr>
    <td><strong>python3</strong></td>
    <td>3.12.4</td>
    <td>Python3 interpreter.</td>
  </tr>
  <tr>
    <td><strong>ansible</strong></td>
    <td>core 2.17.1</td>
    <td>Ansible.</td>
  </tr>
  <tr>
    <td><strong>IDE</strong></td>
    <td>Any version / editor.</td>
    <td>Code editor.</td>
  </tr>
</table>

## Manually Provisioned AWS Resources
### AWS IAM
<table>
  <tr>
    <td><strong>Resource</strong></td>
    <td>Description</td>
    <td>Example</td>
  </tr>
  <tr>
    <td><strong>Users</strong></td>
    <td>AWS Root Account, Engineer user</td>
    <td>colin.walker.dev</td>
  </tr>
  <tr>
    <td><strong>Groups</strong></td>
    <td>Group to assign permissions to, bound to an IAM User</td>
    <td>operations_engineer</td>
  </tr>
  <tr>
    <td><strong>Roles</strong></td>
    <td>Entity that has policies assign to provide permissions. Short lived credentials. Roles can be assumed by trusted entities.</td>
    <td>terraform-operator</td>
  </tr>
  <tr>
    <td><strong>Policy</strong></td>
    <td>A JSON Document that defines access and permissions. Policies can be attached to Groups / Roles.</td>
    <td>terraform-operator</td>
  </tr>
</table>

### AWS S3
<table>
  <tr>
    <td><strong>Resource</strong></td>
    <td>Description</td>
    <td>Example</td>
  </tr>
  <tr>
    <td><strong>AWS S3</strong></td>
    <td>Storage bucket where the Terraform state file is stored.</td>
    <td>terraform-remote-state-nato</td>
  </tr>
</table>

### AWS DynamoDB
<table>
  <tr>
    <td><strong>Resource</strong></td>
    <td>Description</td>
    <td>Example</td>
  </tr>
  <tr>
    <td><strong>AWS Dynamodb</strong></td>
    <td>Table in AWS to handle the Terraform locking mechanism.</td>
    <td>terraform-remote-state-lock-nato</td>
  </tr>
</table>

# Project structure
This git repository has various folders. Below you will see the layout of the repository. <br/>
For each topic you can find corresponding documentation below. <br/>
```
├── README.md
├── ansible
├── environments
├── flask_app
└── terraform_modules
```
## ansible
This directory contains all files related to Ansible.
```
├── ansible.cfg
├── books
│ ├── deploy_application.yaml
│ ├── populate_mongodb.yaml
│ ├── provision_app_server.yaml
│ ├── provision_automation_user.yaml
│ ├── provision_db_server.yaml
│ └── templates
└── inventory
├── acc
├── dev
└── prod
```

## environments
```
├── acc
│   └── web.tf
└── dev
    └── web.tf
```
This is the base directory from where an environment is set up per stage (`dev`, `acc`, `prod`). <br/>
For each desired environment a Terraform is created in the respective stage folder. Example: `dev/web.tf`,`acc/web,tf`. <br/><br/>
> Important to note here is that the backends should be configured per environment. Make sure to modify the values as needed. <br/>

## flask_app
```
├── app
│   ├── __init__.py
│   ├── routes.py
│   ├── static
│   │   └── css
│   └── templates
│       ├── base.html
│       ├── data.html
│       └── index.html
├── config.py
├── requirements.txt
└── run.py
```
This directory contains all files related to the web application. I followed the traditional flask folder layout. <br/>
In the root of the directory, we can find `run.py`, `config.py`, `requirements.txt` . <br/>

`run.py` is used to launch the application. <br/>
`config.py`  creates a class called config to read environment variables and pass them to python. <br/>
`requirements.txt` contains a list of python packages that are required by the application.  <br/>
  This list is used in the deployment process to ensure automatic installation of these packages. <br/>

In the `app` folder, we will find two sub folders `static/css` and `templates`. <br/> 
`static/css` contains the style configuration of the web pages. <br/>
`templates`contains the html pages used to render the website. <br/>

Alongside the `app` folder, we have the `__init__.py` as well as the `routes.py` file. <br/>
`__init__.py` creates the application and configures the mongodb connection with the variables provided by the config class.
`routes.py` can be regarded as the API of the application. <br/>
Here we create all of our request paths and query the necessary data from the database to return it to the rendered html web page. <br/>

## terraform_modules/environment
Contains two folders `scripts` and `templates` alongside many Terraform files. <br/>
`scripts` contains two bash scripts that are called from a Terraform local exec to update your local ssh config as well as update the Ansible hosts.ini file.  <br/>
This minimises the manual actions required by the user. <br/>

For more information about the module please visit [README](terraform_modules/environment/README.md).

```
├── README.md
├── alb.tf
├── ansible.tf
├── application.tf
├── common.tf
├── database.tf
├── jumphost.tf
├── network.tf
├── providers.tf
├── scripts
│   ├── update_ansible_hosts.sh
│   └── update_ssh_config.sh
├── templates
│   └── ansible_hostvar.tpl
└── variables.tf
```

`templates` contains a .tpl file which is called and filled by Terraform to provision the Ansible host variables for each server that is set up. <br/>
`alb.tf` resources relevant to the application. load balancer. <br/>
`ansible.tf` prepares the server configuration in the Ansible directory and potentially fully automates the deployment depending on the users' choice of variables. <br/>
`application.tf` application instance relevant resources (ec2, eip, sg). <br/>
`database.tf` database instance relevant resources (ec2, eip, sg). <br/>
`jumphost.tf` jumphost instance relevant resources (ec2, eip, dg). <br/>
`common.tf` common resources (ami, selection of subnet, key pair). <br/>
`network.tf` network resources (vpc, subnets, routes, gateway). <br/>
`providers.tf` defines all required providers and their respective versions and configuration. <br/>
`variables.tf` defines all required variables. <br/>


# Setup instructions
## SSH keypairs
When setting up the infrastructure with Terraform and Ansible, certain SSH key pairs must be present on the local device. <br/>

Terraform uses ~/.ssh/id_rsa to set up the instances, enabling SSH access to these servers (user: ubuntu). <br/>

Ansible will then use the ubuntu user and the ~/.ssh/id_rsa key pair to provision an automation user on all instances. <br/>
The automation user will have its own dedicated key, ~/.ssh/automation.key, which needs to be present on the local machine before deployment. <br/>
Therefore, please generate the following keys before executing Terraform or Ansible: <br/>
- `~/.ssh/automation.key` (no password, used for automation purposes)
- `~/.ssh/id_rsa` (used by Terraform to deploy the instances and trigger provisioning of the automation user)

## AWS IAM
To set up the required permissions and roles, follow these steps:
#### Create an IAM User:
  - An IAM user must be created for the engineer.
  - The engineer must activate security credentials in the form of an access_key and secret_key.
  - These keys are used to configure the AWS profile on the local device.
  - Once the key pair is generated, run aws configure to start the configuration process.
  
#### Create an IAM Role (terraform-operator):
  - Create an IAM role named terraform-operator. This role will be used by Terraform to provision all resources.
  - Assign a policy to this role. For this example, the Administrator Access policy is used as it is a development/test scenario. In a production environment, define and apply appropriate permissions and access scopes.

#### Allow IAM User to Assume the IAM Role:
  - Configure the IAM role to allow the IAM user to assume it.
  - This is granted by the trusted entities of the role. Below is an example policy that allows the IAM user to assume the terraform-operator role:
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::{{account_id}}:user/colin.walker.dev"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

## AWS S3
To set up Terraform remote state management using an S3 bucket, perform the following actions:
- Log in to your AWS Management Console. 
- Navigate to the S3 service. 
- Create a new bucket.
  - name: `terraform-remote-state-nato`
  - region: `eu-central-1`
- Enable versioning on the bucket for state file history.

## AWS DynamoDB
To set up the Terraform remote state locking, perform the following actions:
- Navigate to the DynamoDB service.
- Create a new table
  - name: `terraform-remote-state-lock-nato`
  - primary_key: `LockID`
- This table will be used to manage state locking and prevent concurrent modifications.

## Tools and Packages
Please install the required tools and packages mentioned earlier in [Tools and Packages](#tools-and-packages) . <br/>
The engineer is expected to have sufficient knowledge on how to install these.

# Execution instructions
Once the setup instructions have been completed. We can proceed to provision the environment.
In this scenario we will be using `dev/web.tf` as an example. This example environment is included in the repository.

In order to deploy the `dev-web` environment, we have to make 1 change to the file.
Here is the content of the file located at `$REPO_PATH/environments/dev/web.tf`.

The change we must make is to modify the `accountid` to your corresponding aws account id.
`accountid                  = "743558884073"`

```
terraform {
  backend "s3" {
    key            = "dev/web/terraform.tfstate"
    bucket         = "terraform-remote-state-nato"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock-nato"
  }
}

module "dev_web_env" {
  source                     = "../../terraform_modules/environment"
  aws_region                 = "eu-central-1"
  instance_type              = "t2.micro"
  stage                      = "dev"
  env_name                   = "web"
  accountid                  = "743558884073"
  fully_automated_deployment = true
}
```

### Automated deployment

Please note, that in the example, `fully_automated_deployment = true` is enabled and therefore, chain the Ansible playbooks from Terraform.

Once everything has been prepared as desired, execute the following.
```
cd {{path_where_repository_is_cloned}}/environments/dev
terraform init
terraform plan
terraform apply
```


### Manual deployment
For a separate deployment of Terraform and Ansible, set `fully_automated_deployment = false`.
This will ensure Terraform only provisions the infrastructure and not the configuration of the application and database.

Therefore, we must perform some additional tasks in the order as follows;
```
cd {{path_where_repository_is_cloned}}/environments/dev
terraform init
terraform plan
terraform apply

cd {{path_where_repository_is_cloned}}/ansible
ansible-playbook books/provision_db_server.yaml -e 'target_servers=dev-web-db'
ansible-playbook books/provision_app_server.yaml -e 'target_servers=dev-web-app'
ansible-playbook books/deploy_application.yaml -e 'target_servers=dev-web-app'
ansible-playbook books/populate_mongodb.yaml -e 'target_servers=dev-web-app'
```

## Validation
In order to validate if the environment is working as expected, navigate to the public DNS of the loadbalancer.
`http://{{loadbalancer_dns}}/`


The application should respond with the index page.
`http://{{loadbalancer_dns}}/data`

To retrieve raw information in a json format, navigate to the data page in the navigation bar.
Additionally, this can be done by navigating to the following endpoint manually;
`http://{{loadbalancer_dns}}/customer_data`

Or by issuing the following curl command from your local machine;
`curl http://{{loadbalancer_dns}}/customer_data`
