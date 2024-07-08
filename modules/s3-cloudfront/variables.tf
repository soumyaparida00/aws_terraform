variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "react-app-bucket-101"
}

variable "aliases" {
  description = "The CloudFront distribution aliases"
  default     = ["test.virtualtechbox.com"]
}
