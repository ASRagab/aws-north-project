## Create IAM Execution Role for ECS
resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_document.json
}

### Create IAM Task Role for Missouri Services Task
resource "aws_iam_role" "missouri_services_task" {
  name               = "missouri-services-task-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_document.json
}

data "aws_iam_policy_document" "ecs_assume_role_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name        = "ecs_execution_policy"
  description = "Policy for ECS Task Execution"
  policy      = data.aws_iam_policy_document.ecs_execution_policy.json
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}