variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecr_image_url" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "input_bucket" {
  type = string
}

variable "output_bucket" {
  type = string
}

variable "queue_url" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}
