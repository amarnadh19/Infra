locals {
  cluster_name = "my_cluster"
}

module "ecr_repo1" {
    source = "../../modules/ecr"
    repository_name = "demo_repo_app"
}
module "dev_vpc" {
    source = "./common"
    cluster_name = local.cluster_name
}

module "dev_cluster" {
    source = "./ekscluster"
    vpc_id = module.dev_vpc.vpc_id
    subnet_ids = module.dev_vpc.public_subnets ## adding public subnets for testing
    cluster_name = local.cluster_name
}
