output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "vpc_main_route_table_id" {
  value       = module.vpc.main_route_table_id
  description = "Main Route Table Associated with VPC"
}
