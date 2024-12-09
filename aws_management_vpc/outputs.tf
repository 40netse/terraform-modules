output "vpc_id" {
  value       = module.vpc-management.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "igw_id" {
  value       = module.vpc-igw-management.igw_id
  description = "The IGW Id of the newly created IGW."
}
output "management_tgw_attachment_id" {
  value       = module.vpc-transit-gateway-attachment-management[0].tgw_attachment_id
  description = "The transit gateway attachment id for the management VPC."
}
output "management_tgw_route_table_id" {
  value       = aws_ec2_transit_gateway_route_table.management[0].id
  description = "The transit gateway route table id for the management VPC."
}
output "jump_box_public_ip" {
  value       = module.inspection_instance_jump_box[0].public_eip
  description = "The public IP address of the jump box."
}
output "jump_box_private_ip" {
  value       = module.inspection_instance_jump_box[0].network_public_interface_ip
  description = "The private IP address of the jump box."
}
output "fortimanager_public_ip" {
  value       = module.fortimanager[0].public_eip
  description = "The public IP address of the FortiManager."
}
output "fortimanager_private_ip" {
  value       = module.fortimanager.network_public_interface_ip
  description = "The private IP address of the FortiManager."
}
output "fortianalyzer_public_ip" {
  value       = module.fortianalyzer[0].public_eip
  description = "The public IP address of the fortianalyzer."
}
output "fortianalyzer_private_ip" {
  value       = module.fortianalyzer[0].network_public_interface_ip
  description = "The private IP address of the fortianalyzer."
}