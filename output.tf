output "kms_key" {
  description = "The kms key generated for the sqs resource"
  value       = element(concat(aws_kms_key.sqs_kms_key.*.key_id, [""]), 0)
}

output "sqs_id" {
  description = "The SQS Queue ID we just created"
  value       = element(concat(aws_sqs_queue.queue.*.id, [""]), 0)
}

output "sqs_arn" {
  description = "The SQS Queue ARN we just created"
  value       = element(concat(aws_sqs_queue.queue.*.arn, [""]), 0)
}

output "sqs_id_kms" {
  description = "The SQS KMS Queue ID we just created"
  value       = element(concat(aws_sqs_queue.queue_with_kms.*.id, [""]), 0)
}

output "sqs_arn_kms" {
  description = "The SQS KMS Queue ARN we just created"
  value       = element(concat(aws_sqs_queue.queue_with_kms.*.arn, [""]), 0)
}

output "sqs_id_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value       = element(concat(aws_sqs_queue.queue_with_no_policy.*.id, [""]), 0)
}

output "sqs_arn_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value       = element(concat(aws_sqs_queue.queue_with_no_policy.*.arn, [""]), 0)
}

output "sqs_id_redrive" {
  description = "The SQS KMS Queue ID we just created"
  value       = element(concat(aws_sqs_queue.queue_with_redrive.*.id, [""]), 0)
}

output "sqs_arn_redrive" {
  description = "The SQS KMS Queue ARN we just created"
  value       = element(concat(aws_sqs_queue.queue_with_redrive.*.arn, [""]), 0)
}

output "sqs_id_kms_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_kms_and_no_policy.*.id, [""]),
    0,
  )
}

output "sqs_arn_kms_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_kms_and_no_policy.*.arn, [""]),
    0,
  )
}

output "sqs_id_kms_and_redrive" {
  description = "The SQS KMS Queue ID we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_kms_and_redrive.*.id, [""]),
    0,
  )
}

output "sqs_arn_kms_and_redrive" {
  description = "The SQS KMS Queue ARN we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_kms_and_redrive.*.arn, [""]),
    0,
  )
}

output "sqs_id_redrive_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_redrive_and_no_policy.*.id, [""]),
    0,
  )
}

output "sqs_arn_redrive_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value = element(
    concat(aws_sqs_queue.queue_with_redrive_and_no_policy.*.arn, [""]),
    0,
  )
}

output "sqs_id_kms_and_redrive_and_no_policy" {
  description = "The SQS KMS Queue ID we just created"
  value = element(
    concat(
      aws_sqs_queue.queue_with_kms_and_redrive_and_no_policy.*.id,
      [""],
    ),
    0,
  )
}

output "sqs_arn_kms_and_redrive_and_no_policy" {
  description = "The SQS KMS Queue ARN we just created"
  value = element(
    concat(
      aws_sqs_queue.queue_with_kms_and_redrive_and_no_policy.*.arn,
      [""],
    ),
    0,
  )
}

