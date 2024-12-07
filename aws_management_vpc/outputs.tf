output "vpc_id" {
  value       = module.vpc-management.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "igw_id" {
  value       = module.vpc-igw-management.igw_id
  description = "The IGW Id of the newly created IGW."
}
output "management_tgw_attachment_id" {
  value       = module.vpc-transit-gateway-attachment-management.id
  description = "The transit gateway attachment id for the management VPC."
}