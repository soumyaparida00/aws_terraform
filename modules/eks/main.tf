module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.1"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.22"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  tags = {
    Name = "my-eks-cluster"
  }
}

resource "aws_eks_node_group" "spot_nodes" {
  cluster_name    = module.eks.cluster_id
  node_group_name = "spot-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  capacity_type = "SPOT"
  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = var.key_name
  }

  tags = {
    Name = "spot-nodes"
  }
}
