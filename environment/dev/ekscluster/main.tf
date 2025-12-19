module "eks_sg" {
     source = "../../../modules/securitygroup"
     egress_destination = "0.0.0.0/0"
   egress_protocol = "-1"
   ingress_destination = "0.0.0.0/0"
   ingress_protocol = "tcp"
   port = ["22", "80"]
   default_route_cidr = "0.0.0.0/0"
   vpc_id = var.vpc_id
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
}


#
#module "app_deployment" {
#  source       = "../../modules/app_deployment"
#  ecr_repo_url = module.ecr.repository_url
#  image_tag    = "v1.0.0"
#
#  # Wait for EKS to be fully active before deploying
#  depends_on = [module.eks]
#}
