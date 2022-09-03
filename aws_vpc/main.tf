
locals {
    id_tag = map(var.vpc_tag_key, var.vpc_tag_value)
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  tags = merge(local.id_tag,
            map("Name", "${var.customer_prefix}-${var.environment}-${var.vpc_name}-vpc"),
            map("Environment", var.environment))
}

