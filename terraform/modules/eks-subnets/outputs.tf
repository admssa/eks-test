output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "private_subnet_blocks" {
  value = aws_subnet.private_subnets.*.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "nat_ips" {
  value = aws_eip.nat_ips.*.public_ip
}

output "private_route_tables" {
  value = aws_route_table.private_route_tables.*.id
}

output "public_route_tables" {
  value = aws_route_table.public_route_table.*.id
}
