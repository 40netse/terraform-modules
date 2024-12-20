
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
}
module "management-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_dedicated_management_eni ? 1 : 0
  rt_name = "${var.vpc_name}-management-rt-az1"

  vpc_id  = module.vpc.vpc_id
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
}
module "management-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_dedicated_management_eni ? 1 : 0
  rt_name = "${var.vpc_name}-management-rt-az2"

  vpc_id  = module.vpc.vpc_id
}
module "management-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.enable_dedicated_management_eni ? 1 : 0
  subnet_ids                 = module.subnet-management-az2[0].id
  route_table_id             = module.management-route-table-az2[0].id
}

#
# Routes for the route table. If enable_dedicated_management_eni is enabled, make the default route go to the IGW.
# If not, these subnets and route tables will not be created.
#

resource "aws_route" "inspection-ns-management-default-route-az1" {
  count                  = var.enable_dedicated_management_eni ? 1 : 0
  route_table_id         = module.management-route-table-az1[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-management-default-route-az2" {
  count                  = var.enable_dedicated_management_eni ? 1 : 0
  route_table_id         = module.management-route-table-az2[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}