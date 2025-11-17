
#
# All things nat gw related. (subnets, route tables, associations, eips, nat gateways)
#

#
# AZ1
#
module "subnet-natgw-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = var.enable_nat_gateway ? 1 : 0
  subnet_name                = "${var.vpc_name}-natgw-az1-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.natgw_subnet_cidr_az1
}
module "natgw-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_nat_gateway ? 1 : 0
  rt_name = "${var.vpc_name}-natgw-rt-az1"

  vpc_id  = module.vpc.vpc_id
}
module "natgw-route-table-association-az1" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.enable_nat_gateway ? 1 : 0
  subnet_ids                 = module.subnet-natgw-az1[0].id
  route_table_id             = module.natgw-route-table-az1[0].id
}
resource "aws_eip" "nat-gateway-az1" {
  count = var.create_nat_gateway ? 1 : 0
}
resource "aws_nat_gateway" "vpc-az1" {
  count             = var.create_nat_gateway ? 1 : 0
  allocation_id     = aws_eip.nat-gateway-az1[0].id
  subnet_id         = module.subnet-natgw-az1[0].id
  tags = {
    Name = "${var.vpc_name}-nat-gw-az1"
  }
}


#
# AZ2
#
module "subnet-natgw-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count                      = var.enable_nat_gateway ? 1 : 0
  subnet_name                = "${var.vpc_name}-natgw-az2-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.natgw_subnet_cidr_az2
}
module "natgw-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.enable_nat_gateway ? 1 : 0
  rt_name = "${var.vpc_name}-natgw-rt-az2"

  vpc_id  = module.vpc.vpc_id
}
module "natgw-route-table-association-az2" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count                      = var.enable_nat_gateway ? 1 : 0
  subnet_ids                 = module.subnet-natgw-az2[0].id
  route_table_id             = module.natgw-route-table-az2[0].id
}
resource "aws_eip" "nat-gateway-az2" {
  count = var.create_nat_gateway ? 1 : 0
}
resource "aws_nat_gateway" "vpc-az2" {
  count             = var.create_nat_gateway ? 1 : 0
  allocation_id     = aws_eip.nat-gateway-az2[0].id
  subnet_id         = module.subnet-natgw-az2[0].id
  tags = {
    Name = "${var.vpc_name}-nat-gw-az2"
  }
}
#
# Routes for the route table. If nat gateway is enabled, make the default route go to the nat gateway.
# If not, make the default route go to the internet gateway.
#

resource "aws_route" "inspection-ns-natgw-default-route-az1" {
  depends_on             = [aws_nat_gateway.vpc-az1]
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.natgw-route-table-az1[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "inspection-ns-natgw-default-route-az2" {
  depends_on             = [aws_nat_gateway.vpc-az2]
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = module.natgw-route-table-az2[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}