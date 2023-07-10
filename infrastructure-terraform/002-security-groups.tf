resource "aws_security_group" "capstone-24-lb-sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for ${var.project_name} load balancer"
  vpc_id      = aws_vpc.capstone-24-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-lb-sg"
  }
}

resource "aws_security_group" "capstone-24-ec2-sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for ${var.project_name} ec2 instances"
  vpc_id      = aws_vpc.capstone-24-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.capstone-24-lb-sg.id}"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.capstone-24-lb-sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_security_group" "capstone-24-docdb-sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for ${var.project_name} Database"
  vpc_id      = aws_vpc.capstone-24-vpc.id

  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["${aws_security_group.capstone-24-ec2-sg.id}"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-docdb-sg"
  }
}