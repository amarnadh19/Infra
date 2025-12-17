module "ecr_repo1" {
    source = "../../../modules/ecr"
    repository_name = "demo_repo_app"
}

module "eks_sg" {
    source = "../../../modules/securitygroup"
    egress_destination = "0.0.0.0/0"
  egress_protocol = "-1"
  ingress_destination = "0.0.0.0/0"
  ingress_protocol = "tcp"
  port = ["22", "80"]
  default_route_cidr = "0.0.0.0/0"
  vpc_id = ""
}