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

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.6.0.0/16"
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  vpc_id                    = module.vpc.vpc_id_output
  cluster_name              = "my-eks-cluster"
  cluster_role_arn          = var.cluster_role_arn
  subnet_ids                = module.vpc.public_subnet_ids
  key_name                  = var.key_name
  node_role_arn             = var.node_role_arn
  instance_types            = var.instance_types
  node_desired_size         = var.node_desired_size
  node_max_size             = var.node_max_size
  node_min_size             = var.node_min_size
  tags                      = var.tags
  load_balancer_controller_policy_json = var.load_balancer_controller_policy_json
}

# ALB Module
module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id_output
  subnets            = module.vpc.public_subnet_ids
  security_group_ids = [module.eks.eks_security_group_id]
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

module "rds" {
  source = "./modules/rds"

  allocated_storage       = 20
  engine_version          = "15.4"
  instance_class          = "db.t3.micro"
  db_name                 = "nodeapp"
  username                = "adminuser"
  password                = "7Ew4X89d2Pg"
  parameter_group_name    = "postgres15"
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  subnet_ids              = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids) 
  skip_final_snapshot     = true
  final_snapshot_identifier = "final-snapshot"
  tags                    = {
    Name = "node-app"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id_output

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_port" {
  value = module.rds.rds_port
}

output "rds_instance_id" {
  value = module.rds.rds_instance_id
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
  value = module.eks.eks_cluster_id
}

output "cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.eks_cluster_certificate_authority_data
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
