
variable "tgw_name" {
  description = "TGW Name to apply to the name TAG"
}
variable "bgp_asn" {
  description = "Private ASN for Amazon Side of a BGP Session"
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachments are automatically accepted"
  default     = "disable"
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default route table association"
  default     = "disable"
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  default     = "disable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  default     = "enable"
}
variable "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  default     = "enable"
}


