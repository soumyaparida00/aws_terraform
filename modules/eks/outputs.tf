output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_load_balancer_controller_role_arn" {
  value = aws_iam_role.load_balancer_controller_role.arn
}