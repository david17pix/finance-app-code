resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.resource_prefix.value}-analysis-lambda"


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

  tags = {
    yor_trace            = "3f916b92-d2eb-4265-adc6-21d623acdd48"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/lambda.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_lambda_function" "analysis_lambda" {
  # lambda have plain text secrets in environment variables
  filename      = "resources/lambda_function_payload.zip"
  function_name = "${local.resource_prefix.value}-analysis"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "exports.test"

  source_code_hash = "${filebase64sha256("resources/lambda_function_payload.zip")}"

  runtime = "nodejs12.x"

  environment {
    variables = {
      access_key = "AKIAIOSFODNN7EXAMPLE"
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    }
  }

  tags = {
    yor_trace            = "5600b73c-2d1e-4169-ab60-628dcfd3c624"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/lambda.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}