variable "region" {
  description = "AWS region where resources will be created"
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
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
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "eks_version" {
  description = "Version of Amazon EKS"
  default     = "1.20"
}

variable "instance_type" {
  description = "EC2 instance type for EKS node group"
  default     = "t3.medium"
}
