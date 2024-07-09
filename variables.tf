# AWS Region
variable "region" {
  default = "ap-south-1"
}

# VPC Configuration
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
  default     = ["10.6.101.0/24", "10.6.102.0/24", "10.6.103.0/24"]
}

variable "availability_zones" {
  description = "A list of availability zones for the subnets"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

# EC2 Key Pair
variable "key_name" {
  description = "The name of the EC2 key pair"
  default     = "id_rsa"
}

# IAM Role for EKS Node Group
variable "node_role_arn" {
  description = "The IAM role ARN for the EKS node group"
  default     = "arn:aws:iam::851725524405:role/AmazonEKSNodeRole"
}

# S3 Bucket for Application
variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "reactappbucket-10"
}

# CloudFront Distribution Aliases
variable "aliases" {
  description = "The CloudFront distribution aliases"
  default     = ["test.virtualtechbox.com"]
}

# Backend S3 Bucket for Terraform State
variable "backend_bucket" {
  description = "The S3 bucket for storing Terraform state"
  default     = "terraform-vtb"
}

# Backend Key for Terraform State
variable "backend_key" {
  description = "The key for storing the Terraform state in S3"
  default     = "terraform/terraform.tfstate"
}

# DynamoDB Table for State Locking
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  default     = "terraform-state-lock"
}

# Environment Tag
variable "environment" {
  description = "The environment for which the resources are created"
  default     = "dev"
}

# IAM Role for EKS Cluster Permissions
variable "cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster."
  type        = string
  default     = "arn:aws:iam::851725524405:role/eksClusterRole"
}

# Subnet IDs for EKS Cluster and Node Groups
variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster and node groups will be deployed."
  type        = list(string)
  default     = []
}

# EC2 Instance Types for EKS Node Group
variable "instance_types" {
  description = "List of EC2 instance types for the EKS node group."
  type        = list(string)
  default     = ["t3.medium"]
}

# Autoscaling Settings for EKS Node Group
variable "node_desired_size" {
  description = "Desired number of nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of nodes in the EKS node group."
  type        = number
  default     = 1
}

# Tags for Resources
variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

# IAM Policy JSON for AWS Load Balancer Controller
variable "load_balancer_controller_policy_json" {
  description = "The JSON policy document for the AWS Load Balancer Controller IAM policy."
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress",
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteRule",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
