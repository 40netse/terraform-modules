locals {
  public_subnet_index = 0
}
locals {
  private_subnet_index = 3
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
  management_public_subnet_cidr_az3 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.public_subnet_index + 2)
}
locals {
  management_private_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.private_subnet_index)
}
locals {
  management_private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.private_subnet_index + 1)
}
locals {
  management_private_subnet_cidr_az3 = cidrsubnet(var.vpc_cidr, var.subnet_bits, local.private_subnet_index + 2)
}

locals {
  management_subnet_ids = var.availability_zone_3 != "" ? [module.subnet-management-public-az1.id, module.subnet-management-public-az2.id, module.subnet-management-public-az3[0].id] : [module.subnet-management-public-az1.id, module.subnet-management-public-az2.id]
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

locals {
  # Falls back to vpc_cidr_sg (not 0.0.0.0/0) if the caller doesn't set fgfm_source_cidr_sg,
  # so existing callers who haven't been updated yet don't silently end up wide open.
  fgfm_cidrs = length(var.fgfm_source_cidr_sg) > 0 ? var.fgfm_source_cidr_sg : var.vpc_cidr_sg
}

#
# Scoped to the actual ports this template's topology needs: admin/GUI/SSH from vpc_cidr_sg,
# FGFM from fgfm_cidrs (the FortiGates' own CIDRs, not the whole internet). Dropped 8900
# (AV/GeoIP query), 8902-8903 (AV query/GeoIP), 8891 (FortiClient AV cascade), and 5199 (HA
# clustering) entirely -- none of these are used by this topology (no FortiClient EMS
# integration, no FortiManager HA pair), so there's nothing to scope, just remove.
#
resource "aws_security_group" "fortimanager_sg" {
  count       = var.enable_fortimanager ? 1 : 0
  name        = "allow_public_subnets_fmg"
  vpc_id      = module.vpc-management.vpc_id
  description = "Fortimanager Allow required ports from public Subnets"
  ingress {
    description = "Allow HTTPS admin/GUI access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow SSH admin/CLI access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow ICMP from admin CIDRs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow FGFM protocol from managed FortiGates only"
    from_port   = 541
    to_port     = 541
    protocol    = "tcp"
    cidr_blocks = local.fgfm_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "allow_fortimanager_required_ports" }, var.tags)
}

#
# Spoke VPC
#
module "vpc-management" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_vpc"
  vpc_name = "${var.vpc_name}-vpc"
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}
module "vpc-igw-management" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_igw"
  igw_name = "${var.vpc_name}-igw"
  vpc_id   = module.vpc-management.vpc_id
  tags     = var.tags
}
module "vpc-transit-gateway-attachment-management" {
  source              = "git::https://github.com/40netse/terraform-modules.git//aws_tgw_attachment"
  count               = var.enable_tgw_attachment ? 1 : 0
  tgw_attachment_name = "${var.vpc_name}-tgw-attachment"

  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw[0].id
  subnet_ids                                      = var.availability_zone_3 != "" ? [module.subnet-management-private-az1[0].id, module.subnet-management-private-az2[0].id, module.subnet-management-private-az3[0].id] : [module.subnet-management-private-az1[0].id, module.subnet-management-private-az2[0].id]
  transit_gateway_default_route_table_propogation = "false"
  appliance_mode_support                          = "enable"
  vpc_id                                          = module.vpc-management.vpc_id
  tags                                            = var.tags
}

resource "aws_ec2_transit_gateway_route_table" "management" {
  count              = var.enable_tgw_attachment ? 1 : 0
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw[0].id
  tags               = merge({ Name = "${var.cp}-${var.env}-management-tgw-rtb" }, var.tags)
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
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.vpc_name}-public-az1-subnet"

  vpc_id            = module.vpc-management.vpc_id
  availability_zone = var.availability_zone_1
  subnet_cidr       = local.management_public_subnet_cidr_az1
  tags              = var.tags
}

#
# AZ 2
#
module "subnet-management-public-az2" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.vpc_name}-public-az2-subnet"

  vpc_id            = module.vpc-management.vpc_id
  availability_zone = var.availability_zone_2
  subnet_cidr       = local.management_public_subnet_cidr_az2
  tags              = var.tags
}

#
# AZ 3
#
module "subnet-management-public-az3" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count       = var.availability_zone_3 != "" ? 1 : 0
  subnet_name = "${var.vpc_name}-public-az3-subnet"

  vpc_id            = module.vpc-management.vpc_id
  availability_zone = var.availability_zone_3
  subnet_cidr       = local.management_public_subnet_cidr_az3
  tags              = var.tags
}

#
# Default route table that is created with the main VPC.
#
resource "aws_default_route_table" "route_management" {
  default_route_table_id = module.vpc-management.vpc_main_route_table_id
  tags                   = merge({ Name = "${var.cp}-${var.env}-management-main-route-table" }, var.tags)
}
resource "aws_security_group" "management-vpc-sg" {
  description = "Security Group for ENI in the management VPC"
  vpc_id      = module.vpc-management.vpc_id
  ingress {
    description = "Allow egress ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow egress ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
