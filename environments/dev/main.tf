provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "eks" {
  source       = "../../modules/eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  key_name     = var.key_name
  node_role_arn = var.node_role_arn
}

module "s3-cloudfront" {
  source      = "../../modules/s3-cloudfront"
  bucket_name = var.bucket_name
  aliases     = var.aliases
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  table_name  = var.dynamodb_table_name
  environment = var.environment
}

terraform {
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.region
    dynamodb_table = module.dynamodb.table_name
  }
}
