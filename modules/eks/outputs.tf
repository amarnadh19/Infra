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

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks.url
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

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}