
variable "vpc_name" {
  description = "The VPC Name"
}
variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}
variable "subnet_bits" {
    description = "Number of bits to use for each subnet"
}
variable "availability_zone_1" {
    description = "Availability Zone 1"
}
variable "availability_zone_2" {
    description = "Availability Zone 2"
}
variable "enable_nat_gateway" {
  description = "Boolean to enable NAT Gateway to be created within the inspection vpc"
  type = bool
}
variable "named_tgw" {
    description = "Name of the TGW to attach to"
    type = string
}