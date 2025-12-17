variable "region" {
  default = "us-east-1"
  type = string
  description = "region where need to deploy EC2 instance"
}
variable "port" {}
variable "ingress_protocol" {}
variable "ingress_destination" {}
variable "egress_protocol" {}
variable "egress_destination" {}
variable "default_route_cidr" {}
variable "vpc_id" {}
