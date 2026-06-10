provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-security-group"
  description = "Allow SSH and Minecraft traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["128.193.152.205/32"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami                    = "ami-0236922087fa98b6e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  key_name 		 = "MyLinuxServer"
  subnet_id		 = "subnet-005aa4c6df4acab28"
  
  associate_public_ip_address		= true
  instance_initiated_shutdown_behavior	= "stop"
  
  metadata_options {
	http_endpoint	= "enabled"
	http_tokens	= "required"
	http_put_response_hop_limit = 2
  }

  tags = {
    Name = "Minecraft-Server"
  }
}
