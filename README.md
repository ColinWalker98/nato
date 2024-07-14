# Introduction

## Required Tools / Packages on local device
### Requirements:
<table>
  <tr>
    <td><strong>tfenv</strong></td>
    <td>Allows user to switch between various Terraform versions.</td>
  </tr>
  <tr>
    <td><strong>tflint</strong></td>
    <td>Ensures proper conventions are used and identifies any deprecated usage of the HCL.</td>
  </tr>
  <tr>
    <td><strong>terraform-docs</strong></td>
    <td>Generates documentation for hcl code on demand.</td>
  </tr>
  <tr>
    <td><strong>git</strong></td>
    <td>Versioning tool.</td>
  </tr>
  <tr>
    <td><strong>IDE</strong></td>
    <td>Code editor.</td>
  </tr>
  <tr>
    <td><strong>awscli</strong></td>
    <td>Setup your AWS profile.</td>
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