
variable "name" {
  description = "IGW Name to apply to the name TAG"
}
variable "subnet_az1" {
  description = "Subnet in AZ1 for Gateway Load Balancer connection"
}
variable "subnet_az2" {
  description = "Subnet in AZ2 for Gateway Load Balancer connection"
}
variable "enable_cross_az_lb" {
  description = "Enable cross az load balancing on the Gateway Load Balancer"
  type = bool
}
variable "vpc_id" {
    description = "VPC ID for target group"
}
variable "elb_listener_port" {
  description = "Listener port for health check"
  default = "80"
}
variable "instance1_id" {
  description = "Instance id of ec2 instance 1"
}
variable "instance2_id" {
  description = "Instance id of ec2 instance 1"
}