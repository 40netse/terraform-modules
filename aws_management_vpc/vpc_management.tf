locals {
    public_subnet_index = 0
}
locals {
  rfc1918_192 = "192.168.0.0/16"
}
locals {
  rfc1918_10 = "10.0.0.0/8"
}
locals {
  rfc1918_172 = "172.16.0.0/12"
}
locals {
  management_public_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.public_subnet_index)
}
locals {
  management_public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.public_subnet_index + 1)
}

locals {
  management_subnet_ids = [module.subnet-management-public-az1.id, module.subnet-management-public-az2.id]
}

data "aws_ec2_transit_gateway" "tgw" {
  count = var.enable_tgw_attachment ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.named_tgw]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

#
# Spoke VPC
#
module "vpc-management" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_vpc"
  vpc_name                   = "${var.vpc_name}-vpc"
  vpc_cidr                   = var.vpc_cidr
}
module "vpc-igw-management" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"
  igw_name                   = "${var.vpc_name}-igw"
  vpc_id                     = module.vpc-management.vpc_id
}
module "vpc-transit-gateway-attachment-management" {
  source                         = "git::https://github.com/40netse/terraform-modules.git//aws_tgw_attachment"
  count                          = var.enable_tgw_attachment ? 1 : 0
  tgw_attachment_name            = "${var.vpc_name}-tgw-attachment"

  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw[0].id
  subnet_ids                                      = [module.subnet-management-public-az1.id, module.subnet-management-public-az2.id]
  transit_gateway_default_route_table_propogation = "false"
  appliance_mode_support                          = "enable"
  vpc_id                                          = module.vpc-management.vpc_id
}

resource "aws_ec2_transit_gateway_route_table" "management" {
  count                          = var.enable_tgw_attachment ? 1 : 0
  transit_gateway_id             = data.aws_ec2_transit_gateway.tgw[0].id
  tags = {
    Name = "${var.cp}-${var.env}-management-tgw-rtb"
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "east" {
  count                          = var.enable_tgw_attachment ? 1 : 0
  transit_gateway_attachment_id  = module.vpc-transit-gateway-attachment-management[0].tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.management[0].id
}
#
# AZ 1
#
module "subnet-management-public-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-public-az1-subnet"

  vpc_id                     = module.vpc-management.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = local.management_public_subnet_cidr_az1
}

#
# AZ 2
#
module "subnet-management-public-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.vpc_name}-public-az2-subnet"

  vpc_id                     = module.vpc-management.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = local.management_public_subnet_cidr_az2
}

#
# Default route table that is created with the main VPC.
#
resource "aws_default_route_table" "route_management" {
  default_route_table_id = module.vpc-management.vpc_main_route_table_id
  tags = {
    Name = "${var.cp}-${var.env}-management-main-route-table"
  }
}
resource "aws_security_group" "management-vpc-sg" {
  description = "Security Group for ENI in the management VPC"
  vpc_id = module.vpc-management.vpc_id
  ingress {
    description = "Allow egress ALL"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = "Allow egress ALL"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
