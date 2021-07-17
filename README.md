# Infrastructure

This repository contains the terraform code for provisioning AWS cloud infrastructure and related resorces. Each component defined has its own independent state and the same folder structure for allowing multiple environments and ease its automation from CI/CD pipelines.

## Repo structure
```bash
├── .github
│   ├── actions                          # Reusable job definitions
│   │   ├── ACTION
│   │       ├── action.yaml
│   ├── workflows                        # Per-component CI scripts
│   │   ├── *.yaml
├── COMPONENT                            # Independent infrastructure entity
│   ├── environments                     # Environment configs
│   │   ├── ENV                          # Eg: dev/prod
|   |       ├── REGION                   # Eg: eu-west-1/global
|   |           ├── backend.tfvars       # Terraform backend config
|   |           ├── terraform.tfvars     # Terraform vars-file
│   ├── terraform                        # Terraform source code for the component
│   │   ├── *.tf
│   ├── README.md                        # Component-level README
├── README.md                            # Root level README
└── .gitignore
```

## Usage
This project is intended to be used from CI pipelines. There may be cases in which manual operations are required (as the `account-bootstrap` component). In this cases, the following steps can be performed:

```bash
cd COMPONENT/terraform
aws-vault exec <PROFILE> -- terraform init -reconfigure -backend-config=../environments/ENVIRONMENT/REGION/backend.tfvars
aws-vault exec <PROFILE> -- terraform plan -var-file=../environments/ENVIRONMENT/REGION/terraform.tfvars -out plan.out
aws-vault exec <PROFILE> -- terraform apply plan.out
```
