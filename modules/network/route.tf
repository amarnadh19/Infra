resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mainigw.id
  }
  tags = merge (
		{
		Name   = "${var.tname}-${var.tier}-eks-publicRT"
	},
	)
}


resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.mainvpc.id
  tags = merge (
		{
		Name   = "${var.tname}-${var.tier}-eks-privateRT"
	},
	)
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
