# -----------------------------
# AWS Provider
# -----------------------------
provider "aws" {
  region = "us-east-1"
}

# -----------------------------
# Get Default VPC
# -----------------------------
data "aws_vpc" "default" {
  default = true
}

# -----------------------------
# Get Subnets in Default VPC
# -----------------------------
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and Strapi"
  vpc_id      = data.aws_vpc.default.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Strapi
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Strapi-SG"
  }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "strapi_server" {
  ami           = "ami-0b6c6ebed2801a5cb"  # Ubuntu AMI
  instance_type = "t2.micro"              # Can upgrade to t3.small if needed
  key_name      = "Terraform"             # Your AWS key pair name

  subnet_id = data.aws_subnets.default_subnets.ids[0]

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  # 25GB Storage
  root_block_device {
    volume_size = 25
    volume_type = "gp2"
  }

  # Pass image_tag into userdata.sh
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
