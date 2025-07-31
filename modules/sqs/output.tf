output "input_queue_url" {
  value = aws_sqs_queue.input_queue.id
}

output "input_queue_arn" {
  value = aws_sqs_queue.input_queue.arn
}
