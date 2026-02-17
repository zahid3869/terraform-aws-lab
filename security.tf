
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name = "zahid-vpc-flow-logs"
}

# এখানে তোমার সেই Flow Log এবং IAM Role এর কোডগুলো থাকবে
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name = "zahid-vpc-flow-logs"
}

# ... বাকি IAM এবং Flow Log কোড এখানে বসাও ...