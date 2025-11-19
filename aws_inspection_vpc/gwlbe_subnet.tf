
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
  count   = var.create_gwlb_route_associations ? 1 : 0
  rt_name = "${var.vpc_name}-gwlbe-rt-az1"

  vpc_id  = module.vpc.vpc_id
}
module "gwlbe-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count   = var.create_gwlb_route_associations ? 1 : 0
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
  count   = var.create_gwlb_route_associations ? 1 : 0
  rt_name = "${var.vpc_name}-gwlbe-rt-az2"

  vpc_id  = module.vpc.vpc_id
}
module "gwlbe-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.create_gwlb_route_associations ? 1 : 0
  subnet_ids                 = module.subnet-gwlbe-az2.id
  route_table_id             = module.gwlbe-route-table-az2.id
}
