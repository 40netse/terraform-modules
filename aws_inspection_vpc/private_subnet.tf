
#
# All things private subnet related. (subnets, route tables, routes)
#

#
# AZ1
#
module "subnet-private-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-private-az1-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.private_subnet_cidr_az1
  tags                       = var.tags
}
module "private-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-private-rt-az1"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "private-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-private-az1.id
  route_table_id             = module.private-route-table-az1.id
}

#
# AZ2
#
module "subnet-private-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-private-az2-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.private_subnet_cidr_az2
  tags                       = var.tags
}
module "private-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-private-rt-az2"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "private-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-private-az2.id
  route_table_id             = module.private-route-table-az2.id
}

#
# AZ3
#
module "subnet-private-az3" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = var.availability_zone_3 != "" ? 1 : 0
  subnet_name                = "${var.vpc_name}-private-az3-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_3
  subnet_cidr                = local.private_subnet_cidr_az3
  tags                       = var.tags
}
module "private-route-table-az3" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.availability_zone_3 != "" ? 1 : 0
  rt_name = "${var.vpc_name}-private-rt-az3"

  vpc_id  = module.vpc.vpc_id
  tags    = var.tags
}
module "private-route-table-association-az3" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.availability_zone_3 != "" ? 1 : 0
  subnet_ids                 = module.subnet-private-az3[0].id
  route_table_id             = module.private-route-table-az3[0].id
}
#
# Routes for the route table.
#
