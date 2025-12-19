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

 output "oidc_provider_arn" {
   value       = module.eks.oidc_provider_arn
 }

 output "oidc_provider_url" {

   value       = module.eks.oidc_provider_url
 }

 output "cluster_name" {

   value       = module.eks.cluster_name
 }

 output "cluster_endpoint" {
 
   value       = module.eks.cluster_endpoint
 }

# output "cluster_certificate_authority_data" {
#
#   value       = module.eks.cluster_endpoint.cluster_certificate_authority_data
# }
