# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**IMPORTANT**: When adding new files to any module or making structural changes, always update this CLAUDE.md file to document the changes. This ensures consistent understanding across all Claude Code sessions.

## Repository Overview

This is a collection of reusable Terraform modules for AWS infrastructure, primarily focused on networking and FortiGate deployments. All modules are designed to be referenced via Git URLs in other Terraform projects.

## Module Architecture

### Module Structure Pattern

Each module follows a consistent three-file pattern:
- `main.tf` - Resource definitions
- `variables.tf` - Input variables
- `outputs.tf` or `output.tf` - Output values

### Composite vs Atomic Modules

**Atomic modules** (single resource abstractions):
- `aws_vpc` - Basic VPC creation
- `aws_subnet` - Subnet with optional route table association
- `aws_igw` - Internet Gateway
- `aws_route_table` - Route table creation
- `aws_route_table_association` - Route table to subnet association
- `aws_security_group` - Security group creation
- `aws_tgw` - Transit Gateway
- `aws_tgw_attachment` - TGW attachment to VPC
- `aws_vpc_endpoints` - VPC endpoints
- `aws_ec2_instance` - EC2 instance with flexible ENI configuration
- `aws_ec2_instance_iam_role` - IAM role for EC2 instances
- `aws_fortigate_ha_instance_iam_role` - IAM role for FortiGate HA
- `aws_gwlb` - Gateway Load Balancer with VPC endpoints

**Composite modules** (multi-resource orchestration):
- `aws_inspection_vpc` - Full inspection VPC with multiple subnet types, TGW attachment, and GWLB integration
- `aws_management_vpc` - Management VPC with FortiManager support and TGW integration

### Module Referencing Convention

All modules reference each other using Git URLs:
```hcl
module "example" {
  source = "git::https://github.com/40netse/terraform-modules.git//module_name"
}
```

When modifying modules, remember that changes affect all downstream projects using these modules.

## Key Architectural Patterns

### Inspection VPC Architecture

The `aws_inspection_vpc` module creates a multi-AZ inspection architecture with:

**Subnet types** (created per AZ using `cidrsubnet` calculations):
- Public subnets (index 0) - Internet-facing traffic
- GWLBE subnets (index 1) - Gateway Load Balancer Endpoints
- Private subnets (index 2) - Internal traffic, TGW attachments
- NAT Gateway subnets (index 3, optional) - Conditional on `enable_nat_gateway`
- Management subnets (index 4, optional) - Conditional on `enable_dedicated_management_eni`

**Subnet indexing logic**:
The module uses dynamic index calculations to handle optional subnets:
```hcl
subnet_index_addon_for_natgw = var.enable_nat_gateway ? 1 : 0
subnet_index_addon_for_management = var.enable_dedicated_management_eni ? 1 : 0
```
This ensures CIDR blocks are correctly calculated whether optional subnets are enabled or not.

**Split files by subnet type**:
- `public_subnet.tf` - Public subnets and route tables
- `gwlbe_subnet.tf` - GWLBE subnets and route tables
- `private_subnet.tf` - Private subnets and route tables
- `nat_gw_subnet.tf` - NAT gateway subnets and route tables
- `mgmt_subnet.tf` - Management subnets and route tables
- `main.tf` - VPC, IGW, TGW attachments, locals

### Management VPC Architecture

The `aws_management_vpc` module creates a management VPC for FortiManager, FortiAnalyzer, and jump box instances:

**Subnet types** (created per AZ using `cidrsubnet` calculations):
- Public subnets (index 0, 1) - FortiManager, FortiAnalyzer, and jump box instances
- Private subnets (index 2, 3, optional) - Conditional on `enable_jump_box`

**Private subnet NAT functionality**:
When `enable_jump_box = true`, private subnets are created to allow east/west spoke VPC traffic to NAT through the jump box:
- Private subnets created in both AZs
- Each private subnet has its own route table
- Default route (`0.0.0.0/0`) in each private subnet route table points to jump box primary ENI
- TGW attachment uses private subnets (when they exist) instead of public subnets
- This allows spoke VPC instances to NAT behind the jump box public IP for package downloads

**File structure**:
- `vpc_management.tf` - VPC, IGW, TGW attachments, locals, security groups, public subnets
- `private_subnet.tf` - Private subnets, route tables, and routes (conditional on jump box)
- `ec2.tf` - Jump box, FortiManager, FortiAnalyzer instances
- `variables.tf` - Input variables
- `outputs.tf` - Output values

### EC2 Instance Module

The `aws_ec2_instance` module is highly flexible:
- Primary ENI created with instance (public subnet)
- Optional private ENI (device_index 1) - `enable_private_interface`
- Optional HA/management ENI (device_index 3) - `enable_hamgmt_interface`
- Supports pre-allocated or auto-created EIPs
- Source/dest check configurable per interface (see `public_src_dst_check`)

Recent change: The `public_src_dst_check` variable was added to make source/destination checking configurable on the primary interface.

### GWLB Architecture

The `aws_gwlb` module creates:
- Gateway Load Balancer across two AZs
- VPC Endpoint Service (auto-accepted)
- Target group with GENEVE protocol (port 6081)
- Health checks on configurable listener port
- VPC Endpoints in each AZ
- Automatic attachment of two target IPs

## Development Commands

### Terraform Workflow

```bash
# Format all Terraform files
terraform fmt -recursive

# Validate module configuration
cd <module_directory>
terraform init
terraform validate

# Check for potential issues
terraform plan
```

### Module Testing

Since these are reusable modules, they cannot be applied directly. Testing should be done by:
1. Creating a test configuration that uses the module
2. Using the module via Git source reference
3. Running `terraform plan` in the test configuration

## Important Conventions

### Variable Naming
- Use descriptive names: `enable_*` for booleans, `named_*` for name references
- Availability zones passed as `availability_zone_1` and `availability_zone_2`
- VPC naming pattern: `${var.vpc_name}-<resource>-<az>-<type>`

### Conditional Resources
- Use `count` with boolean variables for optional resources
- Pattern: `count = var.enable_feature ? 1 : 0`
- Access with `[0]` index: `module.resource[0].output`

### Route Tables
- Separate route tables per AZ for most subnet types
- IGW route tables use `gateway_id` association
- Conditional GWLB route table associations via `create_gwlb_route_associations`

### Security
- Management VPC includes FortiManager-specific security group rules
- Security groups are always "allow all" or have specific FortiGate/FortiManager ports
- Default route tables are typically tagged as "unused"

## Common Patterns

### Multi-AZ Resource Creation
Resources are typically created in pairs (AZ1 and AZ2):
```hcl
module "subnet-public-az1" { ... }
module "subnet-public-az2" { ... }
```

### Transit Gateway Integration
- TGW lookups use data source with tag filter: `tag:Name = var.named_tgw`
- TGW attachments conditional on `enable_tgw_attachment`
- Appliance mode typically enabled for inspection VPCs
- Custom TGW route tables created and associated per VPC

### CIDR Calculations
Uses `cidrsubnet()` with configurable `subnet_bits`:
```hcl
cidrsubnet(var.vpc_cidr, var.subnet_bits, local.subnet_index)
```

## Module Dependencies

When making changes, be aware of these dependency relationships:
- Composite modules depend on all atomic modules
- `aws_subnet` can optionally use `aws_route_table`
- `aws_tgw_attachment` requires `aws_tgw` to exist (via data source)
- `aws_ec2_instance` uses `aws_ec2_instance_iam_role` or `aws_fortigate_ha_instance_iam_role`
