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
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "cloud-cost-hero"
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster."
  type        = string
}

variable "instance_types" {
  description = "List of EC2 instance types for the EKS node group."
  type        = list(string)
  default     = ["t3.medium"]
}

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

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "load_balancer_controller_policy_json" {
  description = "The JSON policy document for the AWS Load Balancer Controller IAM policy."
  type        = string
  default     = file("./aws-load-balancer-controller-policy.json")
}
