
variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}

variable "environment" {
  description = "The Tag Environment in the S3 tag"
}

variable "vpc_name" {
  description = "The VPC Name"
}

variable "aws_region" {
  description = "The AWS region to use"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}
variable "vpc_tag_vkey" {
    description = "Random Tag Key to place on VPC for data ID"
    default     = ""
}
variable "vpc_tag_value" {
    description = "Random Tag Value to place on VPC for data ID"
    default     = ""
}
