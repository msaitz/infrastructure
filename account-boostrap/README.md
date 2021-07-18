# AWS Account bootstrap

**Warning**: This component uses a local remote state. tfstate files are meant to be checked out in source control.

This component is used for boostrapping AWS accounts in preparation for its use from Terraform.

The initial AWS master account requires to be manually created and this component adds to it a master user with Administrator Access, and an account IAM aliaas.

The master account and the AWS Organization accounts get created the S3 bucket and DynamoDB table required for using Terraform remote states.

## Usage

The initial master AWS Account is created manually and a root user/credentials can then be used to bootstrap the master Account

```bash
export AWS_SECRET_ACCESS_KEY=
export AWS_ACCESS_KEY_ID=
terraform init -backend-config=../environments/msaitz/global/backend.tfvars
terraform plan -out=/tmp/terraform.plan -var-file=../environments/msaitz/global/terraform.tfvars
terraform apply /tmp/terraform.plan
```

After creating the [organization](../organization/README.md) and child accounts:

- Configure `aws-vault` for using the master account with the IAM user `tf-bootstrap` keys and the child accounts. These require assuming the `OrganizationAccountAccessRole` role
- Run the following for master and child accounts:

  ```bash
  terraform init -backend-config=../environments/ENVIRONMENT/global/backend.tfvars
  aws-vault exec ENVIRONMENT -- terraform plan -out=/tmp/terraform.plan -var-file=../environments/ENVIRONMENT/global/terraform.tfvars
  aws-vault exec ENVIRONMENT -- terraform apply /tmp/terraform.plan
  ```
