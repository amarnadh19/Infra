output "vpc_id" {
    value       =    module.network.vpc_id
}

output "public_subnets" {
    value       =    module.network.public_subnets
}

output "private_subnets" {
    value       =     module.network.private_subnets
}

output "natgateways" {
    value = module.network.natgateways
}

output "cidrblock" {
    value = module.network.cidr_block
}