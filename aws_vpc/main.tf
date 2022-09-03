
locals {
    id_tag = tomap({(var.vpc_tag_key) = (var.vpc_tag_value)})
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  tags = merge(tomap({Name = (var.customer_prefix)-(var.environment)-(var.vpc_name)-vpc}),
            tomap({Environment = (var.environment)}),
            local.id_tag)
}

