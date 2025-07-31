variable "project_name" {
  description = "Name of the project for tagging and naming"
  type        = string
}

variable "input_bucket_arn" {
  description  = "ARN of the input s3 bucket"
  type         = string
}
