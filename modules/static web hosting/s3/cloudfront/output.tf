output "bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "website_url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}