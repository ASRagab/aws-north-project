output "msk_firehose_bucket_arn" {
  value = aws_s3_bucket.firehose_bucket.arn
}

output "msk_firehose_bucket_name" {
  value = aws_s3_bucket.firehose_bucket.bucket
}

