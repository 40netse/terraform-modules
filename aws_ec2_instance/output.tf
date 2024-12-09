
output "vpc_id" {
  value = module.vpc-management.vpc_id
}
output "igw_id" {
  value = module.vpc-igw-management.igw_id
}
output "tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.management[0].id
}
output "instance_id" {
  value = aws_instance.ec2.id
}
output "network_public_interface_id" {
  value = aws_instance.ec2.primary_network_interface_id
}
output "network_public_interface_ip" {
  value = aws_instance.ec2.private_ip
}
output "network_private_interface_id" {
  value = aws_network_interface.private_eni.*.id
}
output "network_private_interface_ip" {
  value = aws_network_interface.private_eni.*.private_ip
}
output "public_eip" {
  value = var.use_preallocated_elastic_ip ? aws_eip_association.AEIP.*.public_ip : aws_eip.EIP.*.public_ip
}
