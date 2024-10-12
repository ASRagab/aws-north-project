resource "aws_kms_key" "this" {
  description         = "Core KMS key"
  is_enabled          = true
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "this" {
  target_key_id = aws_kms_key.this.key_id
  name          = "alias/core"
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Allow administration of key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:root",
        "arn:aws:iam::${var.account_id}:user/ahmad" # NOTE: Only for testing and demo purposes (reserved sso roles should be used here)
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    sid    = "Allow KMS Use by CloudWatch Log Groups"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region_name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region_name}:${var.account_id}:log-group:*"]
    }
  }
  statement {
    effect = "Allow"
    sid    = "Allow KMS Use from AWS Services"
    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["*.${var.region_name}.amazonaws.com"]
    }
  }
}