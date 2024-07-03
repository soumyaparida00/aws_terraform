terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.0"
    }
  }

  backend "s3" {
    bucket         = "vtb-aws-tf-backend"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# Define the AWS VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  vpc_id            = aws_vpc.main.id  # Reference the VPC ID here
  cluster_name      = "my-eks-cluster"
  cluster_role_arn  = var.cluster_role_arn
  subnet_ids        = var.subnet_ids
  key_name          = var.key_name
  node_role_arn     = var.node_role_arn
  instance_types    = var.instance_types
  node_desired_size = var.node_desired_size
  node_max_size     = var.node_max_size
  node_min_size     = var.node_min_size
  tags              = var.tags
  load_balancer_controller_policy_json = var.load_balancer_controller_policy_json
}

# ALB Module
module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id_output
  subnets            = module.vpc.public_subnet_ids
  security_group_ids = [module.eks.cluster_security_group_id]
  name               = "my-app-alb"
}

# S3 and CloudFront Module
module "s3-cloudfront" {
  source      = "./modules/s3-cloudfront"
  bucket_name = var.bucket_name
  aliases     = var.aliases
}

# DynamoDB State Lock Module
module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = var.dynamodb_table_name
  environment = var.environment
}

# AWS Key Pair Resource
resource "aws_key_pair" "id_rsa" {
  key_name   = "id_rsa"
  public_key = file("./id_rsa.pub")

  tags = {
    Name = "test_server"
  }
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  value = module.vpc.vpc_id_output
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
