 output "node_group_id" {
   value = module.eks.node_group_id
 }

 output "node_group_arn" {
   value = module.eks.node_group_arn
 }

 output "node_group_status" {
   value       = module.eks.node_group_status
 }

 output "node_role_arn" {
   value       = module.eks.node_role_arn
 }

 output "node_group_resources" {
   value       = module.eks.node_group_resources
 }

 output "cluster_name" {

   value       = module.eks.cluster_name
 }

  output "cluster_id" {

   value       = module.eks.cluster_id
 }

 output "cluster_endpoint" {
 
   value       = module.eks.cluster_endpoint
 }


