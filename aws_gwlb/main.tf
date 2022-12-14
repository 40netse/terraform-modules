
resource "aws_lb" "gwlb" {
  name                             = "${var.name}-gwlb"
  load_balancer_type               = "gateway"
  subnets                          = [ var.subnet_az1, var.subnet_az2 ]
  enable_cross_zone_load_balancing = var.enable_cross_az_lb
}

data "aws_caller_identity" "current" {}

resource "aws_vpc_endpoint_service" "endpoint_service" {
  acceptance_required        = false
  allowed_principals         = []
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  tags = {
      Name = "${var.name}-vpce-service"
  }
}

resource "aws_lb_target_group" "gwlb_target_group" {
  name = "${var.name}-tgrp"
  protocol = "GENEVE"
  port =  "6081"
  vpc_id = var.vpc_id
  target_type = "ip"
  health_check {
    protocol = "TCP"
    port = var.elb_listener_port
	interval = "10"
	healthy_threshold = "2"
	unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.id
  default_action {
    target_group_arn = aws_lb_target_group.gwlb_target_group.id
    type = "forward"
  }
}

data "aws_network_interfaces" "gwlb_eni_az1" {
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.gwlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [var.subnet_az1]
  }
}

data "aws_network_interfaces" "gwlb_eni_az2" {
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.gwlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [var.subnet_az2]
  }
}


locals {
  gwlb_eni_id_az1 = flatten(data.aws_network_interfaces.gwlb_eni_az1.*.ids)
  gwlb_eni_id_az2 = flatten(data.aws_network_interfaces.gwlb_eni_az2.*.ids)
}

data "aws_network_interface" "gwlb_ip1" {
  id = element(local.gwlb_eni_id_az1, 0)
}

data "aws_network_interface" "gwlb_ip2" {
  id = element(local.gwlb_eni_id_az2, 0)
}

resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  target_id = var.instance1_ip
}

resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  target_id = var.instance2_ip
}
resource "aws_vpc_endpoint" "gwlb_endpoint_az1" {
  service_name      = aws_vpc_endpoint_service.endpoint_service.service_name
  subnet_ids        = [var.subnet_az1]
  vpc_endpoint_type = aws_vpc_endpoint_service.endpoint_service.service_type
  vpc_id            = var.vpc_id
  tags = {
    Name = "${var.name}-gwlbe-az1"
  }
}

resource "aws_vpc_endpoint" "gwlb_endpoint_az2" {
  service_name      = aws_vpc_endpoint_service.endpoint_service.service_name
  subnet_ids        = [var.subnet_az2]
  vpc_endpoint_type = aws_vpc_endpoint_service.endpoint_service.service_type
  vpc_id            = var.vpc_id
  tags = {
    Name = "${var.name}-gwlbe-az2"
  }
}