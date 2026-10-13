# Output the website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

# Output the API endpoint URL
output "api_endpoint" {
  value = "${aws_api_gateway_deployment.text_narrator_deployment.invoke_url}/${aws_api_gateway_resource.text_narrator_resource.path_part}"
}

# Output the CloudFront distribution URL
output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.text_to_speech_distribution.domain_name
}