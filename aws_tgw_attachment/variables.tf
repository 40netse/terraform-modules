variable "tgw_attachment_name" {
  description = "TGW-Attachment Name to apply to the name TAG"
}
variable "transit_gateway_id" {
  description = "Transit Gateway ID used for this attachment"
}
variable "subnet1" {
  description = "Subnet IDs of subnet1 used to route traffic from the TGW into the VPC"
}
variable "subnet2" {
  description = "Subnet IDs of subnet2 used to route traffic from the TGW into the VPC"
}
variable "dns_support" {
  description = "Whether DNS support is enable"
  default = "enable"
}
variable "vpc_id" {
  description = "VPC ID of the VPC that is connecting to the TGW"
}
variable transit_gateway_default_route_table_association {
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table"
  default = "false"
}
variable transit_gateway_default_route_table_propogation {
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table"
  default = "false"
}