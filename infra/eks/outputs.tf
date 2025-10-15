output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.sushantketu_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = aws_security_group.eks_cluster_sg.id
}

output "node_group_role_arn" {
  description = "IAM role ARN for the EKS worker nodes"
  value       = module.eks.node_groups["sushantketu_nodes"].iam_role_arn
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app_alb.dns_name
}
