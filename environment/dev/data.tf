data "aws_eks_cluster" "cluster" {
  name = module.dev_cluster.cluster_id
  depends_on = [module.dev_cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.dev_cluster.cluster_id
  depends_on = [module.dev_cluster]
}