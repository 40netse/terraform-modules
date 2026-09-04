
#
# All things dedicated management related. (subnets, route tables, associations)
#

#
# AZ1
#
module "subnet-management-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = var.enable_dedicated_management_eni ? 1 : 0
  subnet_name                = "${var.vpc_name}-management-az1-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.management_subnet_cidr_az1
  tags                       = var.tags
}
module "management-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_dedicated_management_eni ? 1 : 0
  rt_name = "${var.vpc_name}-management-rt-az1"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "management-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.enable_dedicated_management_eni ? 1 : 0
  subnet_ids                 = module.subnet-management-az1[0].id
  route_table_id             = module.management-route-table-az1[0].id
}


#
# AZ2
#
module "subnet-management-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = var.enable_dedicated_management_eni ? 1 : 0
  subnet_name                = "${var.vpc_name}-management-az2-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.management_subnet_cidr_az2
  tags                       = var.tags
}
module "management-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_dedicated_management_eni ? 1 : 0
  rt_name = "${var.vpc_name}-management-rt-az2"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "management-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.enable_dedicated_management_eni ? 1 : 0
  subnet_ids                 = module.subnet-management-az2[0].id
  route_table_id             = module.management-route-table-az2[0].id
}

#
# Routes for the route table. If enable_dedicated_management_eni is enabled:
#   - If enable_dedicated_management_public_ip is true, default route goes to the IGW
#     (management traffic stays on its own path, separate from data-plane NAT'd egress).
#   - If false, default route goes to the NAT Gateway instead -- otherwise there's no
#     egress path at all for that interface, and FortiGuard updates/license verification
#     silently fail. Falls back to the IGW if a NAT Gateway isn't actually available
#     (enable_nat_gateway/create_nat_gateway not both true), same as before this variable
#     existed, rather than leaving the interface with no default route at all.
# If enable_dedicated_management_eni is not enabled, these subnets and route tables will
# not be created.
#
locals {
  management_route_via_natgw = var.enable_dedicated_management_eni && !var.enable_dedicated_management_public_ip && var.enable_nat_gateway && var.create_nat_gateway
  management_route_via_igw   = var.enable_dedicated_management_eni && !local.management_route_via_natgw
}

resource "aws_route" "inspection-ns-management-default-route-igw-az1" {
  count                  = local.management_route_via_igw ? 1 : 0
  route_table_id         = module.management-route-table-az1[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-management-default-route-natgw-az1" {
  depends_on             = [aws_nat_gateway.vpc-az1]
  count                  = local.management_route_via_natgw ? 1 : 0
  route_table_id         = module.management-route-table-az1[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-az1[0].id
}
resource "aws_route" "inspection-ns-management-default-route-igw-az2" {
  count                  = local.management_route_via_igw ? 1 : 0
  route_table_id         = module.management-route-table-az2[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-management-default-route-natgw-az2" {
  depends_on             = [aws_nat_gateway.vpc-az2]
  count                  = local.management_route_via_natgw ? 1 : 0
  route_table_id         = module.management-route-table-az2[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-az2[0].id
}

#
# AZ3
#
module "subnet-management-az3" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = (var.enable_dedicated_management_eni && var.availability_zone_3 != "") ? 1 : 0
  subnet_name                = "${var.vpc_name}-management-az3-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_3
  subnet_cidr                = local.management_subnet_cidr_az3
  tags                       = var.tags
}
module "management-route-table-az3" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = (var.enable_dedicated_management_eni && var.availability_zone_3 != "") ? 1 : 0
  rt_name = "${var.vpc_name}-management-rt-az3"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "management-route-table-association-az3" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = (var.enable_dedicated_management_eni && var.availability_zone_3 != "") ? 1 : 0
  subnet_ids                 = module.subnet-management-az3[0].id
  route_table_id             = module.management-route-table-az3[0].id
}
resource "aws_route" "inspection-ns-management-default-route-igw-az3" {
  count                  = (local.management_route_via_igw && var.availability_zone_3 != "") ? 1 : 0
  route_table_id         = module.management-route-table-az3[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-management-default-route-natgw-az3" {
  depends_on             = [aws_nat_gateway.vpc-az3]
  count                  = (local.management_route_via_natgw && var.availability_zone_3 != "") ? 1 : 0
  route_table_id         = module.management-route-table-az3[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-az3[0].id
}