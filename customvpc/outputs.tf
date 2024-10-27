output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.vpc.*.id, [""])[0]
}
output "vpc_igw_id" {
  description = "The ID of the VPC"
  value       = concat(aws_internet_gateway.igw.*.id, [""])[0]
}

output "vpc_private_subnets_cidr_blocks" {
  description = "privatesubnets"
  value       = aws_subnet.private.*.cidr_block
}

# Subnets
output "vpc_private_subnets_id" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "vpc_public_subnets_id" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "vpc_database_subnets_id" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database.*.id
}

output "vpc_database_subnet_group_name" {
  description = "List of IDs of database subnets"
  value       = concat(aws_db_subnet_group.database.*.name, [""])[0]
}

output "vpc_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat.*.public_ip
}
 output "vpc_private_route_table_ids" {
   value = aws_route_table.private.*.id
 }
 output "vpc_public_route_table_ids" {
   value = aws_route_table.public.*.id
 }
# output "vpc_database_route_table_ids" {
#   value = aws_route_table.database.*.associations.route_table_id
# }