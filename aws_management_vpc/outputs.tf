output "vpc_id" {
  value       = module.vpc-management.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "igw_id" {
  value       = module.vpc-igw-management.igw_id
  description = "The IGW Id of the newly created IGW."
}
output "subnet_management_public_az1_id" {
  value       = module.subnet-management-public-az1.id
  description = "The subnet Id of the public subnet in AZ1."
}
output "subnet_management_public_az2_id" {
  value       = module.subnet-management-public-az2.id
  description = "The subnet Id of the public subnet in AZ2."
}
output "subnet_management_private_az1_id" {
  value       = var.enable_jump_box ? module.subnet-management-private-az1[0].id : null
  description = "The subnet Id of the private subnet in AZ1."
}
output "subnet_management_private_az2_id" {
  value       = var.enable_jump_box ? module.subnet-management-private-az2[0].id : null
  description = "The subnet Id of the private subnet in AZ2."
}
output "management_tgw_attachment_id" {
  value       = var.enable_tgw_attachment ? module.vpc-transit-gateway-attachment-management[0].tgw_attachment_id : null
  description = "The transit gateway attachment id for the management VPC."
}
output "management_tgw_route_table_id" {
  value       = var.enable_tgw_attachment ? aws_ec2_transit_gateway_route_table.management[0].id : null
  description = "The transit gateway route table id for the management VPC."
}
output "jump_box_public_ip" {
  value       = var.enable_jump_box_public_ip ? module.inspection_instance_jump_box[0].public_eip : null
  description = "The public IP address of the jump box."
}
output "jump_box_private_ip" {
  value       = var.enable_jump_box ? module.inspection_instance_jump_box[0].network_public_interface_ip : null
  description = "The private IP address of the jump box."
}
output "jump_box_instance_id" {
  value       = var.enable_jump_box ? module.inspection_instance_jump_box[0].instance_id : null
  description = "The instance ID of the jump box."
}
output "fortimanager_public_ip" {
  value       = var.enable_fortimanager_public_ip ? module.fortimanager[0].public_eip : null
  description = "The public IP address of the FortiManager."
}
output "fortimanager_private_ip" {
  value       = var.enable_fortimanager ? module.fortimanager[0].network_public_interface_ip : null
  description = "The private IP address of the FortiManager."
}
output "fortianalyzer_public_ip" {
  value       = var.enable_fortianalyzer_public_ip ? module.fortianalyzer[0].public_eip : null
  description = "The public IP address of the fortianalyzer."
}
output "fortianalyzer_private_ip" {
  value       = var.enable_fortianalyzer ? module.fortianalyzer[0].network_public_interface_ip : null
  description = "The private IP address of the fortianalyzer."
}
output "route_table_management_public" {
  value       = module.vpc-management.vpc_main_route_table_id
  description = "The route table Id of the public subnet in AZ1."
}


