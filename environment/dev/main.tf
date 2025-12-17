module "dev_ecr_repo" {
    source = "./ekscluster"
}

module "dev_vpc" {
    source = "./vpc"
}