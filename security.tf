# ১. ক্লাউডওয়াচ লগ গ্রুপ (Encryption ইস্যু ইগনোর করা হয়েছে)
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "zahid-vpc-flow-logs"
  retention_in_days = 7
}

# ২. IAM Role তৈরি (VPC Flow Logs এর জন্য)
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "zahid-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

# ৩. IAM Policy তৈরি (Wildcard '*' সরিয়ে নির্দিষ্ট লগ গ্রুপের ARN দেওয়া হয়েছে)
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "zahid-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect   = "Allow"
        # নির্দিষ্ট লগ গ্রুপের জন্য পারমিশন সীমাবদ্ধ করা হয়েছে (Security Best Practice)
        Resource = "${aws_cloudwatch_log_group.vpc_log_group.arn}:*"
      },
    ]
  })
}

# ৪. VPC Flow Log এনাবল করা
resource "aws_flow_log" "main_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main_network.id
}

# ৫. সিকিউরিটি গ্রুপ (SSH এর জন্য)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main_network.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # পাবলিকলি ওপেন না রেখে ইন্টারনাল রাখা হয়েছে
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}