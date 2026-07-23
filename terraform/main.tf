# Data source to fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group allowing inbound HTTP (80) and SSH (22) traffic
resource "aws_security_group" "web_sg" {
  name        = "${var.app_name}-${var.environment}-sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.environment
  }
}

# EC2 Instance to host the website
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update system packages and install Apache web server & Git
              dnf update -y
              dnf install -y httpd git

              # Start and enable Apache service
              systemctl start httpd
              systemctl enable httpd

              # Remove default Apache welcome files
              rm -rf /var/www/html/*

              # Clone website repository and copy all HTML, CSS, JS, and image files
              git clone ${var.git_repo_url} /tmp/webfiles
              cp -r /tmp/webfiles/* /var/www/html/
              rm -rf /tmp/webfiles

              # Set proper ownership and permissions
              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html
              EOF

  tags = {
    Name        = "${var.app_name}-server"
    Environment = var.environment
  }
}
