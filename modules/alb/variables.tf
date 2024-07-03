variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to associate with the ALB."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ALB."
  type        = list(string)
}

variable "name" {
  description = "The name of the ALB."
  type        = string
  default     = "alb"
}
