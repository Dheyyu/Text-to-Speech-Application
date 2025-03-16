# Create the S3 bucket for the text narrator
resource "aws_s3_bucket" "text-narrator" {
  bucket = var.s3-bucket-name

  force_destroy = true // Allows the bucket to be deleted even if it contains objects
}

# Create the IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# Attach basic Lambda execution role policy
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach full access policies for Amazon Polly
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}

# Attach full access policies for Amazon S3 Bucket
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Configure the Lambda function (assuming the code is in a file named lambda_function.zip)
resource "aws_lambda_function" "text_narrator_lambda" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_function_handler
  runtime          = var.lambda_function_runtime
  timeout          = var.lambda_function_timeout // Timeout in seconds
  filename         = var.lambda_function_code_filename
  source_code_hash = filebase64sha256(var.lambda_function_code_filename)

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.text-narrator.id
    }
  }
}


# Test your application with this
/*

{
  "body": "{ \"text\": \"Hello! My name is Oladayo David Ayorinde and I successfully built a text-to-speech application using Amazon Polly, S3 Bucket, and AWS Lambda. Thank your for your time and I hope this project helps you.\" }"
}

*/
