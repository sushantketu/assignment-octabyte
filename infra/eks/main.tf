provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "sushantketu_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "sushantketuvpc"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.sushantketu_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)
  tags = {
    Name = "sushantketupublicsubnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.sushantketu_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "sushantketuprivatesubnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sushantketu_vpc.id
  tags = {
    Name = "sushantketuigw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sushantketu_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "sushantketuprt-public"
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public_route_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway for Private Subnets
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "sushantketu-natgw-${count.index + 1}"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.sushantketu_vpc.id
  tags = {
    Name = "sushantketuprt-private"
  }
}

# Routes for Private Route Table to NAT Gateway
resource "aws_route" "private_nat_route" {
  count                   = length(aws_nat_gateway.nat)
  route_table_id          = aws_route_table.private_rt.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat[count.index].id
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private_route_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for EKS Cluster Control Plane
resource "aws_security_group" "eks_cluster_sg" {
  name        = "sushantketu-eks-cluster-sg"
  description = "Security group for EKS cluster communication"
  vpc_id      = aws_vpc.sushantketu_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_worker_sg" {
  name        = "sushantketu-eks-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.sushantketu_vpc.id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EKS Cluster with Node Group(s)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "sushantketucluster"
  cluster_version = "1.27"

  vpc_id     = aws_vpc.sushantketu_vpc.id
  subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)

  cluster_security_group_id = aws_security_group.eks_cluster_sg.id

  node_groups = {
    sushantketu_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = var.key_name
      additional_security_group_ids = [aws_security_group.eks_worker_sg.id]
    }
  }

  tags = {
    Environment = "production"
    Owner       = "sushantketu"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "sushantketu-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "sushantketu-rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier         = "sushantketu-postgres-db"
  allocated_storage  = 20
  engine             = "postgres"
  engine_version     = "15.2"
  instance_class     = "db.t3.micro"
  name               = var.db_name
  username           = var.db_username
  password           = var.db_password
  parameter_group_name = "default.postgres15"
  skip_final_snapshot = true
  publicly_accessible = false
  multi_az           = false
  storage_type       = "gp2"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.eks_worker_sg.id]

  tags = {
    Name = "sushantketu-postgres-db"
  }
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "sushantketu-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.eks_worker_sg.id]

  tags = {
    Name = "sushantketu-app-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "sushantketu-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sushantketu_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "sushantketu-tg"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
