
# Internet Gateway
resource "aws_internet_gateway" "mainigw" {
  vpc_id = aws_vpc.mainvpc.id
#   tags = merge (
# 		{
# 		Name   = "${var.tname}-${var.tier}-eks-igw"
# 	},
# 	)
}