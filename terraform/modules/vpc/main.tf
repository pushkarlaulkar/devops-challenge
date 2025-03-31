#In this module we will be creating following resources
#   1. VPC
#   2. Internet Gateway
#   3. Main Public route table which has a route to internet through the internet gateway
#   4. Private route table which only has local route
#   5. 2 Public subnets which will be associated to the main public route table
#   6. 2 Private subnets which will be associated to the private route table

#VPC
resource "aws_vpc" "sts-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Simple-Time-Service-VPC"
  }
}

#IGW
resource "aws_internet_gateway" "sts-igw" {
  vpc_id = aws_vpc.sts-vpc.id

  tags = {
    Name = "Simple-Time-Service-IGW"
  }
}

#Public Route Table
resource "aws_route_table" "sts-public-rt" {
  vpc_id = aws_vpc.sts-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sts-igw.id
  }

  tags = {
    Name = "Simple-Time-Service-Public-RT"
  }
}

#Setting the above Public Route Table as the main
resource "aws_main_route_table_association" "sts-vpc-main-rt-asso" {
  vpc_id         = aws_vpc.sts-vpc.id
  route_table_id = aws_route_table.sts-public-rt.id
}

#Creating 2 public subnets
resource "aws_subnet" "sts-public-subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.sts-vpc.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Simple-Time-Service-Public-Subnet-${count.index + 1}"
  }
}

#Associating the above 2 public subnets to the main public route table
resource "aws_route_table_association" "sts-public-subnet-asso" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.sts-public-subnet[count.index].id
  route_table_id = aws_route_table.sts-public-rt.id
}

#Private Route Table
resource "aws_route_table" "sts-private-rt" {
  vpc_id = aws_vpc.sts-vpc.id

  tags = {
    Name = "Simple-Time-Service-Private-RT"
  }
}

#Creating 2 private subnets
resource "aws_subnet" "sts-private-subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.sts-vpc.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].availability_zone

  tags = {
    Name = "Simple-Time-Service-Private-Subnet-${count.index + 1}"
  }
}

#Associating the above 2 private subnets to the private route table
resource "aws_route_table_association" "sts-private-subnet-asso" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.sts-private-subnet[count.index].id
  route_table_id = aws_route_table.sts-private-rt.id
}

#Allowing all traffic on port 80 within VPC
resource "aws_security_group" "sts-ecs-task-sg" {
  name        = "Allow Port 80 within VPC"
  description = "Allow Port 80 within VPC"
  vpc_id = aws_vpc.sts-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.sts-vpc.cidr_block]
    description = "Allow Port 80 within VPC"
  }
}