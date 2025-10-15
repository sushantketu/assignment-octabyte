#Main file

provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "sushantketu_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "sushantketuvpc"
  }
}

# Subnets (public and private)
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.sushantketu_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "sushantketupublicsubnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sushantketu_vpc.id
  tags = {
    Name = "sushantketuigw"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.sushantketu_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "sushantketurt"
  }
}

# Associate Route Table with public subnets
resource "aws_route_table_association" "rt_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt.id
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "sushantketucluster"
  cluster_version = "1.27"

  vpc_id     = aws_vpc.sushantketu_vpc.id
  subnet_ids = aws_subnet.public[*].id

  node_groups = {
    sushantketu_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"
      key_name      = var.key_name
    }
  }

  tags = {
    Environment = "production"
    Owner       = "sushantketu"
  }
}

# S3 backend bucket reference
terraform {
  backend "s3" {
    bucket = "flyingsushantketu"
    key    = "terraform.tfstate"
    region = var.region
  }
}

