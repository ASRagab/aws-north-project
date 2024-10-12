variable "msk_firehose_bucket_arn" {
  description = "ARN of the S3 bucket for the MSK Firehose"
  type        = string
}

variable "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  type        = string
}
