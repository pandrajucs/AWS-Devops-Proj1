//Provide AWS Access key and Secret key to execute terraform

provider "aws" {
   
    region = "us-east-1"
    
}

//Craete Security group

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-03fce764d6d3fdd1f"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}


//create Docker servers

resource "aws_instance" "servers" {
    count=3
    ami = "ami-0817d428a6fb68645"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "AWS_KeyPair"
    subnet_id = "subnet-034250c45e4a08fbf"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    user_data = "${file("script1.sh")}"
    tags = {
        Name = "Docker-"
    }
}

//DockerSlave-Server

resource "aws_instance" "server-1" {
    ami = "ami-0817d428a6fb68645"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "AWS_KeyPair"
    subnet_id = "subnet-034250c45e4a08fbf"
    private_ip = "10.1.1.200"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    user_data = "${file("script2.sh")}"
    tags = {
        Name = "DockerSlave-Server"
    }
}

//TG 
resource "aws_lb_target_group" "tg" {
  name     = "AWS-NLB-TG"
  port     = 80
  protocol = "TCP"
  vpc_id   = "vpc-03fce764d6d3fdd1f"
}

//NLB
resource "aws_lb" "nlb" {
  name               = "aws-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-034250c45e4a08fbf","subnet-0d47b4ff30b766a68","subnet-0e603ab3ebf20d410"]

} 

