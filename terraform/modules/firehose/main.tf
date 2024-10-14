resource "aws_kinesis_firehose_delivery_stream" "msk_serverless_delivery_stream" {
  name        = "msk-serverless-to-s3-delivery-stream-dev"
  destination = "extended_s3"

  msk_source_configuration {
    msk_cluster_arn = var.msk_cluster_arn
    topic_name      = "firehose-s3-delivery"
    authentication_configuration {
      connectivity = "PRIVATE"
      role_arn     = aws_iam_role.firehose_iam_role.arn
    }
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_iam_role.arn
    bucket_arn = var.msk_firehose_bucket_arn

    prefix              = "msk-data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "msk-errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/missouri/msk-to-s3"
      log_stream_name = "S3Delivery"
    }
  }
}