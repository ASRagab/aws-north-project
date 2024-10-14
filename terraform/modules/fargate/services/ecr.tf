resource "aws_ecr_repository" "missouri_services" {
  name = "${var.service_name}-${var.environment}"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "missouri_services" {
  policy     = data.aws_iam_policy_document.missouri_services.json
  repository = aws_ecr_repository.missouri_services.name
}

data "aws_iam_policy_document" "missouri_services" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:BatchDeleteImage"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "arn:aws:secretsmanager:${var.region}:${var.aws_account_id}:secret:*"
    ]
  }
}

data "aws_ecr_image" "missouri_services" {
  repository_name = aws_ecr_repository.missouri_services.name
  image_tag       = var.image_tag
}
