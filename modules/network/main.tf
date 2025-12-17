
# Internet Gateway
resource "aws_internet_gateway" "mainigw" {
  vpc_id = aws_vpc.mainvpc.id
#   tags = merge (
# 		{
# 		Name   = "${var.tname}-${var.tier}-eks-igw"
# 	},
# 	)
}

# Private Route (Conditional: Only if NAT exists)
resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.privateRT.id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
  timeouts {
    create = "5m"
  }
}

# NAT Gateway (Conditional)
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  # tags = merge (
	# 	{
	# 		Name = join("-", [var.tname,"system","eks","network",var.eip_tags,element(var.azs,count.index)])
	# 	},
	# )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id # Placed in the first public subnet
  # tags = merge (
	# 	{
	# 	Name = join("-", [var.tname,"system","eks","network",var.nat_tags,element(var.azs,count.index)])
	# 	},
	# )
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mainigw.id
  }
  # tags = merge (
	# 	{
	# 	Name   = "${var.tname}-${var.tier}-eks-publicRT"
	# },
	# )
}


resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.mainvpc.id
  # tags = merge (
	# 	{
	# 	Name   = "${var.tname}-${var.tier}-eks-privateRT"
	# },
	# )
}

resource "aws_route_table_association" "publicRTA" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicRT.id
}



resource "aws_route_table_association" "privateRTA" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privateRT.id
}
# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
  # tags                    =  merge (
	#  	{
	#    		Name = join("-", [var.tname,"system","eks","network",var.public_subnet_tags,element(var.azs,count.index)])
	#  	},
	# ) 
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  # tags              = merge (
	# 	{
	# 		Name = join("-", [var.tname,"system","eks","network",var.private_subnet_tags,element(var.azs,count.index)])
	# 	},
	# ) 
}

resource "aws_vpc" "mainvpc" {
	cidr_block 						 = var.cidrblock
    instance_tenancy                 = var.instance_tenancy
    enable_dns_hostnames             = var.enable_dns_hostnames
    enable_dns_support               = var.enable_dns_support
	# tags = merge (
	# 	{
	# 	Name   = "${var.tname}-${var.tier}-eks-vpc"
	# 	},
	# )
}

# resource "aws_vpc" "this" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_hostnames = true
#   tags                 = { Name = var.vpc_name }
# }