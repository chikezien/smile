provider "aws" {
  region = var.region
}

# VPC to host EKS
resource "aws_vpc" "api_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subnets for EKS
resource "aws_subnet" "my_subnets" {
  count = length(var.subnet_cidr_blocks)
  vpc_id = aws_vpc.api_vpc.id
  cidr_block = var.subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)
}

# Security Group for the EKS cluster
resource "aws_security_group" "eks_cluster_sg" {
  vpc_id = aws_vpc.api_vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.api_vpc.cidr_block]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [aws_vpc.api_vpc.cidr_block]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_service_role" {
  name = "eks-service-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

# IAM Role Policy for EKS Cluster
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_service_role.arn
  version  = var.eks_version
  vpc_config {
    subnet_ids = aws_subnet.my_subnets[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

# Node Group for EKS
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.my_subnets[*].id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = [var.instance_type]
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}
