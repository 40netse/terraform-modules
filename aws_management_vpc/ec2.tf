
locals {
  linux_inspection_az1_jump_ip_address = cidrhost(local.management_public_subnet_cidr_az1, var.linux_host_ip)
}

locals {
  fortimanager_ip_address = cidrhost(local.management_public_subnet_cidr_az1, var.fortimanager_host_ip)
}
locals {
  fortianalyzer_ip_address = cidrhost(local.management_public_subnet_cidr_az1, var.fortianalyzer_host_ip)
}

#
# Optional Linux Instances from here down
#
# Linux Instance that are added on to the East and West VPCs for testing EAST->West Traffic
#
# Endpoint AMI to use for Linux Instances. Just added this on the end, since traffic generating linux instances
# would not make it to a production template.
#
data "aws_ami" "ubuntu" {
  count       = var.enable_jump_box ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
#
# EC2 Endpoint Resources
#

#
# Two distinct traffic classes on this box: admin access to the box itself (vpc_cidr_sg), and
# NAT passthrough for spoke instance cloud-init (jump_box_nat_source_cidr_sg) -- the userdata
# MASQUERADEs/forwards spoke traffic so spoke instances can reach apt repos before the
# FortiGate/GWLB path exists. Dropped the UDP 514 (syslog) rule entirely -- no justification
# found for a jump box needing inbound syslog, looked like the same copy-paste-from-elsewhere
# pattern as the stray 8900 rule that was on the FortiAnalyzer SG.
#
resource "aws_security_group" "ec2-linux-jump-box-sg" {
  count       = var.enable_jump_box ? 1 : 0
  description = "Security Group for Linux Jump Box"
  vpc_id      = module.vpc-management.vpc_id
  ingress {
    description = "Allow SSH admin access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow HTTP admin access (apache2 status page)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow HTTPS admin access"
    from_port   = 443
    to_port     = 443
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
  dynamic "ingress" {
    for_each = length(var.jump_box_nat_source_cidr_sg) > 0 ? [1] : []
    content {
      description = "Allow HTTPS from spoke VPCs for NAT passthrough (cloud-init apt access)"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.jump_box_nat_source_cidr_sg
    }
  }
  egress {
    description = "Allow egress ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#
# IAM Profile for linux instance
#
module "linux_iam_profile" {
  source        = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance_iam_role"
  count         = var.enable_jump_box ? 1 : 0
  iam_role_name = "${var.vpc_name}-${var.random_string}-linux-instance_role"
}

#
# Wait for networking to stabilize before creating jump box
#
resource "time_sleep" "wait_for_networking" {
  count           = var.enable_jump_box ? 1 : 0
  depends_on      = [module.subnet-management-public-az1]
  create_duration = "180s" # 3 minutes
}

#
# East Linux Instance for Jump Box
#
module "inspection_instance_jump_box" {
  count                    = var.enable_jump_box ? 1 : 0
  source                   = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name    = "${var.vpc_name}-jump-box-instance"
  enable_public_ips        = var.enable_jump_box_public_ip
  availability_zone        = var.availability_zone_1
  public_subnet_id         = module.subnet-management-public-az1.id
  public_ip_address        = local.linux_inspection_az1_jump_ip_address
  aws_ami                  = data.aws_ami.ubuntu[0].id
  keypair                  = var.keypair
  instance_type            = var.linux_instance_type
  security_group_public_id = aws_security_group.ec2-linux-jump-box-sg[0].id
  acl                      = var.acl
  iam_instance_profile_id  = module.linux_iam_profile[0].id
  userdata_rendered        = var.linux_user_data
  public_src_dst_check     = var.enable_source_dest_check
  tags                     = var.tags

  depends_on = [time_sleep.wait_for_networking]
}

data "aws_ami" "fortimanager" {
  count       = var.enable_fortimanager ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["FortiManager*VM64-AWS *(${var.fortimanager_os_version}*) GA*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Canonical
}

data "aws_ami" "fortianalyzer" {
  count       = var.enable_fortianalyzer ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["FortiAnalyzer*VM64-AWS *(${var.fortianalyzer_os_version}*) GA*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Canonical
}

module "iam_profile" {
  source        = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance_iam_role"
  count         = var.enable_fortimanager || var.enable_fortianalyzer ? 1 : 0
  iam_role_name = "${var.vpc_name}-${var.random_string}-fortimanager-instance-role"
}

module "fortimanager" {
  source                   = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  count                    = var.enable_fortimanager ? 1 : 0
  aws_ec2_instance_name    = "${var.vpc_name}-Fortimanager"
  availability_zone        = var.availability_zone_1
  instance_type            = var.fortimanager_instance_type
  public_subnet_id         = module.subnet-management-public-az1.id
  enable_public_ips        = var.enable_fortimanager_public_ip
  public_ip_address        = local.fortimanager_ip_address
  aws_ami                  = data.aws_ami.fortimanager[0].id
  keypair                  = var.keypair
  security_group_public_id = aws_security_group.fortimanager_sg[0].id
  userdata_rendered        = var.enable_fortimanager ? var.fortimanager_user_data : ""
  iam_instance_profile_id  = module.iam_profile[0].id
  tags                     = var.tags
}

locals {
  # Falls back to vpc_cidr_sg (not 0.0.0.0/0) if the caller doesn't set log_source_cidr_sg.
  log_cidrs = length(var.log_source_cidr_sg) > 0 ? var.log_source_cidr_sg : var.vpc_cidr_sg
}

#
# Scoped to the actual ports this template's topology needs. Dropped 8900 (web filter/AV
# query) entirely -- it's not on FortiAnalyzer's own required-ports list at all (that's a
# FortiManager port), looks copy-pasted from the FMG security group by mistake.
#
resource "aws_security_group" "fortianalyzer_sg" {
  count       = var.enable_fortianalyzer ? 1 : 0
  name        = "allow_faz_required_ports"
  description = "Fortianalyzer Allow Required Ports"
  vpc_id      = module.vpc-management.vpc_id
  ingress {
    description = "Allow HTTPS admin/GUI access"
    from_port   = 443
    to_port     = 443
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
    description = "Allow SSH admin/CLI access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_sg
  }
  ingress {
    description = "Allow OFTP log forwarding (TCP) from FortiGate/FortiManager log sources"
    from_port   = 514
    to_port     = 514
    protocol    = "tcp"
    cidr_blocks = local.log_cidrs
  }
  ingress {
    description = "Allow syslog (UDP) from FortiGate/FortiManager log sources"
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = local.log_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "Allow FAZ required ports" }, var.tags)
}

module "fortianalyzer" {
  source                   = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  count                    = var.enable_fortianalyzer ? 1 : 0
  aws_ec2_instance_name    = "${var.vpc_name}-Fortianalyzer"
  availability_zone        = var.availability_zone_1
  instance_type            = var.fortianalyzer_instance_type
  public_subnet_id         = module.subnet-management-public-az1.id
  public_ip_address        = local.fortianalyzer_ip_address
  aws_ami                  = data.aws_ami.fortianalyzer[0].id
  enable_public_ips        = var.enable_fortianalyzer_public_ip
  keypair                  = var.keypair
  security_group_public_id = aws_security_group.fortianalyzer_sg[0].id
  userdata_rendered        = var.enable_fortianalyzer ? var.fortianalyzer_user_data : ""
  iam_instance_profile_id  = module.iam_profile[0].id
  tags                     = var.tags
}
