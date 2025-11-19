variable "availability_zone_1" {
  description = "Availability Zone 1 for VPC"
}
variable "availability_zone_2" {
  description = "Availability Zone 2 for VPC"
}
variable "vpc_name" {
  description = "The VPC Name"
  type = string
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  type = string
}
variable "subnet_bits" {
  description = "Number of bits to use for each subnet"
  type = number
}
variable "enable_nat_gateway" {
  description = "Boolean to enable NAT Gateway Subnets to be created within the inspection vpc"
  type = bool
}
variable "create_nat_gateway" {
  description = "Boolean to enable the actual creation of the NAT Gateways to be created within the inspection vpc"
  type = bool
  default = true
}
variable "named_tgw" {
  description = "Name of the TGW to attach to"
  type = string
}
variable "enable_tgw_attachment" {
  description = "Boolean to enable attachment to a named TGW"
  type = bool
}
variable "enable_dedicated_management_eni" {
  description = "Boolean to allow creation of dedicated management subnets and ENI in the inspection VPC"
  type        = bool
}
variable "create_gwlb_route_associations" {
  description = "Boolean to conditionally create the gwlb route table associations"
  type        = bool
  default     = true
}