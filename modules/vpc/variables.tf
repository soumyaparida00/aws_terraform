variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for public subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"  # Provide a default value or change as needed
}


variable "availability_zones" {
  description = "A list of availability zones for the subnets"
  type        = list(string)
}
output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}
