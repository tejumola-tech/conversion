variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "az" {}


variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "ecr_image_url" {
  type        = string
  description = "URL of the ECR image to deploy"
}