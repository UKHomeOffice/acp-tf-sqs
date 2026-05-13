Module usage:

```
     module "sqs" {
       source               = "git::https://github.com/UKHomeOffice/acp-tf-sqs?ref=master"
       name                 = "new-sqs"
       environment          = "env"
       sqs_iam_user         = "new-sqs-user"
       iam_user_policy_name = "new-sqs-policy"

       policy = <<POLICY
     {
       "Version": "2012-10-17",
       "Id": "sqspolicy",
       "Statement": [
         {
           "Sid": "First",
           "Effect": "Allow",
           "Principal": "*",
           "Action": "sqs:SendMessage",
           "Resource": "arn:aws:sqs:*:*:new-sqs",
           "Condition": {
             "ArnEquals": {
               "aws:SourceArn": "arn:aws:sqs:*:*:new-sqs"
             }
           }
         }
       ]
     }
     POLICY
     }

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.70 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_self_serve_access_keys"></a> [self\_serve\_access\_keys](#module\_self\_serve\_access\_keys) | git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys | v0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_user.sqs_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.sqs_with_kms_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.sqs_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.sqs_with_kms_and_redrive_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.sqs_with_kms_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.sqs_with_redrive_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_kms_alias.sqs_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.sqs_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_kms_and_no_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_kms_and_redrive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_kms_and_redrive_and_no_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_kms_key_and_no_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_no_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_redrive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue_with_redrive_and_no_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.sqs_with_kms_and_redrive_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.sqs_with_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.sqs_with_redrive_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sqs_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_existing_kms_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_kms_and_redrive_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_kms_and_redrive_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_kms_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_kms_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_redrive_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_with_redrive_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | A list of network cidr blocks which are permitted access | `list` | `[]` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level | `string` | `"queue"` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes) | `number` | `0` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| <a name="input_enable_set_attributes"></a> [enable\_set\_attributes](#input\_enable\_set\_attributes) | Should the created iam user be permitted to set queue attributes | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the SQS is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Boolean designating a FIFO queue | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group | `string` | `"perQueue"` | no |
| <a name="input_iam_user_policy_name"></a> [iam\_user\_policy\_name](#input\_iam\_user\_policy\_name) | The policy name of attached to the user | `any` | n/a | yes |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | KMS key alias name for SQS | `string` | `""` | no |
| <a name="input_kms_existing_key"></a> [kms\_existing\_key](#input\_kms\_existing\_key) | KMS key ID name for SQS when using an existing KMS key | `string` | `""` | no |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | KMS key id name for SQS | `string` | `""` | no |
| <a name="input_kms_key_policy"></a> [kms\_key\_policy](#input\_kms\_key\_policy) | KMS key policy (uses a default policy if omitted) | `string` | `""` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | The max receive count for a queue before Amazon SQS moves the message to a dead-letter queue | `string` | `"10"` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days) | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | A descriptive name for the SQS instance | `any` | n/a | yes |
| <a name="input_number_of_users"></a> [number\_of\_users](#input\_number\_of\_users) | The number of user to generate credentials for | `number` | `1` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The JSON policy for the SQS queue (uses a default when stated) | `string` | `""` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds) | `number` | `0` | no |
| <a name="input_redrive_arn"></a> [redrive\_arn](#input\_redrive\_arn) | AWS ARN for the SQS redirect queue | `string` | `""` | no |
| <a name="input_sqs_iam_user"></a> [sqs\_iam\_user](#input\_sqs\_iam\_user) | The name of the iam user assigned to the created sqs bucket | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | The kms key generated for the sqs resource |
| <a name="output_sqs_arn"></a> [sqs\_arn](#output\_sqs\_arn) | The SQS Queue ARN we just created |
| <a name="output_sqs_arn_kms"></a> [sqs\_arn\_kms](#output\_sqs\_arn\_kms) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_kms_and_no_policy"></a> [sqs\_arn\_kms\_and\_no\_policy](#output\_sqs\_arn\_kms\_and\_no\_policy) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_kms_and_redrive"></a> [sqs\_arn\_kms\_and\_redrive](#output\_sqs\_arn\_kms\_and\_redrive) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_kms_and_redrive_and_no_policy"></a> [sqs\_arn\_kms\_and\_redrive\_and\_no\_policy](#output\_sqs\_arn\_kms\_and\_redrive\_and\_no\_policy) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_no_policy"></a> [sqs\_arn\_no\_policy](#output\_sqs\_arn\_no\_policy) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_redrive"></a> [sqs\_arn\_redrive](#output\_sqs\_arn\_redrive) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_arn_redrive_and_no_policy"></a> [sqs\_arn\_redrive\_and\_no\_policy](#output\_sqs\_arn\_redrive\_and\_no\_policy) | The SQS KMS Queue ARN we just created |
| <a name="output_sqs_id"></a> [sqs\_id](#output\_sqs\_id) | The SQS Queue ID we just created |
| <a name="output_sqs_id_kms"></a> [sqs\_id\_kms](#output\_sqs\_id\_kms) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_kms_and_no_policy"></a> [sqs\_id\_kms\_and\_no\_policy](#output\_sqs\_id\_kms\_and\_no\_policy) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_kms_and_redrive"></a> [sqs\_id\_kms\_and\_redrive](#output\_sqs\_id\_kms\_and\_redrive) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_kms_and_redrive_and_no_policy"></a> [sqs\_id\_kms\_and\_redrive\_and\_no\_policy](#output\_sqs\_id\_kms\_and\_redrive\_and\_no\_policy) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_no_policy"></a> [sqs\_id\_no\_policy](#output\_sqs\_id\_no\_policy) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_redrive"></a> [sqs\_id\_redrive](#output\_sqs\_id\_redrive) | The SQS KMS Queue ID we just created |
| <a name="output_sqs_id_redrive_and_no_policy"></a> [sqs\_id\_redrive\_and\_no\_policy](#output\_sqs\_id\_redrive\_and\_no\_policy) | The SQS KMS Queue ID we just created |
<!-- END_TF_DOCS -->
