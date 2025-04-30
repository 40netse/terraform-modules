variable "aws_region" {
  description = "The AWS region to use"
}
variable "cp" {
  description = "Customer Prefix to apply to all resources"
}
variable "env" {
  description = "The Tag Environment to differentiate prod/test/dev"
}
variable "random_string" {
  description = "The random string to append to any run specific resources"
  type = string
}
variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "acl" {
  description = "The acl for linux instances"
}
variable "my_ip" {
    description = "CIDR for my IP to restrict security group"
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
variable "availability_zone_1" {
  description = "Availability Zone 1"
}
variable "availability_zone_2" {
  description = "Availability Zone 2"
}
variable "named_tgw" {
  description = "Name of the TGW to attach to"
  type = string
}
variable "enable_tgw_attachment" {
  description = "Boolean to enable attachment to a named TGW"
  type = bool
}
variable "enable_jump_box" {
  description = "Boolean to allow creation of Linux Jump Box in Inspection VPC"
  type        = bool
}
variable "enable_jump_box_public_ip" {
  description = "Boolean to allow creation of Linux Jump Box public IP in Inspection VPC"
  type        = bool
}
variable "enable_fortimanager" {
  description = "Boolean to allow creation of FortiManager in Inspection VPC"
  type        = bool
}
variable "fortimanager_license_file" {
  description = "Full path for FortiManager License"
  type        = string
  default     = ""
}
variable "enable_fortimanager_public_ip" {
  description = "Boolean to allow creation of FortiManager public IP in Inspection VPC"
  type        = bool
}
variable "fortimanager_instance_type" {
  description = "Instance type for fortimanager"
}
variable "fortimanager_os_version" {
  description = "Fortimanager OS Version for the AMI Search String"
}
variable "fortimanager_host_ip" {
  description = "Fortimanager IP Address"
}
variable "fortimanager_sg_id" {
  description = "Security Group ID for Fortimanager"
  type        = string
}
variable "fortimanager_user_data" {
  description = "User data for Fortimanager"
  type        = string
}
variable "enable_fortianalyzer" {
  description = "Boolean to allow creation of FortiAnalyzer in Inspection VPC"
  type        = bool
}
variable "fortianalyzer_license_file" {
  description = "Full path for FortiAnalyzer License"
  type        = string
  default     = ""
}
variable "fortianalyzer_instance_type" {
  description = "Instance type for fortianalyzer"
}
variable "fortianalyzer_os_version" {
  description = "Fortianalyzer OS Version for the AMI Search String"
}
variable "fortianalyzer_host_ip" {
  description = "Fortianalyzer IP Address"
}
variable "enable_fortianalyzer_public_ip" {
  description = "Boolean to allow creation of FortiAnalyzer public IP in Inspection VPC"
  type        = bool
}
variable "linux_instance_type" {
  description = "Linux Endpoint Instance Type"
}
variable "linux_host_ip" {
  description = "Fortigate Host IP for all subnets"
}