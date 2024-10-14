# IAM role for the Lambda function
resource "aws_iam_role" "msk_producer_lambda_role" {
  name               = "msk-producer-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM policies for the Lambda function
data "aws_iam_policy_document" "msk_producer_lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:AlterCluster",
      "kafka-cluster:DescribeCluster"
    ]
    resources = [var.msk_cluster_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:*Topic*",
      "kafka-cluster:WriteData",
      "kafka-cluster:ReadData"
    ]
    resources = ["arn:aws:kafka:${var.region}:${var.account_id}:topic/${var.msk_cluster_name}/${var.msk_cluster_uuid}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:AlterGroup",
      "kafka-cluster:DescribeGroup"
    ]
    resources = ["arn:aws:kafka:${var.region}:${var.account_id}:group/${var.msk_cluster_name}/${var.msk_cluster_uuid}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "msk_producer_lambda_policy" {
  name   = "msk-producer-lambda-policy"
  policy = data.aws_iam_policy_document.msk_producer_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "msk_producer_lambda_policy_attachment" {
  role       = aws_iam_role.msk_producer_lambda_role.name
  policy_arn = aws_iam_policy.msk_producer_lambda_policy.arn
}


# Lambda function
resource "aws_lambda_function" "msk_producer" {
  filename         = "${path.module}/msk-lambda-producer.zip"
  function_name    = "msk-producer-lambda-dev"
  role             = aws_iam_role.msk_producer_lambda_role.arn
  handler          = "index.handler"
  source_code_hash = filebase64sha256("${path.module}/msk-lambda-producer.zip")
  runtime          = "nodejs20.x"

  environment {
    variables = {
      MSK_BOOTSTRAP_BROKERS = var.msk_bootstrap_brokers
      TOPIC_NAME            = var.topic_name
      AMAZON_REGION         = var.region
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  logging_config {
    log_format = "JSON"
  }

  # Ensure the Lambda has access to the VPC
  depends_on = [
    aws_iam_role_policy_attachment.msk_producer_lambda_policy_attachment,
  ]
}
