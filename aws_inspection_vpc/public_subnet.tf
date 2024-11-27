
#
# All things public subnet related. (subnets, route tables, routes)
#

#
# AZ1
#
module "subnet-public-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-public-az1-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.public_subnet_cidr_az1
}
module "public-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-public-rt-az1"

  vpc_id  = module.vpc.vpc_id
}
module "public-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-public-az1.id
  route_table_id             = module.public-route-table-az1.id
}

#
# AZ2
#
module "subnet-public-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-public-az2-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.public_subnet_cidr_az2
}
module "public-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.vpc_name}-public-rt-az2"

  vpc_id  = module.vpc.vpc_id
}
module "public-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  subnet_ids                 = module.subnet-public-az2.id
  route_table_id             = module.public-route-table-az2.id
}

#
# Routes for the route table. If nat gateway is enabled, make the default route go to the nat gateway.
# If not, make the default route go to the internet gateway.
#
resource "aws_route" "inspection-ns-public-default-route-ngw-az1" {
  depends_on             = [aws_nat_gateway.vpc-az1]
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.public-route-table-az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-az1[0].id
}
resource "aws_route" "inspection-ns-public-default-route-ngw-az2" {
  depends_on             = [aws_nat_gateway.vpc-az2]
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.public-route-table-az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc-az2[0].id
}
resource "aws_route" "inspection-ns-public-default-route-igw-az1" {
  depends_on             = [module.vpc-igw]
  count                  = !var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.public-route-table-az1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-public-default-route-igw-az2" {
  depends_on             = [module.vpc-igw]
  count                  = !var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.public-route-table-az2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}