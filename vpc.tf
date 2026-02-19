resource "aws_vpc" "main_network" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}
