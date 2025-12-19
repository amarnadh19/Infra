output "vpc_id" {
  value = module.dev_vpc.vpc_id
}

output "cluster_id" {

  value = module.dev_cluster.cluster_id
}

output "cluster_name" {

  value = module.dev_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.dev_cluster.cluster_endpoint
}

output "node_group_arn" {
  value = module.dev_cluster.node_group_arn
}