output "kms_key" {
  description = "The kms key generated for the sqs resource"
  value       = "${element(concat(aws_kms_key.sqs_kms_key.*.key_id, list("")), 0)}"
}

output "sqs_id" {
  description = "The SQS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue.*.id, list("")), 0)}"
}

output "sqs_arn" {
  description = "The SQS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue.*.arn, list("")), 0)}"
}

output "sqs_id_kms" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms.*.id, list("")), 0)}"
}

output "sqs_arn_kms" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms.*.arn, list("")), 0)}"
}

output "sqs_id_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_no_policy.*.id, list("")), 0)}"
}

output "sqs_arn_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_no_policy.*.arn, list("")), 0)}"
}

output "sqs_id_redrive" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_redrive.*.id, list("")), 0)}"
}

output "sqs_arn_redrive" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_redrive.*.arn, list("")), 0)}"
}

output "sqs_id_kms_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_no_policy.*.id, list("")), 0)}"
}

output "sqs_arn_kms_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_no_policy.*.arn, list("")), 0)}"
}

output "sqs_id_kms_and_redrive" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_redrive.*.id, list("")), 0)}"
}

output "sqs_arn_kms_and_redrive" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_redrive.*.arn, list("")), 0)}"
}

output "sqs_id_redrive_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_redrive_and_no_policy.*.id, list("")), 0)}"
}

output "sqs_arn_redrive_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_redrive_and_no_policy.*.arn, list("")), 0)}"
}

output "sqs_id_kms_and_redrive_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_redrive_and_no_policy.*.id, list("")), 0)}"
}

output "sqs_arn_kms_and_redrive_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value       = "${element(concat(aws_sqs_queue.queue_with_kms_and_redrive_and_no_policy.*.arn, list("")), 0)}"
}

output "sqs_with_kms_iam_user" {
  description = "The SQS user ARN we just created"
  value       = "${element(concat(aws_sqs_queue.sqs_with_kms_iam_user.*.arn, list("")), 0)}"
}
