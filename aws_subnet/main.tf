
resource "aws_subnet" "subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags= {
    Name        = var.subnet_name
  }
}

resource "aws_route_table_association" "rta" {
  count          = var.public_route
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.public_route_table_id
}
