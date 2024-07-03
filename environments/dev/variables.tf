variable "region" {
  description = "The AWS region to deploy to"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.6.0.0/16"
}

variable "key_name" {
  description = "The name of the EC2 key pair"
  default     = "id_rsa" # Change to your EC2 key pair name
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "your-react-app-bucket-dev"
}

variable "aliases" {
  description = "The CloudFront distribution aliases"
  default     = ["dev.virtualtechbox.com"]
}
variable "node_role_arn" {
  description = "The IAM role ARN for the EKS node group"
  default = "arn:aws:iam::851725524405:role/AmazonEKSNodeRole"
}
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  default     = "terraform-state-lock-dev"
}
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  default     = "terraform-state-lock-dev"
}

variable "environment" {
  description = "The environment for which the resources are created"
  default     = "dev"
}

variable "backend_bucket" {
  description = "The S3 bucket for storing Terraform state"
  default     = "terraform-vtb"
}

variable "backend_key" {
  description = "The key for storing the Terraform state in S3"
  default     = "dev/terraform.tfstate"
}