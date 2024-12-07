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