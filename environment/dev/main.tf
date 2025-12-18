module "dev_ecr_repo" {
    source = "./ekscluster"
}

module "dev_vpc" {
    source = "./common"
}

module "dev_cluster" {
    source = "./ekscluster"
}