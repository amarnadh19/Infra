module "vpc" {
  source = "../../../modules/network"
    vpcname				=	"testing"

	env					=	"dev"
	
	azs					=	["ap-south-1a","ap-south-1b"]

	cidrblock			= 	"10.0.0.0/16"

	public_subnets      =   ["10.0.1.0/24","10.0.2.0/24"]

	private_subnets     =   ["10.0.10.0/24","10.0.11.0/24"]

	create_vpc 			=   true

	map_public_ip_on_launch = true

}