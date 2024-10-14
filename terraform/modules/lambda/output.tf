output "msk_producer_lambda_invoke_arn" {
  value = aws_lambda_function.msk_producer.invoke_arn
}

output "msk_producer_lambda_name" {
  value = aws_lambda_function.msk_producer.function_name
}
