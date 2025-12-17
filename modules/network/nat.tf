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
  tags = merge (
		{
			Name = join("-", [var.tname,"system","eks","network",var.eip_tags,element(var.azs,count.index)])
		},
	)
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id # Placed in the first public subnet
  tags = merge (
		{
		Name = join("-", [var.tname,"system","eks","network",var.nat_tags,element(var.azs,count.index)])
		},
	)
}



