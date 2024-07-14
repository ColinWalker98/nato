# Introduction

# Required Tools / Packages on local device

Generate the following keys;
~/.ssh/automation.key (no password as it will be used for automation purposes)
~/.ssh/id_rsa (Used by terraform to deploy the instances and trigger provisioning of the automation user.)

## Requirements:
<table>
  <tr>
    <td><strong>tfenv</strong></td>
    <td>3.0.0</td>
    <td>Allows user to switch between various Terraform versions.</td>
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
.
├── README.md
├── ansible
│   ├── ansible.cfg
│   ├── books
│   └── inventory
├── environments
│   ├── acc
│   └── dev
├── flask_app
│   ├── app
│   ├── config.py
│   ├── requirements.txt
│   └── run.py
└── terraform_modules
    └── environment
```
### ansible
This directory contains all files related to ansible.
- ansible.cfg
- hosts
- inventory
- playbooks

### environments
This is the base directory from where an environment is set up per stage (`dev`, `acc`, `prod`). <br/>
For each desired environment a terraform is created in the respective stage folder. Example: `dev/web.tf`,`acc/web,tf`. <br/><br/>
> Important to note here is that the backends should be configured per environment. Make sure to modify the values as needed. <br/>

### flask_app
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

### terraform_modules

