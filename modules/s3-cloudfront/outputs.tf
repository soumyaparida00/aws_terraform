output "bucket_name" {
  value = aws_s3_bucket.reactappbucket-10.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.react_app_distribution.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.react_app_distribution.domain_name
}