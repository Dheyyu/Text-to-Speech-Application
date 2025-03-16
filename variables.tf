# Configure the AWS region
variable "aws-region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"
}

# Configure the AWS Credentials
# Configure the AWS access key
variable "access_key" {
  description = "AWS Access Key"
  type        = string
  // Add the default value which include your AWS Access Key ID
}

# Configure the AWS secret key
variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  // Add the default value which include your AWS Secret Access Key
}

# Step 1: Congigure the S3 bucket for the text narrator
# Configure the S3 bucket name
variable "s3-bucket-name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "text-to-speech-narrator"

}

# Create the IAM Role for Lambda
# Configure the IAM role name
variable "iam_role_name" {
  description = "The name of the IAM role for Lambda"
  type        = string
  default     = "lambda_execution_role"
}

# Configure the Lambda Function
# Configure the Lambda function name
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "text_narrator_lambda"
}

# Configure the Lambda function handler
variable "lambda_function_handler" {
  description = "The handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

# Configure the Lambda function runtime
variable "lambda_function_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

# Configure the Lambda function timeout (in seconds)
variable "lambda_function_timeout" {
  description = "The timeout for the Lambda function in seconds"
  type        = number
  default     = 300
}

# Configure the filename for the Lambda function code
variable "lambda_function_code_filename" {
  description = "The filename for the Lambda function code"
  type        = string
  default     = "lambda_function.zip"
}
