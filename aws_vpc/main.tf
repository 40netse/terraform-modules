
locals {
    common_tags = “${map(“${var.opt_tag_name}”, “${var.opt_tag_value}”, “Environment”, “${var.environment}”)}”
}
resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  tags = "${merge(local.common_tags, map("Name", "${var.customer_prefix}-${var.environment}-${var.vpc_name}-vpc"))}"
}

