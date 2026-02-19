# VPC এর CIDR ব্লক
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# ভিপিসি-র নাম
variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "Zahid-VPC-Project"
}

# পাবলিক সাবনেটের CIDR
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# প্রাইভেট সাবনেটের CIDR
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# এডাব্লুএস রিজিয়ন
variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}
