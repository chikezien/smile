provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "api_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Subnets in multiple availability zones for high availability
resource "aws_subnet" "my_subnets" {
  count                   = length(var.subnet_cidr_blocks)
  vpc_id                  = aws_vpc.api_vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

# Security Group for EKS cluster and application
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster and nodes"
  vpc_id      = aws_vpc.api_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM roles for EKS service and nodes
resource "aws_iam_role" "eks_service_role" {
  name               = "eks-service-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

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

# EKS Cluster setup
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_service_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = aws_subnet.my_subnets[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

# Node group configuration
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_service_role.arn
  subnet_ids      = aws_subnet.my_subnets[*].id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = [var.instance_type]
}

# Create an S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "my-cloudtrail-logs-${var.region}"
  acl    = "private"
}

# CloudTrail setup to use the S3 bucket
resource "aws_cloudtrail" "api_activity_trail" {
  name                          = "api-activity-trail-${var.region}"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}
