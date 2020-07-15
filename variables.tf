variable "name" {
  description = "A descriptive name for the SQS instance"
}

variable "environment" {
  description = "The environment the SQS is running in i.e. dev, prod etc"
}

variable "sqs_iam_user" {
  description = "The name of the iam user assigned to the created sqs bucket"
}

variable "number_of_users" {
  description = "The number of user to generate credentials for"
  default     = 1
}

variable "iam_user_policy_name" {
  description = "The policy name of attached to the user"
}

variable "policy" {
  description = "The JSON policy for the SQS queue (uses a default when stated)"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  default     = 345600
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  default     = 262144
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  default     = 0
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  default     = false
}

variable "kms_alias" {
  description = "KMS key alias name for SQS"
  default     = ""
}

variable "kms_key" {
  description = "KMS key id name for SQS"
  default     = ""
}

variable "redrive_arn" {
  description = "AWS ARN for the SQS redirect queue"
  default     = ""
}

variable "max_receive_count" {
  description = "The max receive count for a queue before Amazon SQS moves the message to a dead-letter queue"
  default     = "10"
}

variable "kms_key_policy" {
  description = "KMS key policy (uses a default policy if omitted)"
  default     = ""
}

variable "enable_set_attributes" {
  description = "Should the created iam user be permitted to set queue attributes"
  default     = true
}
