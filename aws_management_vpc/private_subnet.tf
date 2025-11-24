
#
# All things private subnet related. (subnets, route tables, routes)
# Private subnets are only created when jump box is enabled to allow
# east/west spoke traffic to NAT through the jump box.
#

#
# AZ1
#
module "subnet-management-private-az1" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count       = var.enable_jump_box ? 1 : 0
  subnet_name = "${var.vpc_name}-private-az1-subnet"

  vpc_id            = module.vpc-management.vpc_id
  availability_zone = var.availability_zone_1
  subnet_cidr       = local.management_private_subnet_cidr_az1
}
module "private-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_jump_box ? 1 : 0
  rt_name = "${var.vpc_name}-private-rt-az1"

  vpc_id = module.vpc-management.vpc_id
}
module "private-route-table-association-az1" {
  source         = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count          = var.enable_jump_box ? 1 : 0
  subnet_ids     = module.subnet-management-private-az1[0].id
  route_table_id = module.private-route-table-az1[0].id
}

#
# AZ2
#
module "subnet-management-private-az2" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count       = var.enable_jump_box ? 1 : 0
  subnet_name = "${var.vpc_name}-private-az2-subnet"

  vpc_id            = module.vpc-management.vpc_id
  availability_zone = var.availability_zone_2
  subnet_cidr       = local.management_private_subnet_cidr_az2
}
module "private-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_jump_box ? 1 : 0
  rt_name = "${var.vpc_name}-private-rt-az2"

  vpc_id = module.vpc-management.vpc_id
}
module "private-route-table-association-az2" {
  source         = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count          = var.enable_jump_box ? 1 : 0
  subnet_ids     = module.subnet-management-private-az2[0].id
  route_table_id = module.private-route-table-az2[0].id
}

#
# Routes for the private subnet route tables.
# Default route points to the jump box ENI to allow NAT through jump box.
#
resource "aws_route" "private-route-az1-default" {
  count                  = var.enable_jump_box ? 1 : 0
  route_table_id         = module.private-route-table-az1[0].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.inspection_instance_jump_box[0].network_public_interface_id
}

resource "aws_route" "private-route-az2-default" {
  count                  = var.enable_jump_box ? 1 : 0
  route_table_id         = module.private-route-table-az2[0].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.inspection_instance_jump_box[0].network_public_interface_id
}
