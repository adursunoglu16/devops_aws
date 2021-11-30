// aws icin terraform sayfada user providerdan aliriz bu kismi. ayni anda birden cok provider ornegin github provider kullanmak isteseydik onu da eklicektik
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.42.0"
    }
#    github = {
#      source = "integrations/github"
#      version = "4.18.0"
#    }
  }
}

//provider "github" {
// Configuration options
//}
provider "aws" {
  region  = "us-east-1"
// normalde buraya access key secret key de yaziyorduk ama biz makineye role atadigimiz icin burada gerek yok
}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-project-201"   // bu namedeki secgrubu ec2 ya bagla dicez

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
    from_port   = 0  //tum portlari ac demek
    protocol    = -1 // her protokolu demek
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
// instancelara isim aticaz variable ile
variable "mytags" {
  type    = list(string)
  default = ["first", "second"]
}
resource "aws_instance" "apache-server" {
  ami             = data.aws_ami.amazon-linux-2.id //data ile cek diyor proje yoksa direkt yazardik ami adini. data "aws_ami" "amazon-linux-2" yi referans ettik.
  // normalde secgrubu referans alsaydik aws_security_group.tf-sec-gr.id derdik basina resource yazmazdik ama data referans etceksen basina data yaziyon
  instance_type   = "t2.micro"
//  key_name        = "pablokeys"
  count           = 2 // 2 adet apache server istiyor proje
  security_groups = ["tf-project-201"]
  user_data = file("create_apache.sh") // <<-EOF ile de yazabilirdik ama file func. kullanmak istedik,create_apache.sh ayni dizinde olmasaydi path ini verip yazarsin. 

  tags = {
    Name = "terraform ${element(var.mytags, count.index)} instance" // string icinde oldugu icin ${ kullandik yoksa sadece $ kullaniriz
  }
    provisioner "local-exec" {
      command = "echo ${self.private_ip} >> private_ip.txt" // projede instancelarin ip leri txt yazdir diyordu onun icin, calistigimiz diznde olusturur. Eger bu lokalde deilde olusan makinada yazdir deseydi remote-exec komutu.
    }
    provisioner "local-exec" {
      command = "echo ${self.public_ip} >> public_ip.txt" // self yani olusan makinanin. >> ile alt alta yaziyor > olsaydi uzerine yazardi
    }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true // en guncel olani alir.
  owners      = ["amazon"]  // amazonun ami istiyoruz.
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
// sadece publicleri yazdiralim
output "mypublicips" {
  value = aws_instance.apache-server[*].public_ip  
}
// apache-server[0] deseydik ilk instance [1] deseydik ikinci instance in ip yi alirdi biz hepsi icin [*] dedik

// terraform apply diyip run ettikten sonra terraform output dersek ciktilari goruruz ekranda.  Terminalde terraform output > public.txt dersek 
// public ip leri yazdirir dosyalara.
