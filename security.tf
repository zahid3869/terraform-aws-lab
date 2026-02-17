
# ১. ক্লাউডওয়াচ লগ গ্রুপ (ইগনোর কমেন্ট সহ)
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name = "zahid-vpc-flow-logs"
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

# ৩. IAM Policy তৈরি (লগ লেখার পারমিশন)
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "zahid-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect   = "Allow"
        Resource = "*"
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