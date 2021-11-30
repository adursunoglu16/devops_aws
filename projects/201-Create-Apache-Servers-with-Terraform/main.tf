terraform {
  required_providers {
    aws = {
<<<<<<< HEAD
        source = "hashicorp/aws"
        version = "3.42.0"
=======
      source = "hashicorp/aws"
      version = "3.42.0"
>>>>>>> 6b7ce6a0da86afa4ac6585806376608b7d9ed9ad
    }
  }
}

provider "aws" {
<<<<<<< HEAD
    region = "us-east-1"
  
}
resource "aws_security_group" "tf-sec-gr" {
    name = "tf-project"
    ingress   {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 443
      protocol = "tcp"
      to_port = 443
    } 

    ingress   {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 80
      protocol = "tcp"
      to_port = 80
    } 

    ingress   {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 22
      protocol = "tcp"
      to_port = 22
    } 

    egress  {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 0
      protocol = -1
      to_port = 0
    } 
}

resource "aws_instance" "apache-instance" {
    ami = data.aws_ami.amazon-linux-2.id
    instance_type = "t2.micro"
    key_name = "pablokeys"
    count = 2
    security_groups = [ "tf-project" ]
    user_data = file("create_apache.sh")
    tags = {
      Name = "terraform ${element(var.mytags, count.index)} instance"

    }
  
=======
  region  = "us-east-1"
#   profile = "cw-training"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "apache-server" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
//  key_name        = "northvirginia"
  count           = 2
  security_groups = ["tf-project"]
  user_data = file("create_apache.sh")

  tags = {
    Name = "terraform ${element(var.mytags, count.index)} instance"
  }
>>>>>>> 6b7ce6a0da86afa4ac6585806376608b7d9ed9ad
    provisioner "local-exec" {
      command = "echo ${self.private_ip} >> private_ip.txt"
    }
    provisioner "local-exec" {
      command = "echo ${self.public_ip} >> public_ip.txt"
    }
<<<<<<< HEAD


}

data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = ["amazon"]
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

variable "mytags" {
  type    = list
  default = ["first", "second"]
}

output "mypublicip0" {
  value = "http://${aws_instance.apache-instance[0].public_ip}"
}
output "mypublicip1" {
  value = "http://${aws_instance.apache-instance[1].public_ip}"
=======
}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-project"

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
variable "mytags" {
  type    = list(string)
  default = ["first", "second"]
}

output "mypublicip" {
  value = aws_instance.apache-server[*].public_ip
>>>>>>> 6b7ce6a0da86afa4ac6585806376608b7d9ed9ad
}