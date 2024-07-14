# Introduction
This repository serves as a comprehensive guide and toolkit for deploying and managing an infrastructure environment using 
a combination of Terraform, Ansible, and a Flask web application. It includes all necessary scripts, configurations 
and instructions to set up and maintain a robust and scalable environment. <br/><br/>

The repository is organized into several key components:
- Ansible: Used for configuration management and automation of server provisioning. 
- Terraform: Utilized for infrastructure as code, enabling the deployment and management of cloud resources. 
- Flask App: A web application to demonstrate the deployment process and integration with the infrastructure. <br/><br/>

By following the guidelines and utilizing the provided tools and scripts, you will be able to automate the deployment process,
ensure consistent configurations, and manage your infrastructure efficiently. <br/>

The subsequent sections provide detailed instructions on the required tools, packages, and manual provisioning steps necessary to get started.

# Assumptions made during exercise


# Required Tools / Packages on local device
## Requirements
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

## Manually Provisioned Resources
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
└── vars.tf
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
`vars.tf` defines all required variables. <br/>


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
- Create a new bucket. Give it a unique name and select a region. 
- Enable versioning on the bucket for state file history.

## AWS DynamoDB
To set up the Terraform remote state locking, perform the following actions:
- Navigate to the DynamoDB service.
- Create a new table with a primary key named LockID.
- This table will be used to manage state locking and prevent concurrent modifications.

## Tools and Packages
Please install the required tools and packages mentioned earlier in [requirements](Requirements). <br/>
The engineer is expected to have sufficient knowledge on how to install these.