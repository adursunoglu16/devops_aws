# Hands-on Terraform-02 : Terraform Variables, Conditionals, Loops, Data Sources.

Purpose of the this hands-on training is to give students the knowledge of variables, conditionals, loops and data sources in Terraform.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- Use variables, conditionals, loops and data sources with Terraform

### Variables

- Make the changes in the `main.tf` file.

```bash
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

variable "ec2-name" {
  default = "dursun-ec2"
}

variable "ec2-type" {
  default = "t2.micro"
}

variable "ec2-ami" {
  default = "ami-0742b4e673072066f"      #use current ami
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2-ami
  instance_type = var.ec2-type   #iki turlu kullanimi var bu ve $ ile
  key_name      = "pablokeys"
  tags = {
    Name = "${var.ec2-name}-💻🎯🎉"
  }
}

variable "s3-bucket-name" {
  default = "dursun-s3-bucket-variable"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = var.s3-bucket-name
  acl    = "private"
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
```

```bash
terraform apply
```

- Create a file name `variables.tf`. Take the variables from `main.tf` file and paste into "variables.tf". 

```bash
terraform validate

terraform fmt

terraform apply
```

- Comment the variable of `ec2-name` with "ctrl+k+c" in vscode. (comment out = ctrl+k+u) Then make the changes in the `main.tf` file.

```bash
locals {
  my-instance-name = "dursun-local-name"
  my-instance-type = "t2.micro"  #burada da local olarak tanimliyoruz var ile ayni mantik
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2-ami
  instance_type = local.my-instance-type   #iki turlu kullanimi var bu ve $ ile kullaninca stringde ekliyebiliyorsun
  key_name      = "pablokeys"
  tags = {
    Name = "${local.my-instance-name}-comes from locals"
  }
}
```

- A `local` value assigns a name to an expression, so you can use it multiple times within a module without repeating it.

- Run the command `terraform plan`

```bash
terraform plan
```

- Run the command `terraform apply` again. Check the EC2 instance's Name tag column.

```bash
terraform apply
```

- Go to the `variables.tf` file and comment the s3 bucket name variable's default value.

```tf
variable "s3-bucket-name" {
#   default     = "oliver-new-s3-bucket-addwhateveryouwant"
}
```

```bash
terraform plan
```
## burada da mesela s3 e isim vermicez file icinde sonra run ederken bize sorcak ismi orada vercez
- You can define variables with `-var` command

```bash
terraform plan -var="s3-bucket-name=oliver-new-s3-bucket-2"
```
# veya tf.vars diye bir file icinde sim vecez bucket a. Her departman kendi istedigi ismi verebilir mesela bu yontemle. diger seyler sabit bucket ismi istege gore oluyor burada
- Create a file name `oliver.tfvars`. Add the followings.

```bash
s3-bucket-name = "oliver-s3-bucket-newest"
```

- Run the command belov.

```bash
terraform plan --var-file="oliver.tfvars"
```

- Go to the `variables.tf` file and comment out the s3 bucket name variable's default value..

```tf
variable "s3-bucket-name" {
  default     = "oliver-new-s3-bucket"
}
```
# tf.vars run edebilmek icin buna flag vermeliyiz yoksa variables file i calistirir
- Run terraform apply --var-file="oliver.tfvars" command.

```bash
terraform apply --var-file="oliver.tfvars" 
```

- Run terraform apply command.

```bash
terraform apply 
```

- Change the name of oliver.tfvars to terraform.tfvars.
# once terraform.tfvars i check eder oncelik bundaymis cunku. terraform.tfvars ismi has priority
- Run terraform apply command. 

### Conditionals and Loops

- Count and count.index

- Go to the `variables.tf` file and create a new variable.

```bash
variable "num_of_buckets" {
  default = 2
}
```

- Go to the `main.tf` file, make the changes in order.

```bash
resource "aws_s3_bucket" "tf-s3" {
  bucket = "${var.s3-bucket-name}-${count.index}"
  acl    = "private"
  count = var.num_of_buckets
}
```

```bash
terraform plan
```

```bash
terraform apply
```

- Check the S3 buckets from console.

- Conditional Expressions.

- Go to the `main.tf` file, make the changes in order.

```bash
resource "aws_s3_bucket" "tf-s3" {
  bucket = "${var.s3-bucket-name}-${count.index}"
  acl    = "private"
  # count = var.num_of_buckets
  count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
}
```

```bash
terraform plan
```

- Functions.

- Go to the `variables.tf` file again and add a new variable.

```bash
variable "users" {
  default = ["spring", "micheal", "oliver"]
}
```

- Go to the `main.tf` file make the changes. Change the IAM role and add IAMFullAccess policy.

```bash
resource "aws_s3_bucket" "tf-s3" {
  # bucket = "var.s3-bucket-name.${count.index}"
  acl = "private"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
  for_each = toset(var.users)
  bucket   = "example-s3-bucket-${each.value}"
}

resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}
```

```bash
terraform apply
```

- Go to the AWS console (IAM and S3) and check the resources.

### Terraform Data Sources

- `Data sources` allow data to be fetched or computed for use elsewhere in Terraform configuration.

- Go to the `AWS console and create an image` from your EC2. Select your instance and from actions click image and templates and then give a name for ami `my-ami` and click create. 

# It will take some time. go to the next steps.

- Go to the `variables.tf` file and comment the variable `ec2-ami`.

- Go to the `main.tf` file make the changes in order.

```bash
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
  key_name      = "pablokeys"
  tags = {
    Name = "${local.instance-name}-this is from my-ami"
  }
}
```

```bash
terraform plan
```

```bash
terraform apply
```

- Check EC2 instance's ami id.

- You can see which data sources can be used with a resource in the documentation of terraform. For example EBS snapshot.

```bash
terraform destroy
```