output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "s3_bucket_name" {
  value = module.s3-cloudfront.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.s3-cloudfront.cloudfront_distribution_id
}

output "cloudfront_distribution_domain_name" {
  value = module.s3-cloudfront.cloudfront_distribution_domain_name
}
