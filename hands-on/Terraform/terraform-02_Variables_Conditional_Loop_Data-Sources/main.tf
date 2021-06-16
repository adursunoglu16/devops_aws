provider "aws" {
  region  = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.38.0"
    }
  }
}
locals {
  instance-name = "oliver-local-name"
}
data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["self"]
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2-type
  key_name      = "mk"
  tags = {
    Name = "${local.instance-name}-this is from my-ami"
  }
}
resource "aws_s3_bucket" "tf-s3" {
  acl = "private"
  for_each = toset(var.users)
  bucket   = "example-s3-bucket1-${each.value}"
}
resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}
output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}
output "tf-example-public_ip" {
  value = aws_instance.tf-ec2.public_ip
}
output "tf-example-private-ip" {
  value = aws_instance.tf-ec2.private_ip
}
output "tf-example-s3" {
  value = aws_s3_bucket.tf-s3[*]
}