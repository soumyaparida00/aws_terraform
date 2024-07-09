variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "reactappbucket-10"
}

variable "aliases" {
  description = "The CloudFront distribution aliases"
  default     = ["test.virtualtechbox.com"]
}
