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