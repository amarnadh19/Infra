variable "region" {
  default = "us-east-1"
  type = string
  description = "region where need to deploy EC2 instance"
}
#variable "port" {}
#variable "ingress_protocol" {}
#variable "ingress_destination" {}
#variable "egress_protocol" {}
#variable "egress_destination" {}
variable "vpc_id" {}

variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
  default = ""
}

variable "cluster_sg_id" {
  type        = string
  description = "The name of the EKS cluster"
  default = ""
}

