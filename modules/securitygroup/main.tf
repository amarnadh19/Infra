resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  name = "elasticsearch"

}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  count = length(var.port)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.default_route_cidr #"0.0.0.0/0"
  #from_port         = var.port #22
  from_port   = var.port[count.index]
  to_port     = var.port[count.index]
  ip_protocol       = var.ingress_protocol #"tcp"
  #to_port           = var.port #22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         =  var.default_route_cidr
  ip_protocol       = var.egress_protocol
}
