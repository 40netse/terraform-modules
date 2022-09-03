
variable "subnet_name" {
  description = "Subnet Name to apply to the name TAG"
}

variable "vpc_id" {
  description = "VPC ID for subnet"
}

variable "availability_zone" {
    description = "AZ for Subnet"
}

variable "subnet_cidr" {
    description = "CIDR for the subnet"
}

variable "public_route" {
  description = "Boolean to associate this subnet with Public Route Table"
  default     = 0
}

variable "public_route_table_id" {
  description = "Public Route Table Id"
  default     = null
}


