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
  type        = string
}
variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "acl" {
  description = "The acl for linux instances"
}
variable "vpc_name" {
  description = "The VPC Name"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = ""
  type        = string
}
variable "vpc_cidr_sg" {
  description = "List of CIDRS for the security group"
  default     = []
  type        = list(string)
}
variable "fgfm_source_cidr_sg" {
  description = "List of CIDRs allowed to reach FortiManager's FGFM port (541) -- the CIDRs where the managed FortiGates actually live (e.g. the Inspection VPC, and any spoke VPCs with FortiGates registered to this FortiManager). Not the same as vpc_cidr_sg, which is for admin/GUI/SSH access. Defaults to vpc_cidr_sg for backward compatibility if not set."
  default     = []
  type        = list(string)
}
variable "log_source_cidr_sg" {
  description = "List of CIDRs allowed to send logs to FortiAnalyzer (OFTP TCP/514, syslog UDP/514) -- typically the Inspection VPC (FortiGate log sources) and the Management VPC itself (FortiManager forwards logs to FortiAnalyzer too). Defaults to vpc_cidr_sg for backward compatibility if not set."
  default     = []
  type        = list(string)
}
variable "jump_box_nat_source_cidr_sg" {
  description = "List of spoke VPC CIDRs (e.g. vpc_cidr_east, vpc_cidr_west) allowed to reach the jump box on 443 for NAT passthrough -- the jump box's userdata MASQUERADEs/forwards spoke instance traffic so cloud-init can reach apt repos before the FortiGate/GWLB path exists. This is a distinct traffic class from vpc_cidr_sg (admin access to the box itself) -- no fallback to vpc_cidr_sg, since admin CIDRs are not the spoke CIDRs. Leave empty (default) to skip creating the rule entirely, e.g. when enable_jump_box's NAT function isn't in use."
  default     = []
  type        = list(string)
}
variable "subnet_bits" {
  description = "Number of bits to use for each subnet"
  type        = number
}
variable "availability_zone_1" {
  description = "Availability Zone 1"
}
variable "availability_zone_2" {
  description = "Availability Zone 2"
}
variable "availability_zone_3" {
  description = "Availability Zone 3"
  default     = ""
}
variable "named_tgw" {
  description = "Name of the TGW to attach to"
  type        = string
}
variable "enable_tgw_attachment" {
  description = "Boolean to enable attachment to a named TGW"
  type        = bool
}
variable "enable_jump_box" {
  description = "Boolean to allow creation of Linux Jump Box in Inspection VPC"
  type        = bool
}
variable "enable_jump_box_public_ip" {
  description = "Boolean to allow creation of Linux Jump Box public IP in Inspection VPC"
  type        = bool
}
variable "linux_user_data" {
  description = "User data for Linux Jump Box"
  type        = string
  default     = ""
}
variable "enable_source_dest_check" {
  description = "Boolean to enable/disable source/dest check on Fortigate instances"
  type        = bool
  default     = false
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
  description = "FortiManager OS version for AMI search. Use 'X.Y' (e.g. '7.6') to match the latest patch release, or 'X.Y.Z' (e.g. '7.6.7') to pin a specific version."
}
variable "fortimanager_host_ip" {
  description = "Fortimanager IP Address"
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
  description = "FortiAnalyzer OS version for AMI search. Use 'X.Y' (e.g. '7.6') to match the latest patch release, or 'X.Y.Z' (e.g. '7.6.7') to pin a specific version."
}
variable "fortianalyzer_host_ip" {
  description = "Fortianalyzer IP Address"
}
variable "fortianalyzer_user_data" {
  description = "User data for Fortianalyzer"
  type        = string
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
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}