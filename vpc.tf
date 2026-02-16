resource "aws_vpc" "main_network" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_one" {
  vpc_id     = aws_vpc.main_network.id
  cidr_block = var.public_subnet_cidr
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_one" {
  vpc_id     = aws_vpc.main_network.id
  cidr_block = var.private_subnet_cidr
  tags = {
    Name = "private-subnet"
  }
}