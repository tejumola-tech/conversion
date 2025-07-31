module "vpc" {
  source              = "./modules/vpc"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  az                  = var.az
}

module "s3" {
   source = "./modules/s3"

  input_bucket_name  = "convertsaas-input-bucket"
  output_bucket_name = "convertsaas-output-bucket"

  input_queue_arn = module.sqs.input_queue_arn
  input_queue_url = module.sqs.input_queue_url

}

module "sqs" {
  source       = "./modules/sqs"
  project_name = var.project_name
  input_bucket_arn = module.s3.input_bucket_arn
}

module "iam" {
  source            = "./modules/iam"
  project_name      = var.project_name
  input_bucket_arn  = module.s3.input_bucket_arn
  output_bucket_arn = module.s3.output_bucket_arn
  sqs_queue_arn     = module.sqs.input_queue_arn
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  aws_region         = var.aws_region
  ecr_image_url      = var.ecr_image_url
  task_role_arn      = module.iam.ecs_task_execution_role_arn
  input_bucket       = module.s3.input_bucket_name
  output_bucket      = module.s3.output_bucket_name
  queue_url          = module.sqs.input_queue_url
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_id  = module.vpc.public_sg_id
}
