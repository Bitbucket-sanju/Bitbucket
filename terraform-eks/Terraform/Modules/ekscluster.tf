resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks_cluster"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.prv-sub.*.id)
  }
  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}

module "eks_worker_nodes" {
  source = "cloudposse/eks-node-group/aws"

  cluster_name = aws_eks_cluster.eks_cluster.name
  subnet_ids   = aws_subnet.prv-sub.*.id
  min_size     = 1
  max_size     = 4
  desired_size = 2
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

/*ArgoCD */

