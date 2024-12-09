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
output "subnet_management_private_az1_id" {
  value       = module.subnet-private-az1.id
  description = "The subnet Id of the private subnet in AZ1."
}
output "subnet_management_private_az2_id" {
  value       = module.subnet-private-az2.id
  description = "The subnet Id of the private subnet in AZ2."
}


