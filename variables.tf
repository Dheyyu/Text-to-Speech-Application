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

# Configure the S3 bucket name
variable "s3-bucket-name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "new-text-to-speech-narrator"
}
