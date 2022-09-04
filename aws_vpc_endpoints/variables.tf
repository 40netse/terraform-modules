variable "aws_region" {
  description = "Region for the VPC Endpoint Name"
}
variable "vpc_endpoint_name" {
  description = "The VPC Endpoint Name"
}

variable "vpc_id" {
  description = "Provide the VPC ID for the instance"
}
variable "route_table_id" {
  description = "Route Table IDS for Gateway Endpoint"
}