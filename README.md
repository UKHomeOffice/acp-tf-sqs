# acp-tf-sqs

Module usage:

    module "sqs" {
      source               = "git::https://github.com/UKHomeOffice/acp-tf-sqs?ref=v0.0.1"
      name                 = "${var.environment}-sqs"
      environment          = "${var.environment}"
      sqs_iam_user         = "${var.environment}-sqs-user"
      iam_user_policy_name = "${var.environment}-sqs-policy"
      policy               = "POLICY"

      tags = {
        TYPE              = "${var.environment}"
        ENVIRONMENT       = "notprod"
        PROJECT-SERVICE   = ""
        PROJECT-PORTFOLIO = ""
        COST-CODE         = ""
      }
    }

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| acl | The access control list assigned to this bucket | `public` | no |
| sqs_iam_user | The name of the iam user assigned to the created sqs queue | - | yes |
| environment | The environment the S3 is running in i.e. dev, prod etc | - | yes |
| iam_user_policy_name | The policy name of attached to the user | - | yes |
| policy | The policy json to attach to the queue | - | yes |
| name | A descriptive name for the S3 instance | - | yes |
| number_of_users | The number of user to generate credentials for | `1` | no |
| tags | A map of tags to add to all resources | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| sqs_id | The SQS queue ID |
| sqs_arn | The SQS queue ARN |
