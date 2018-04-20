output "sqs_id" {
  description = "The SQS Queue ID we just created"
  value       = "${aws_sqs_queue.queue.id}"
}

output "sqs_arn" {
  description = "The SQS Queue ARN we just created"
  value       = "${aws_sqs_queue.queue.arn}"
}
