resource "aws_s3_bucket" "input_bucket" {
  bucket = var.input_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_notification" "s3_to_sqs" {
  bucket = aws_s3_bucket.input_bucket.id

  queue {
    queue_arn     = var.input_queue_arn
    events        = ["s3:ObjectCreated:*"]
  }

}
