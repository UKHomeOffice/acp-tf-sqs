/*
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
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
  }
  required_version = ">= 1.0"
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  email_tags = { for i, email in var.email_addresses : "email${i}" => email }
}

resource "aws_kms_key" "sqs_kms_key" {
  count = length(var.kms_alias) != 0 && (length(var.policy) == 0 || length(var.redrive_arn) == 0) ? 1 : 0

  deletion_window_in_days = 7
  is_enabled              = "true"
  enable_key_rotation     = "true"
  policy                  = var.kms_key_policy != "" ? var.kms_key_policy : null
}

resource "aws_kms_alias" "sqs_kms_alias" {
  count = length(var.kms_alias) != 0 && (length(var.policy) == 0 || length(var.redrive_arn) == 0) ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.sqs_kms_key[0].key_id
}

resource "aws_sqs_queue" "queue" {
  count = length(var.kms_alias) == 0 && length(var.kms_key) == 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = 300

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_kms" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = aws_kms_key.sqs_kms_key[0].key_id
  kms_data_key_reuse_period_seconds = 300

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_no_policy" {
  count = length(var.kms_alias) == 0 && length(var.kms_key) == 0 && length(var.redrive_arn) == 0 && length(var.policy) == 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue 
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = 300

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_kms_key_and_no_policy" {
  count = length(var.kms_alias) == 0 && length(var.kms_key) != 0 && length(var.policy) == 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_key
  kms_data_key_reuse_period_seconds = 300

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_kms_and_no_policy" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) == 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = aws_kms_key.sqs_kms_key[0].key_id
  kms_data_key_reuse_period_seconds = 300

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_redrive" {
  count = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = 300
  redrive_policy                    = "{\"deadLetterTargetArn\":\"${var.redrive_arn}\",\"maxReceiveCount\":${var.max_receive_count}}"

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_kms_and_redrive" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_key
  kms_data_key_reuse_period_seconds = 300
  redrive_policy                    = "{\"deadLetterTargetArn\":\"${var.redrive_arn}\",\"maxReceiveCount\":${var.max_receive_count}}"

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_redrive_and_no_policy" {
  count = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) == 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_data_key_reuse_period_seconds = 300
  redrive_policy                    = "{\"deadLetterTargetArn\":\"${var.redrive_arn}\",\"maxReceiveCount\":${var.max_receive_count}}"

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_sqs_queue" "queue_with_kms_and_redrive_and_no_policy" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) == 0 ? 1 : 0
  name  = var.name

  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  deduplication_scope               = var.fifo_queue == true ? var.deduplication_scope : null
  fifo_throughput_limit             = var.deduplication_scope != "" && var.fifo_queue == true ? var.fifo_throughput_limit : null
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = aws_kms_key.sqs_kms_key[0].key_id
  kms_data_key_reuse_period_seconds = 300
  redrive_policy                    = "{\"deadLetterTargetArn\":\"${var.redrive_arn}\",\"maxReceiveCount\":${var.max_receive_count}}"

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
    {
      "KubernetesCluster" = var.environment
    },
  )
}

resource "aws_iam_user" "sqs_iam_user" {
  count = length(var.policy) != 0 && length(var.kms_alias) == 0 ? var.number_of_users : 0

  name = "${var.sqs_iam_user}${var.number_of_users != 1 ? "-${count.index}" : ""}"
  path = "/"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )

}

resource "aws_iam_user" "sqs_with_kms_iam_user" {
  count = length(var.policy) != 0 && length(var.kms_alias) != 0 ? var.number_of_users : 0

  name = "${var.sqs_iam_user}${var.number_of_users != 1 ? "-${count.index}" : ""}"
  path = "/"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )

}

resource "aws_iam_user_policy" "sqs_user_policy" {
  count = length(var.kms_alias) == 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? var.number_of_users : 0

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = element(aws_iam_user.sqs_iam_user.*.name, count.index)
  policy = data.aws_iam_policy_document.sqs_policy_document[0].json
}

resource "aws_iam_user_policy" "sqs_with_kms_user_policy" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? var.number_of_users : 0

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = element(aws_iam_user.sqs_with_kms_iam_user.*.name, count.index)
  policy = data.aws_iam_policy_document.sqs_with_kms_policy_document[0].json
}

resource "aws_iam_user_policy" "sqs_with_redrive_user_policy" {
  count = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? var.number_of_users : 0

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = element(aws_iam_user.sqs_iam_user.*.name, count.index)
  policy = data.aws_iam_policy_document.sqs_with_redrive_policy_document[0].json
}

resource "aws_iam_user_policy" "sqs_with_kms_and_redrive_user_policy" {
  count = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? var.number_of_users : 0

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = element(aws_iam_user.sqs_with_kms_iam_user.*.name, count.index)
  policy = data.aws_iam_policy_document.sqs_with_kms_and_redrive_policy_document[0].json
}

data "aws_iam_policy_document" "sqs_policy_document" {
  count     = length(var.kms_alias) == 0 && length(var.kms_key) == 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      aws_sqs_queue.queue[0].arn,
    ]

    actions = concat([
      "sqs:AddPermission",
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:Get*",
      "sqs:List*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:Send*",
    ], var.enable_set_attributes ? ["sqs:SetQueueAttributes"] : [])
  }

  # this is a deny policy so that it overrides the other policies
  dynamic "statement" {
    for_each = length(var.cidr_blocks) != 0 ? [1] : []

    content {
      sid    = "IAMSQSIPRestriction"
      effect = "Deny"

      resources = [
        aws_sqs_queue.queue[0].arn,
      ]

      actions = [
        "SQS:*"
      ]

      condition {
        test     = "NotIpAddress"
        variable = "aws:SourceIp"
        values   = var.cidr_blocks
      }
    }
  }
}

data "aws_iam_policy_document" "sqs_with_kms_policy_document" {
  count     = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      aws_sqs_queue.queue_with_kms[0].arn,
    ]

    actions = concat([
      "sqs:AddPermission",
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:Get*",
      "sqs:List*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:Send*",
    ], var.enable_set_attributes ? ["sqs:SetQueueAttributes"] : [])
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      aws_kms_key.sqs_kms_key[0].arn,
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/${var.kms_alias}",
    ]

    actions = [
      "kms:ReEncrypt",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:GenerateRandom",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt",
    ]
  }

  # this is a deny policy so that it overrides the other policies
  dynamic "statement" {
    for_each = length(var.cidr_blocks) != 0 ? [1] : []

    content {
      sid    = "IAMSQSIPRestriction"
      effect = "Deny"

      resources = [
        aws_sqs_queue.queue_with_kms[0].arn,
      ]

      actions = [
        "SQS:*"
      ]

      condition {
        test     = "NotIpAddress"
        variable = "aws:SourceIp"
        values   = var.cidr_blocks
      }
    }
  }
}

data "aws_iam_policy_document" "sqs_with_redrive_policy_document" {
  count     = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      var.redrive_arn,
      aws_sqs_queue.queue_with_redrive[0].arn,
    ]

    actions = concat([
      "sqs:AddPermission",
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:Get*",
      "sqs:List*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:Send*",
    ], var.enable_set_attributes ? ["sqs:SetQueueAttributes"] : [])
  }

  # this is a deny policy so that it overrides the other policies
  dynamic "statement" {
    for_each = length(var.cidr_blocks) != 0 ? [1] : []

    content {
      sid    = "IAMSQSIPRestriction"
      effect = "Deny"

      resources = [
        aws_sqs_queue.queue_with_redrive[0].arn,
      ]

      actions = [
        "SQS:*"
      ]

      condition {
        test     = "NotIpAddress"
        variable = "aws:SourceIp"
        values   = var.cidr_blocks
      }
    }
  }
}

data "aws_iam_policy_document" "sqs_with_kms_and_redrive_policy_document" {
  count     = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      var.redrive_arn,
      aws_sqs_queue.queue_with_kms_and_redrive[0].arn,
    ]

    actions = concat([
      "sqs:AddPermission",
      "sqs:ChangeMessageVisibility*",
      "sqs:DeleteMessage*",
      "sqs:Get*",
      "sqs:List*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:RemovePermission",
      "sqs:Send*",
    ], var.enable_set_attributes ? ["sqs:SetQueueAttributes"] : [])
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      var.redrive_arn,
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key}",
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/${var.kms_alias}",
    ]

    actions = [
      "kms:ReEncrypt",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:GenerateRandom",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt",
    ]
  }

  # this is a deny policy so that it overrides the other policies
  dynamic "statement" {
    for_each = length(var.cidr_blocks) != 0 ? [1] : []

    content {
      sid    = "IAMSQSIPRestriction"
      effect = "Deny"

      resources = [
        aws_sqs_queue.queue_with_kms_and_redrive[0].arn,
      ]

      actions = [
        "SQS:*"
      ]

      condition {
        test     = "NotIpAddress"
        variable = "aws:SourceIp"
        values   = var.cidr_blocks
      }
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  count     = length(var.kms_alias) == 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  queue_url = aws_sqs_queue.queue[0].id
  policy    = var.policy != "default" ? var.policy : data.aws_iam_policy_document.sqs_default_policy_document[0].json
}

data "aws_iam_policy_document" "sqs_default_policy_document" {
  count   = length(var.kms_alias) == 0 && length(var.kms_key) && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "SQS Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.queue[0].arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.queue[0].arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_with_kms_policy" {
  count     = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  queue_url = aws_sqs_queue.queue_with_kms[0].id
  policy    = var.policy != "default" ? var.policy : data.aws_iam_policy_document.sqs_with_kms_default_policy_document[0].json
}

data "aws_iam_policy_document" "sqs_with_kms_default_policy_document" {
  count   = length(var.kms_alias) != 0 && length(var.redrive_arn) == 0 && length(var.policy) != 0 ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "SQS Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.queue_with_kms[0].arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.queue_with_kms[0].arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_with_redrive_policy" {
  count     = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  queue_url = aws_sqs_queue.queue_with_redrive[0].id
  policy    = var.policy != "default" ? var.policy : data.aws_iam_policy_document.sqs_with_redrive_default_policy_document[0].json
}

data "aws_iam_policy_document" "sqs_with_redrive_default_policy_document" {
  count   = length(var.kms_alias) == 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "SQS Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.queue_with_redrive[0].arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.queue_with_redrive[0].arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_with_kms_and_redrive_policy" {
  count     = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  queue_url = aws_sqs_queue.queue_with_kms_and_redrive[0].id
  policy    = var.policy != "default" ? var.policy : data.aws_iam_policy_document.sqs_with_kms_and_redrive_default_policy_document[0].json
}

data "aws_iam_policy_document" "sqs_with_kms_and_redrive_default_policy_document" {
  count   = length(var.kms_alias) != 0 && length(var.redrive_arn) != 0 && length(var.policy) != 0 ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = "SQS Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SQS:*"
    ]
    resources = [aws_sqs_queue.queue_with_kms_and_redrive[0].arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.queue_with_kms_and_redrive[0].arn]
    }
  }
}

module "self_serve_access_keys" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys?ref=v0.1.0"

  user_names = concat(aws_iam_user.sqs_iam_user.*.name, aws_iam_user.sqs_with_kms_iam_user.*.name)
}

