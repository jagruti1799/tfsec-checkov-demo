
data "archive_file" "terminate_spot" {
  type        = "zip"
  source_file = "./boto3tutorial.py"
  output_path = "boto3tutorial.zip"
}

resource "aws_lambda_function" "stop_scheduler" {
  filename         = data.archive_file.terminate_spot.output_path
  function_name    = "boto3tutorial"
  role             = aws_iam_role.terminate_spot.arn
  handler          = "boto3tutorial.lambda_handler"
  runtime          = "python3.8"
  timeout          = 300
  source_code_hash = data.archive_file.terminate_spot.output_base64sha256
  
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every_five_minutes"
  description         = "Instance will get terminated after 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "check_every_five_minutes" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "stop_scheduler"
  arn       = aws_lambda_function.stop_scheduler.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}