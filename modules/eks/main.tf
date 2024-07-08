resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids                = var.subnet_ids
    endpoint_private_access   = true
    endpoint_public_access    = true
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.service_policy,
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy
  ]
}
resource "aws_eks_addon" "vpc_cni" {
  cluster_name   = aws_eks_cluster.this.name
  addon_name     = "vpc-cni"
  addon_version  = "v1.12.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name   = aws_eks_cluster.this.name
  addon_name     = "kube-proxy"
  addon_version  = "v1.24.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_addon" "coredns" {
  cluster_name   = aws_eks_cluster.this.name
  addon_name     = "coredns"
  addon_version  = "v1.8.7-eksbuild.1"
  resolve_conflicts = "OVERWRITE"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  remote_access {
    ec2_ssh_key = var.key_name
  }

  ami_type       = "AL2_x86_64"
  instance_types = var.instance_types
  capacity_type  = "SPOT"

  tags = merge(
    var.tags,
    {
      "Name" = "${var.cluster_name}-node-group",
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )

  depends_on = [aws_eks_cluster.this]
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKS-Cluster-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Load Balancer Controller IAM Role
resource "aws_iam_policy" "load_balancer_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "IAM policy for the AWS Load Balancer Controller"
  policy      = var.load_balancer_controller_policy_json
}

resource "aws_iam_role" "load_balancer_controller_role" {
  name               = "AWSLoadBalancerControllerRole"
  assume_role_policy = data.aws_iam_policy_document.load_balancer_assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller_attach" {
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
  role       = aws_iam_role.load_balancer_controller_role.name
}

data "aws_iam_policy_document" "load_balancer_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com", "eks-fargate-pods.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Kubernetes ConfigMap for EKS Auth
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode([
      {
        rolearn  = var.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
      {
        rolearn  = aws_iam_role.load_balancer_controller_role.arn
        username = "aws-load-balancer-controller"
        groups   = ["system:masters"]
      }
    ])
  }
}

output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "load_balancer_controller_role_arn" {
  value = aws_iam_role.load_balancer_controller_role.arn
}
