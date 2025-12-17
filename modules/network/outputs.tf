output "vpc_id" {
    value       =   aws_vpc.mainvpc.id
}
output "public_subnets" {
    value = aws_subnet.public.*.id
}

output "private_subnets" {
    value  = aws_subnet.private.*.id
}
output "natgateways" {
    value = aws_nat_gateway.nat_gateway.*.id
}

output "cidrblock" {
    value = aws_vpc.mainvpc.cidr_block
}