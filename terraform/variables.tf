# variables.tf

variable "region" {
  description = "AWS region where resources will be created"
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "AWS availability zone for subnets"
  default     = "us-west-2a"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-cluster"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "eks_version" {
  description = "Version of Amazon EKS"
  default     = "1.20"
}

variable "instance_type" {
  description = "EC2 instance type for EKS node group"
  default     = "t3.medium"
}
