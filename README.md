# cool-master-wiz #

[![GitHub Build Status](https://github.com/cisagov/cool-master-wiz/workflows/build/badge.svg)](https://github.com/cisagov/cool-master-wiz/actions)

This is a Terraform module for creating a role and policies in the COOL Master
account to be used with a [Wiz](https://www.wiz.io/) AWS connector.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Usage ##

For the purposes of these instructions, assume the environment is named "dev";
replace "dev" in the instructions below with your environment name if needed.

1. Create a backend configuration file named `dev.tfconfig` containing the name
   of the bucket where Terraform state is stored for that environment.

    ```hcl
    bucket = "my-dev-terraform-state-bucket"
    ```

1. Initialize the Terraform backend for the "dev" environment using your backend
   configuration file:

    ```console
    terraform init -upgrade -backend-config=dev.tfconfig
    ```

    > [!NOTE] When performing this step for additional environments (i.e. not
    > your first environment), use the `-reconfigure` flag:
    >
    > ```console
    > terraform init -upgrade -backend-config=other-env.tfconfig -reconfigure
    > ```

1. Create a Terraform workspace (if you haven't already done so) by running
   `terraform workspace new dev`
1. Create a `dev.tfvars` file with all required variables and any optional
   variables that you wish to override (see [Inputs](#inputs) below for
   details):

   ```console
   external_id            = "your-external-aws-wiz-connector-id"
   remote_arn             = "arn:aws:iam::123456789012:role/your-remote-role"
   terraform_state_bucket = "my-dev-terraform-state-bucket"

   tags = {
     Team        = "Your Team Name"
     Application = "COOL - Wiz"
     Workspace   = "dev"
   }
   ```

1. Run the command `terraform apply -var-file=dev.tfvars`.

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
|------|---------|
| terraform | >= 1.1 |
| aws | >= 4.9 |

## Providers ##

| Name | Version |
|------|---------|
| aws | >= 4.9 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| wiz | `https://wizio-public-fedramp.s3-us-gov-west-1.amazonaws.com/deployment-v3/aws/terraform/2209/wiz-aws-native-terraform-terraform-module.zip` | n/a |

## Resources ##

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region to deploy into (e.g. us-east-1). | `string` | `"us-east-1"` | no |
| external\_id | The external ID of the Wiz AWS Connector.  This value must be retrieved from the Wiz portal when creating the AWS Connector. | `string` | n/a | yes |
| remote\_arn | The AWS Trust Policy Role ARN for your Wiz data center.  It can be retrieved from the Wiz portal (User Settings, Tenant). | `string` | n/a | yes |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| terraform\_state\_bucket | The name of the S3 bucket where Terraform state is stored. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| wiz\_connector\_arn | n/a |
<!-- END_TF_DOCS -->

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is only  the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
