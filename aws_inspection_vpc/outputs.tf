output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "igw_id" {
  value       = module.vpc-igw.igw_id
  description = "The IGW Id of the newly created IGW."
}
output "subnet_public_az1_id" {
  value       = module.subnet-public-az1.id
  description = "The subnet Id of the public subnet in AZ1."
}
output "subnet_public_az2_id" {
  value       = module.subnet-public-az2.id
  description = "The subnet Id of the public subnet in AZ2."
}
output "subnet_gwlbe_az1_id" {
  value       = module.subnet-gwlbe-az1.id
  description = "The subnet Id of the gwlbe subnet in AZ1."
}
output "subnet_gwlbe_az2_id" {
  value       = module.subnet-gwlbe-az2.id
  description = "The subnet Id of the gwlbe subnet in AZ2."
}
output "subnet_private_az1_id" {
  value       = module.subnet-private-az1.id
  description = "The subnet Id of the private subnet in AZ1."
}
output "subnet_private_az2_id" {
  value       = module.subnet-private-az2.id
  description = "The subnet Id of the private subnet in AZ2."
}
output "route_table_public_az1_id" {
  value       = module.public-route-table-az1.id
  description = "The route table Id of the public subnet in AZ1."
}
output "route_table_public_az2_id" {
  value       = module.public-route-table-az2.id
  description = "The route table Id of the public subnet in AZ2."
}
output "route_table_gwlbe_az1_id" {
  value       = module.gwlbe-route-table-az1.id
  description = "The route table Id of the gwlbe subnet in AZ1."
}
output "route_table_gwlbe_az2_id" {
  value       = module.gwlbe-route-table-az2.id
  description = "The route table Id of the gwlbe subnet in AZ2."
}
output "route_table_private_az1_id" {
  value       = module.private-route-table-az1.id
  description = "The route table Id of the private subnet in AZ1."
}
output "route_table_private_az2_id" {
  value       = module.private-route-table-az2.id
  description = "The route table Id of the private subnet in AZ2."
}
output "route_table_natgw_az1_id" {
  value       = var.enable_nat_gateway ? module.natgw-route-table-az1[0].id : null
  description = "The route table Id of the natgw subnet in AZ1."
}
output "route_table_natgw_az2_id" {
  value       = var.enable_nat_gateway ? module.natgw-route-table-az2[0].id : null
  description = "The route table Id of the natgw subnet in AZ2."
}
output "aws_nat_gateway_vpc_az1_id" {
  value       = var.enable_nat_gateway ? aws_nat_gateway.vpc-az1[0].id : null
  description = "The NAT Gateway Id of the NAT Gateway in AZ1."
}
output "aws_nat_gateway_vpc_az2_id" {
  value       = var.enable_nat_gateway ? aws_nat_gateway.vpc-az2[0].id : null 
  description = "The NAT Gateway Id of the NAT Gateway in AZ2."
}



