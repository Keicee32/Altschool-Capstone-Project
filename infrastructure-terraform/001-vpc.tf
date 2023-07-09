#----------------------------------------------------
#                       VPC
#----------------------------------------------------


resource "aws_vpc" "capstone-24-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Creates Public Subnets
resource "aws_subnet" "capstone-24-pub-subnets" {
  vpc_id            = aws_vpc.capstone-24-vpc.id
  for_each          = var.public_subnet
  cidr_block        = each.value["sub_cidr_block"]
  availability_zone = each.value["AZ"]

  tags = {
    Name = "${var.project_name}-Subnet-${each.key}"
  }
}

# Creates Private Subnets
resource "aws_subnet" "capstone-24-pri-subnets" {
  vpc_id            = aws_vpc.capstone-24-vpc.id
  for_each          = var.private_subnet
  cidr_block        = each.value["sub_cidr_block"]
  availability_zone = each.value["AZ"]

  tags = {
    Name = "${var.project_name}-Subnet-${each.key}"
  }
}

# Creates Database Subnets
resource "aws_subnet" "capstone-24-db-subnets" {
  vpc_id            = aws_vpc.capstone-24-vpc.id
  for_each          = var.database_subnet
  cidr_block        = each.value["sub_cidr_block"]
  availability_zone = each.value["AZ"]

  tags = {
    Name = "${var.project_name}-Subnet-${each.key}"
  }
}

# Creates Internet Gateway
resource "aws_internet_gateway" "capstone-24-igw" {
  vpc_id = aws_vpc.capstone-24-vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Creates a Route Table
resource "aws_route_table" "capstone-24-rtb" {
  vpc_id = aws_vpc.capstone-24-vpc.id

  tags = {
    Name = "${var.project_name}-rtb"
  }
}

# Creates a Route for the Route Table
resource "aws_route" "capstone-24-rt" {
  route_table_id         = aws_route_table.capstone-24-rtb.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.capstone-24-igw.id
}

# Associates the Route Table with the Public Subnets
resource "aws_route_table_association" "capstone-24-rtb-association" {
  for_each       = var.public_subnet
  subnet_id      = aws_subnet.capstone-24-pub-subnets[each.key].id
  route_table_id = aws_route_table.capstone-24-rtb.id
}

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-docudb-sg"
  }
}