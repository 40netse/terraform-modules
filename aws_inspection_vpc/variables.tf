variable "aws_region" {
  description = "The AWS region to use"
}
variable "availability_zone_1" {
  description = "Availability Zone 1 for VPC"
}
variable "availability_zone_2" {
  description = "Availability Zone 2 for VPC"
}
variable "cp" {
  description = "Customer Prefix to apply to all resources"
}
variable "env" {
  description = "The Tag Environment to differentiate prod/test/dev"
}
variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "my_ip" {
    description = "CIDR for my IP to restrict security group"
}
variable "firewall_policy_mode" {
  description = "Firewall Policy Mode"
  type = string
}
variable "enable_dedicated_management_vpc" {
  description = "Boolean to allow creation of dedicated management interface in management VPC"
  type        = bool
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
  description = "Boolean to enable NAT Gateway to be created within the inspection vpc"
  type = bool
}
variable "named_tgw" {
  description = "Name of the TGW to attach to"
  type = string
}
variable "enable_tgw_attachment" {
  description = "Boolean to enable attachment to a named TGW"
  type = bool
}
variable "ns_module_prefix" {
  description = "Module Prefix for East/West Autoscale Group"
  type        = string
}
variable "fortios_version" {
  description = "FortiGate OS Version of all instances in the Autoscale Groups"
  type        = string
}
variable "fortigate_asg_password" {
  description = "Password for the Fortigate ASG"
}
variable "fgt_instance_type" {
  description = "Instance type for all of the Fortigates in the ASG's"
  type        = string
}
variable "ns_byol_asg_min_size" {
    description = "Minimum size for the BYOL ASG"
    type        = number
}
variable "ns_byol_asg_max_size" {
    description = "Maximum size for the BYOL ASG"
    type        = number
}
variable "ns_byol_asg_desired_size" {
    description = "Desired size for the BYOL ASG"
    type        = number
}
variable "ns_ondemand_asg_min_size" {
    description = "Minimum size for the On Demand ASG"
    type        = number
}
variable "ns_ondemand_asg_max_size" {
    description = "Maximum size for the OnDemand ASG"
    type        = number
}
variable "ns_ondemand_asg_desired_size" {
    description = "Desired size for the OnDemand ASG"
    type        = number
}
variable "ns_license_directory" {
  description = "License Directory for North/South Autoscale Group"
  type        = string
}
variable "base_config_file" {
  description = "Initial Config File for Autoscale Group"
  type        = string
}
variable "allow_cross_zone_load_balancing" {
  description = "Allow gateway load balancer to use healthy instances in a different zone"
  type        = bool
}