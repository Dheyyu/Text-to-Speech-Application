# Frontend code for the application
# Configure the API Gateway to trigger the Lambda function
resource "aws_api_gateway_rest_api" "text_narrator_api" {
  name        = var.api_gateway_name
  description = "API Gateway for Text Narrator Lambda Function"
}

# Configure the API Gateway resource path
resource "aws_api_gateway_resource" "text_narrator_resource" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  parent_id   = aws_api_gateway_rest_api.text_narrator_api.root_resource_id
  path_part   = "convert"
}

# Configure the API Gateway method to trigger the Lambda function
resource "aws_api_gateway_method" "text_narrator_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id   = aws_api_gateway_resource.text_narrator_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrate the API Gateway with the Lambda function
resource "aws_api_gateway_integration" "text_narrator_integration" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id = aws_api_gateway_resource.text_narrator_resource.id
  http_method = aws_api_gateway_method.text_narrator_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.text_narrator_lambda.invoke_arn
}

# Configure the API Gateway deployment
resource "aws_api_gateway_deployment" "text_narrator_deployment" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_integration.text_narrator_integration
  ]

}

# Configure the lambda permission for API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.text_narrator_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.text_narrator_api.execution_arn}/*/*"
}

# CORS Configuration for the API Gateway
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id   = aws_api_gateway_resource.text_narrator_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id = aws_api_gateway_resource.text_narrator_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id = aws_api_gateway_resource.text_narrator_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.text_narrator_api.id
  resource_id = aws_api_gateway_resource.text_narrator_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# Configure the S3 bucket for the frontend hosting
resource "aws_s3_bucket" "frontend_bucket" {
  bucket        = var.frontend_bucket_name
  force_destroy = true
}

# S3 bucket configuration for website hosting
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Disable the "block public access" settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure the S3 bucket policy to allow public read access
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket     = aws_s3_bucket.frontend_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      }
    ]
  })
}

# Output the website URL and API endpoint
output "website_url" {
  value = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

output "api_endpoint" {
  value = "${aws_api_gateway_deployment.text_narrator_deployment.invoke_url}/${aws_api_gateway_resource.text_narrator_resource.path_part}"
}
