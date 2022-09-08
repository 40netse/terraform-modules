output "gwlb_id" {
  value       = "aws_lb.gwlb.id"
  description = "Gateway Load Balancer Id"
}

output "gwlb_arn_suffix" {
  value = aws_lb.gwlb.*.arn_suffix
}

output "gwlb_ip1" {
  value = flatten(data.aws_network_interface.gwlb_ip1.*.private_ips)
}

output "gwlb_ip2" {
  value = flatten(data.aws_network_interface.gwlb_ip2.*.private_ips)
}

output "gwlb_endpoint_service_name" {
  value = aws_vpc_endpoint_service.endpoint_service.service_name
}

output "gwlb_endpoint_service_type" {
  value = aws_vpc_endpoint_service.endpoint_service.service_type
}

output "gwlb_endpoint_az1" {
  description = "Gateway Load Balancer Endpoint in AZ1"
  value = aws_vpc_endpoint.gwlb_endpoint_az1.id
}

output "gwlb_endpoint_az2" {
  description = "Gateway Load Balancer Endpoint in AZ2"
  value = aws_vpc_endpoint.gwlb_endpoint_az2.id
}

output "gwlb_eni_id_az1" {
  value = local.gwlb_eni_id_az1
}
output "gwlb_eni_id_az2" {
  value = local.gwlb_eni_id_az2
}