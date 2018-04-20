data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_sqs_queue" "queue" {
  name = "${var.name}"

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

resource "aws_iam_user" "sqs_iam_user" {
  count = "${var.number_of_users}"

  name = "${var.sqs_iam_user}${var.number_of_users != 1 ? "-${count.index}" : "" }"
  path = "/"
}

resource "aws_iam_user_policy" "sqs_user_policy" {
  count = "${var.number_of_users}"

  name   = "${var.iam_user_policy_name}SQSPolicy"
  user   = "${element(aws_iam_user.sqs_iam_user.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.sqs_policy_document.json}"
}

data "aws_iam_policy_document" "sqs_policy_document" {
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
