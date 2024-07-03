terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.64.0"
   }
 }

backend "s3" {
    # Replace this with your bucket name!
    bucket         = "vtb-aws-tf-backend"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
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
  source       = "./modules/eks"
  vpc_id       = module.vpc.vpc_id_output
  subnet_ids   = module.vpc.private_subnet_ids
  key_name     = var.key_name
  node_role_arn = var.node_role_arn
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