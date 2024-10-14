resource "aws_iam_role" "firehose_iam_role" {
  name               = "msk-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_document.json
}

data "aws_iam_policy_document" "firehose_assume_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "firehose_iam_role_policy_document" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.msk_firehose_bucket_arn,
      "${var.msk_firehose_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"] # You might want to restrict this to specific KMS key ARNs if known
  }

  statement {
    actions = [
      "kafka:GetBootstrapBrokers",
      "kafka:DescribeCluster",
      "kafka:DescribeClusterV2",
      "kafka:GetSaslCredentials"
    ]
    resources = [
      var.msk_cluster_arn
    ]
  }
}

resource "aws_iam_policy" "msk_firehose_iam_role_policy" {
  name   = "msk-firehose-iam-role-policy"
  policy = data.aws_iam_policy_document.firehose_iam_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "msk_firehose_iam_role_policy_attachment" {
  role       = aws_iam_role.firehose_iam_role.name
  policy_arn = aws_iam_policy.msk_firehose_iam_role_policy.arn
}
