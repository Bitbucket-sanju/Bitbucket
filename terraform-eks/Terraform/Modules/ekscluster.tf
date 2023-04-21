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


# IAM roles and policies for ArgoCD
resource "aws_iam_role" "argocd" {
  name = "argocd"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "argocd" {
  name        = "argocd"
  description = "IAM policy for ArgoCD"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:Describe*",
          "eks:List*",
          "eks:AccessKubernetesApi",
          "ec2:Describe*",
          "iam:ListRoles",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRolePolicy",
          "iam:SimulatePrincipalPolicy"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "argocd:*",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "argocd" {
  policy_arn = aws_iam_policy.argocd.arn
  role       = aws_iam_role.argocd.name
}

# Kubernetes resources for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_service_account" "argocd" {
  metadata {
    name      = "argocd"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
}

# ArgoCD installation using Helm
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "server.service.annotations.load-balancer-external-dns.alpha.kubernetes.io/hostname"
    value = "argocd.example.com"
  }

  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    <<EOF
global:
  rbac:
    create: true
  image:
    repository: argoproj/argocd
    tag: v2.2.2
server:
  extraArgs:
    - --rbac.policy.default-role=admin
    - --disable-auth
EOF
  ]

  depends_on = [
    aws_iam_role_policy_attachment.argocd
  ]
}
