resource "aws_ecr_repository" "missouri_services" {
  name = "elastic-agent-${var.environment}"
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
}

data "aws_ecr_image" "missouri_services" {
  repository_name = aws_ecr_repository.missouri_services.name
  image_tag       = var.missouri_services_image_tag
}
