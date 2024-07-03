variable "region" {    
    default = "ap-south-1"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.6.0.0/16"
}
variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for private subnets"
  default     = ["10.6.1.0/24", "10.6.2.0/24", "10.6.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  default     = ["10.6.101.0/24", "10.6.102.0/24", "10.6.102.0/24"]
}

variable "availability_zones" {
  description = "A list of availability zones for the subnets"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "key_name" {
  description = "The name of the EC2 key pair"
  default     = "id_rsa" # Change to your EC2 key pair name
}
variable "node_role_arn" {
  description = "The IAM role ARN for the EKS node group"
  default = "arn:aws:iam::851725524405:role/AmazonEKSNodeRole"
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "react-app-bucket"
}
variable "aliases" {
  description = "The CloudFront distribution aliases"
  default     = ["test.virtualtechbox.com"]
}
variable "backend_bucket" {
  description = "The S3 bucket for storing Terraform state"
  default     = "terraform-vtb"
}
variable "backend_key" {
  description = "The key for storing the Terraform state in S3"
  default     = "terraform/terraform.tfstate"
}
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  default     = "terraform-state-lock"
}
variable "environment" {
  description = "The environment for which the resources are created"
  default     = "dev"
}