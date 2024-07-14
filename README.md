# Introduction

## Required Tools / Packages on Local Device

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

#### Users
- AWS Account (root)
- Personal AWS IAM User for the engineer
- Terraform operator AWS IAM Role

#### Groups
- Operations engineer (linked to the engineer)

#### Roles
- Terraform operator

#### Policy
- `AdministratorAccess` policy has been applied to the Terraform operator role. Best practice would be to limit the policy permissions to the necessary resources.

### AWS S3
- Remote Terraform state setup.

### AWS DynamoDB
- Locking mechanism in an AWS DynamoDB table to avoid multiple people working on the same target with conflicting lock/state files.
