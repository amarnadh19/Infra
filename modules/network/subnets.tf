# resource "aws_subnet" "public" {
# 	count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

# 	vpc_id                        = local.vpc_id
# 	cidr_block                    = element(concat(var.public_subnets, [""]), count.index)
# 	availability_zone             = length(element(var.azs, count.index)) > 0 ? element(var.azs, count.index) : null
# 	#availability_zone_id          = length(element(var.azs, count.index)) == 0 ? element(var.azs, count.index) : null
# 	map_public_ip_on_launch       = var.map_public_ip_on_launch

# 	tags = merge (
# 	 	{
# 	   		Name = join("-", [var.tname,"system","eks","network",var.public_subnet_tags,element(var.azs,count.index)])
# 	 	},
# 	)
# }

# resource "aws_subnet" "private" {
# 	count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

# 	vpc_id 						= local.vpc_id
# 	cidr_block 					= var.private_subnets[count.index]
# 	availability_zone 			= length(element(var.azs, count.index)) > 0 ? element(var.azs, count.index) : null
# 	#availability_zone_id        = length(element(var.azs, count.index)) == 0 ? element(var.azs, count.index) : null
# 	tags = merge (
# 		{
# 			Name = join("-", [var.tname,"system","eks","network",var.private_subnet_tags,element(var.azs,count.index)])
# 		},
# 	)
# }

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
  tags                    =  merge (
	 	{
	   		Name = join("-", [var.tname,"system","eks","network",var.public_subnet_tags,element(var.azs,count.index)])
	 	},
	) 
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags              = merge (
		{
			Name = join("-", [var.tname,"system","eks","network",var.private_subnet_tags,element(var.azs,count.index)])
		},
	) 
}