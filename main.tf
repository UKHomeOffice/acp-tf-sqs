/**
* Module usage:
*
*    module "sqs" {
*      source               = "git::https://github.com/UKHomeOffice/acp-tf-sqs?ref=master"
*      name                 = "new-sqs"
*      environment          = "env"
*      sqs_iam_user         = "new-sqs-user"
*      iam_user_policy_name = "new-sqs-policy"
*
*      policy = <<POLICY
*    {
*      "Version": "2012-10-17",
*      "Id": "sqspolicy",
*      "Statement": [
*        {
*          "Sid": "First",
*          "Effect": "Allow",
*          "Principal": "*",
*          "Action": "sqs:SendMessage",
*          "Resource": "arn:aws:sqs:*:*:new-sqs",
*          "Condition": {
*            "ArnEquals": {
*              "aws:SourceArn": "arn:aws:sqs:*:*:new-sqs"
*            }
*          }
*        }
*      ]
*    }
*    POLICY
*    }
*/

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "sqs_kms_key" {
  count = "${length(var.kms_alias) == 0 ? 0 : 1}"

  deletion_window_in_days = 7
  is_enabled              = "true"
  enable_key_rotation     = "true"
}

resource "aws_kms_alias" "s3_bucket_kms_alias" {
  count = "${length(var.kms_alias) == 0 ? 0 : 1}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.sqs_kms_key.key_id}"
}

resource "aws_sqs_queue" "queue" {
  count = "${length(var.kms_alias) == 0 ? 1 : 0}"
  name  = "${var.name}"

  visibility_timeout_seconds  = "${var.visibility_timeout_seconds}"
  message_retention_seconds   = "${var.message_retention_seconds}"
  max_message_size            = "${var.max_message_size}"
  policy                      = "${var.policy}"
  delay_seconds               = "${var.delay_seconds}"
  receive_wait_time_seconds   = "${var.receive_wait_time_seconds}"
  fifo_queue                  = "${var.fifo_queue}"
  content_based_deduplication = "${var.content_based_deduplication}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

resource "aws_sqs_queue" "queue_with_kms" {
  count = "${length(var.kms_alias) == 0 ? 0 : 1}"
  name  = "${var.name}"

  visibility_timeout_seconds        = "${var.visibility_timeout_seconds}"
  message_retention_seconds         = "${var.message_retention_seconds}"
  max_message_size                  = "${var.max_message_size}"
  policy                            = "${var.policy}"
  delay_seconds                     = "${var.delay_seconds}"
  receive_wait_time_seconds         = "${var.receive_wait_time_seconds}"
  fifo_queue                        = "${var.fifo_queue}"
  content_based_deduplication       = "${var.content_based_deduplication}"
  kms_master_key_id                 = "${aws_kms_key.sqs_kms_key.key_id}"
  kms_data_key_reuse_period_seconds = 300

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

resource "aws_iam_user" "sqs_iam_user" {
  count = "${length(var.kms_alias) == 0 ? var.number_of_users : 0}"

  name = "${var.sqs_iam_user}${var.number_of_users != 1 ? "-${count.index}" : "" }"
  path = "/"
}

resource "aws_iam_user_policy" "sqs_user_policy" {
  count = "${length(var.kms_alias) == 0 ? var.number_of_users : 0}"

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = "${element(aws_iam_user.sqs_iam_user.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.sqs_policy_document.json}"
}

resource "aws_iam_user" "sqs_with_kms_iam_user" {
  count = "${length(var.kms_alias) == 0 ? 0 : var.number_of_users }"

  name = "${var.sqs_iam_user}${var.number_of_users != 1 ? "-${count.index}" : "" }"
  path = "/"
}

resource "aws_iam_user_policy" "sqs_with_kms_user_policy" {
  count = "${length(var.kms_alias) == 0 ? 0 : var.number_of_users }"

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = "${element(aws_iam_user.sqs_with_kms_iam_user.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.sqs_with_kms_policy_document.json}"
}

data "aws_iam_policy_document" "sqs_policy_document" {
  count     = "${length(var.kms_alias) == 0 ? 1 : 0}"
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      "${aws_sqs_queue.queue.arn}",
    ]

    actions = [
      "sqs:*",
    ]
  }
}

data "aws_iam_policy_document" "sqs_with_kms_policy_document" {
  count     = "${length(var.kms_alias) == 0 ? 0 : 1 }"
  policy_id = "${var.sqs_iam_user}SQSPolicy"

  statement {
    sid    = "IAMSQSPermissions"
    effect = "Allow"

    resources = [
      "${aws_sqs_queue.queue_with_kms.arn}",
    ]

    actions = [
      "sqs:*",
    ]
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      "${aws_kms_key.sqs_kms_key.arn}",
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
}
