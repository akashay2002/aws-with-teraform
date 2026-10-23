output "s3_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website.id
}

output "website_url" {
  value = "https://${aws_cloudfront_distribution.website.domain_name}"
}