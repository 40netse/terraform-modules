locals {
    public_subnet_index = 0
}
locals {
    gwlbe_subnet_index = 1
}
locals {
    private_subnet_index = 2
}
locals {
    natgw_subnet_index = 3
}
locals {
    subnet_index_addon_for_natgw = var.enable_nat_gateway ? 1 : 0
}
locals {
  subnet_index_add_natgw = local.natgw_subnet_index + local.subnet_index_addon_for_natgw
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
  public_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.public_subnet_index)
}
locals {
  public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.public_subnet_index +
                                                                     local.subnet_index_add_natgw)
}
locals {
  gwlbe_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.gwlbe_subnet_index)
}
locals {
  gwlbe_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.gwlbe_subnet_index +
                                                                    local.subnet_index_add_natgw)
}
locals {
  private_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.private_subnet_index)
}
locals {
  private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.private_subnet_index +
                                                                      local.subnet_index_add_natgw)
}
locals {
  natgw_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.natgw_subnet_index)
}
locals {
  natgw_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.natgw_subnet_index +
                                                                    local.subnet_index_add_natgw)
}

data "aws_ec2_transit_gateway" "tgw" {
  filter {
    name   = "tag:Name"
    values = [var.named_tgw]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
module "vpc" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_vpc"
  vpc_name                   = "${var.vpc_name}-vpc"
  vpc_cidr                   = var.vpc_cidr
}
#
# Default route table that is created with the main VPC.
#
resource "aws_default_route_table" "route_inspection" {
  default_route_table_id = module.vpc.vpc_main_route_table_id
  tags = {
    Name = "default table for ${var.vpc_name} (unused)"
  }
}
module "vpc-igw" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"
  igw_name                   = "${var.vpc_name}-igw"
  vpc_id                     = module.vpc.vpc_id
}
#
# Security VPC Transit Gateway Attachment, Route Table and Routes
#
module "vpc-transit-gateway-attachment" {
  source                         = "git::https://github.com/40netse/terraform-modules.git//aws_tgw_attachment"
  count                          = var.enable_tgw_attachment  ? 1 : 0
  tgw_attachment_name            = "${var.vpc_name}-tgw-attachment"

  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw.id
  subnet_ids                                      = [ module.subnet-private-az1.id, module.subnet-private-az2.id ]
  transit_gateway_default_route_table_propogation = "true"
  appliance_mode_support                          = "enable"
  vpc_id                                          = module.vpc.vpc_id
}

resource "aws_ec2_transit_gateway_route_table" "inspection" {
  count                           = var.enable_tgw_attachment ? 1 : 0
  transit_gateway_id              = data.aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.vpc_name}-VPC TGW Route Table"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "inspection" {
  count                          = var.enable_tgw_attachment ? 1 : 0
  transit_gateway_attachment_id  = module.vpc-transit-gateway-attachment[0].tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection[0].id
}