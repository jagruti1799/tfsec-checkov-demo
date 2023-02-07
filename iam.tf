resource "aws_iam_role" "terminate_spot" {
  name               = "terminate_spot"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "terminate_spot_scheduler" {
  statement {
    actions = [
      "ec2:Describe",
      "ec2:Start",
      "ec2:Stop",
      "ec2:Terminate",
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]
    resources = [aws_s3_bucket.demobucket.arn]
  }
}

resource "aws_iam_policy" "terminate_spot_scheduler" {
  name   = "ec2_access_scheduler"
  path   = "/"
  policy = data.aws_iam_policy_document.terminate_spot_scheduler.json
}

resource "aws_iam_role_policy_attachment" "ec2_access_scheduler" {
  role       = aws_iam_role.terminate_spot.name
  policy_arn = aws_iam_policy.terminate_spot_scheduler.arn
}