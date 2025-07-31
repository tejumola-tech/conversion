resource "aws_sqs_queue" "input_queue" {
  name                      = "${var.project_name}-input-queue"
  visibility_timeout_seconds = 300

  tags = {
    Name = "${var.project_name}-input-queue"
  }
}

resource "aws_sqs_queue_policy" "s3_send_permission" {
  queue_url = aws_sqs_queue.input_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.input_queue.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" = var.input_bucket_arn
          }
        }
      }
    ]
  })
}
