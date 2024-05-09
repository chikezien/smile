provider "aws" {
  region = var.region
}

resource "aws_vpc" "api_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "my_subnets" {
  count = length(var.subnet_cidr_blocks)
  vpc_id = aws_vpc.api_vpc.id
  cidr_block = var.subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone
}

resource "aws_security_group" "eks_cluster_sg" {
  vpc_id = aws_vpc.api_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Assuming API load balancer is defined elsewhere
    cidr_blocks = [aws_lb.api_lb[0].security_groups[0]]
  }

  egress {
    from_port = 0 # Allow all outbound ports
    to_port = 0
    protocol = "-1" # Allow all protocols

    # Allow outbound traffic to the VPC CIDR block by default
    cidr_blocks = [aws_vpc.api_vpc.cidr_block]
  }
}

resource "aws_iam_role" "eks_service_role" {
  name               = "eks-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service_role.name
}

resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_service_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = aws_subnet.my_subnets[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}
