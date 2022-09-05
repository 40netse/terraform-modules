
variable "vpc_id" {
  description = "Provide the VPC ID for the instance"
}
variable "sg_name" {
  description = "Security Group Name for TAGS"
}
variable "ingress_from_port" {
  description = "Ingress from port for security group"
}
variable "ingress_to_port" {
  description = "Ingress to port for security group"
}
variable "ingress_protocol" {
  description = "Ingress protocol for security group"
}
variable "egress_from_port" {
  description = "Egress from port for security group"
}
variable "egress_to_port" {
  description = "Egress to port for security group"
}
variable "egress_protocol" {
  description = "Egress protocol for security group"
}
variable "ingress_cidr_for_access" {
  description = "CIDR to use for security group access"
}
variable "egress_cidr_for_access" {
  description = "CIDR to use for security group access"
}


