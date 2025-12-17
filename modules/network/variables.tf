variable "vpcname" {
	description = "Provide a vpc name"
	default = ""
}

variable "private_subnets" {
	type = list(string)
	default = []
	description = "List of private subnets"
}

variable "public_subnet_tags" {
	default = "public-subnet"
}

variable "private_subnet_tags" {
	default = "private-subnet"
}

variable "env" {
	description = "Environment (dev/qa/prod)"
	type = string
   
}

variable "cidrblock" {
	type    = string
    default = ""

}

variable "create_vpc" {
	type = bool
	default = true
}

variable "public_subnets" {
	type = list(string)
	default = []
}

variable "map_public_ip_on_launch" {
	type = bool
	default = true
}

variable "azs" {
	type = list(string)
	default = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  type        = bool
  default     = false
}
variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}
variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}
variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}


variable "eip_tags" {
	default = "eip"
}

variable "nat_tags" {
	default = "Natgateway"
}

variable "cidr_ingress_block"{
  type = list
  default = ["0.0.0.0/0"]
}


variable "instance_tenancy" {
	type = string
	default = "default"
}

variable "enable_dns_support" {
	type     =  string
	default  =  true
}

variable "enable_dns_hostnames" {
	type     =  string
	default  =  true
}

variable "destination_cidr_block" {
  default       = "0.0.0.0/0"
}

variable "orgShortName" {
	description = 	"Organization name"
	type		=	string
	default		=	"pf"
}
