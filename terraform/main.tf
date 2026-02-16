provider "aws" {
  region = "us-east-1"
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and Strapi"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
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

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "strapi_server" {
  ami           = "ami-0b6c6ebed2801a5cb"   
  instance_type = "t2.micro"               
  key_name      = "Terraform"      

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  # 25GB Storage
  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  # Use external userdata.sh
  user_data = templatefile("${path.module}/userdata.sh", {
    image_tag = var.image_tag
  })

  tags = {
    Name = "Strapi-Server"
  }
}

# -----------------------------
# Output Public IP
# -----------------------------
output "public_ip" {
  value = aws_instance.strapi_server.public_ip
}
