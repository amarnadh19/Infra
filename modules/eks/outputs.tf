output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
  value       = aws_eks_node_group.node.id
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.node.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.node.status
}

output "node_role_arn" {
  description = "ARN of the IAM Role assigned to nodes"
  value       = aws_iam_role.eks_nodes.arn
}

output "node_group_resources" {
  description = "List of objects containing information about AutoScaling Groups and Security Groups used by the nodes"
  value       = aws_eks_node_group.node.resources
}


output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}
output "cluster_id" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API server"
  value       = aws_eks_cluster.cluster.endpoint
}

###############

output "cluster_security_group_id" {
  description = "The security group ID created by the EKS cluster control plane"
  # This pulls the ID automatically created by AWS for the cluster
  value = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

############
