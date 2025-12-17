resource "aws_vpc" "mainvpc" {
	cidr_block 						 = var.cidrblock
    instance_tenancy                 = var.instance_tenancy
    enable_dns_hostnames             = var.enable_dns_hostnames
    enable_dns_support               = var.enable_dns_support
	tags = merge (
		{
		Name   = "${var.tname}-${var.tier}-eks-vpc"
		},
	)
}

# resource "aws_vpc" "this" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true
#   tags                 = { Name = var.vpc_name }
# }