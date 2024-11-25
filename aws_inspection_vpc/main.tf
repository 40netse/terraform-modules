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
  subnet_index_add_natgw = var.enable_nat_gateway ? 1 : 0
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
  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
}

module "vpc-igw" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"
  igw_name                   = var.vpc_name
  vpc_id                     = module.vpc.vpc_id
}
