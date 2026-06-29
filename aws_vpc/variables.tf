
variable "vpc_name" {
  description = "The VPC Name"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
