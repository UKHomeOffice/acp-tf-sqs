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
