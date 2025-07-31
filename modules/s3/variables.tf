variable "input_bucket_name" {}
variable "output_bucket_name" {}

variable "input_queue_arn" {
  description = "ARN of the SQS queue to receive bucket events"
  type        = string
}

variable "input_queue_url" {
  description = "SQS queue URL"
  type        = string
}
