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
