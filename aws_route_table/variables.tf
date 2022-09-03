
variable "vpc_id" {
  description = "Route Table VPC ID"
}

variable "eni_route" {
  description = "Boolean to Create an ENI Route"
  default     = 0
}

variable "gateway_route" {
  description = "Boolean to Create an Gateway Route"
  default     = 0
}

variable "tgw_route" {
  description = "Boolean to Create a Transit Gateway Route"
  default     = 0
}

variable "eni_id" {
  description = "Network Interface to use for ENI Route"
  default     = null
}

variable "igw_id" {
  description = "Internet Gateway ID to use for the Gateway Route"
  default     = null
}

variable "tgw_id" {
  description = "Transit Gateway to use for the TGW Route"
  default     = null
}

variable "rt_name" {
  description = "Route Description for name Tag"
}