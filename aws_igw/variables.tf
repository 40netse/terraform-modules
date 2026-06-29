
variable "igw_name" {
  description = "IGW Name to apply to the name TAG"
}
variable "vpc_id" {
    description = "VPC ID for IGW"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
