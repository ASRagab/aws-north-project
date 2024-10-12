# EMR Serverless Bucket

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  lower   = true
  upper   = false
}

# Firehose Destination Bucket
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "msk-firehose-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "firehose_bucket" {
  bucket = aws_s3_bucket.firehose_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "firehose_bucket_public_access_block" {
  bucket = aws_s3_bucket.firehose_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
