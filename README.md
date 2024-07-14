# Introduction

# Required Tools / Packages on local device

Generate the following keys;
~/.ssh/automation.key (no password as it will be used for automation purposes)
~/.ssh/id_rsa (Used by Terraform to deploy the instances and trigger provisioning of the automation user.)

## Requirements:
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
This git repository has various folders. Below you will see the layout of the repository.
For each topic you can find corresponding documentation below.
```
├── README.md
├── ansible
├── environments
├── flask_app
└── terraform_modules
```
### ansible
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

### environments
```
├── acc
│   └── web.tf
└── dev
    └── web.tf
```
This is the base directory from where an environment is set up per stage (`dev`, `acc`, `prod`). <br/>
For each desired environment a Terraform is created in the respective stage folder. Example: `dev/web.tf`,`acc/web,tf`. <br/><br/>
> Important to note here is that the backends should be configured per environment. Make sure to modify the values as needed. <br/>

### flask_app
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

### terraform_modules/environment
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


