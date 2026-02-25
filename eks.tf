module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  vpc_id     = aws_vpc.bedrock_vpc.id
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  cluster_endpoint_public_access = true

  # Control plane logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  eks_managed_node_groups = {
    bedrock_nodes = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      tags = {
        Project = "barakat-2025-capstone"
      }
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Project = "barakat-2025-capstone"
  }
}