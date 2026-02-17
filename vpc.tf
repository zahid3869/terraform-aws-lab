resource "aws_vpc" "main_network" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_flow_log" "main_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main_network.id # নিশ্চিত করো এই আইডি তোমার VPC-র সাথে মিলছে
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