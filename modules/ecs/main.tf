resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "converter"
      image     = var.ecr_image_url
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = [
        { name = "INPUT_BUCKET",  value = var.input_bucket },
        { name = "OUTPUT_BUCKET", value = var.output_bucket },
        { name = "QUEUE_URL",     value = var.queue_url }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups = [var.security_group_id]
  }

  depends_on = [aws_ecs_task_definition.this]
}
