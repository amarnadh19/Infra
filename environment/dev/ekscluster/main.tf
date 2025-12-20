#module "eks_sg" {
#     source = "../../../modules/securitygroup"
#     egress_destination = "0.0.0.0/0"
#   egress_protocol = "-1"
#   ingress_destination = "0.0.0.0/0"
#   ingress_protocol = "tcp"
#   port = ["22", "80"]
#   default_route_cidr = "0.0.0.0/0"
#   vpc_id = var.vpc_id
# }

module "eks_sg" {
  source       = "../../../modules/securitygroup"
  vpc_id       = var.vpc_id
  cluster_name = var.cluster_name # This will be injected into the tag key above
  # Also pass the cluster SG ID for the "risk-free" rules discussed earlier
  cluster_sg_id = module.eks.cluster_security_group_id
  #cluster_sg_id = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id

}

module "eks" {
  source = "../../../modules/eks"
  cluster_name = "my_cluster"
  node_group_name = "node_group_managed"
  subnet_ids =var.subnet_ids
  nodegroup_instance_types = ["t3.small"]
  release_version = ""
  max_size = 3
  min_size = 1
  desired_size = 2
  endpoint_public_access = true
  endpoint_private_access = true
  additional_node_sg_ids   = [module.eks_sg.sg_id]
}

