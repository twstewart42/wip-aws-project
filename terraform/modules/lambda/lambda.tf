provider "aws" {
    region = "us-east-1"
    profile = "default"
}


resource "aws_iam_role" "iam_for_lambda" {
    name = "lambda_exe_signup"
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

resource "aws_lambda_function" "lambda-sign-up" {
    filename = "../../lambda/lambda_account_sign_up.zip" 
    # change to .zip
    function_name = "${var.lambda-sign-up-name}"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "lambda_account_sign_up.handler"
    runtime = "python3.7"
    source_code_hash = "${filebase64sha256("../../lambda/lambda_account_sign_up.zip")}"
    tags = {
        Name = "${var.lambda-sign-up-name}"
        Project = "${var.tag-project}"
        Enviroment = "${var.tag-env}"
    }
}

resource "aws_lambda_function" "lambda-authentication" {
    filename = "../../lambda/lambda_check_authentication.zip"
    # change to .zip
    function_name = "${var.lambda-check-auth-name}"
    role = "${aws_iam_role.iam_for_lambda.arn}"
    handler = "lambda_check_authentication.handler"
    runtime = "python3.7"
    source_code_hash = "${filebase64sha256("../../lambda/lambda_check_authentication.zip")}"
    tags = {
        Name = "${var.lambda-check-auth-name}"
        Project = "${var.tag-project}"
        Enviroment = "${var.tag-env}"
    }
}
