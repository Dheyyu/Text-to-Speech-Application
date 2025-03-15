# Create the S3 bucket for the text narrator
resource "aws_s3_bucket" "text-narrator" {
  bucket = var.s3-bucket-name
}
