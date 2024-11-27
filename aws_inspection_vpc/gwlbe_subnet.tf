
#
# All things gwlbe subnet related. (subnets, route tables, routes)
#

#
# AZ1
#
module "subnet-gwlbe-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-gwlbe-az1-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.gwlbe_subnet_cidr_az1
}
module "gwlbe-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-gwlbe-rt-az1"

  vpc_id  = module.vpc.vpc_id
}
module "gwlbe-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-gwlbe-az1.id
  route_table_id             = module.gwlbe-route-table-az1.id
}

#
# AZ2
#
module "subnet-gwlbe-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-gwlbe-az2-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.gwlbe_subnet_cidr_az2
}
module "gwlbe-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-gwlbe-rt-az2"

  vpc_id  = module.vpc.vpc_id
}
module "gwlbe-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-gwlbe-az2.id
  route_table_id             = module.gwlbe-route-table-az2.id
}
#
# This is a bit bruce force. Route all the rfc-1918 space to the TGW. More specific route will handle the local traffic.
#

resource "aws_route" "gwlbe-192-route-igw-az1" {
  route_table_id         = module.gwlbe-route-table-az1.id
  destination_cidr_block = local.rfc1918_192
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
resource "aws_route" "gwlbe-192-route-igw-az2" {
  route_table_id         = module.gwlbe-route-table-az2.id
  destination_cidr_block = local.rfc1918_192
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
resource "aws_route" "gwlbe-10-route-igw-az1" {
  route_table_id         = module.gwlbe-route-table-az1.id
  destination_cidr_block = local.rfc1918_10
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
resource "aws_route" "gwlbe-10-route-igw-az2" {
  route_table_id         = module.gwlbe-route-table-az2.id
  destination_cidr_block = local.rfc1918_10
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
resource "aws_route" "gwlbe-172-route-igw-az1" {
  route_table_id         = module.gwlbe-route-table-az1.id
  destination_cidr_block = local.rfc1918_172
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
resource "aws_route" "gwlbe-172-route-igw-az2" {
  route_table_id         = module.gwlbe-route-table-az2.id
  destination_cidr_block = local.rfc1918_172
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}
