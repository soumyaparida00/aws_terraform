variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
}

variable "subnet_ids" {
  description = "The subnet IDs where the EKS cluster will be deployed"
  type        = list(string)
}

variable "key_name" {
  description = "The name of the EC2 key pair"
  default     = "id_rsa" # Change to your EC2 key pair name
}

variable "node_role_arn" {
  description = "The IAM role ARN for the EKS node group"
  default = "arn:aws:iam::851725524405:role/AmazonEKSNodeRole"
}
