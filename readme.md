Initial resource setup

AWS IAM
Users;
- AWS Account (root)
- Personal AWS IAM User for the engineer
- Terraform operator AWS IAM user

Groups;
- Operations engineer
- (TF operator ?)

Roles;
- Terraform operator

AWS S3
- S3 bucket to store terraform state remote.

AWS Dynamodb
- Locking mechanism to avoid multiple people working on the same state.

Local device setup;
Requirements;
- tfenv
- git
- IDE
- awscli

Configuration;
- AWS Profile

