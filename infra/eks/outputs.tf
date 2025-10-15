
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.sushantketu_vpc.id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_group_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = module.eks.node_groups["sushantketu_nodes"].iam_role_arn
}
