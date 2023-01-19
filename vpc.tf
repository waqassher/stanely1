

resource "aws_vpc" "stanely-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = "prod"
  }
}

##  public subnet

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.stanely-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet"
  }
}

## private subnet

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.stanely-vpc.id
  cidr_block              = "10.0.2.0/24"

  tags = {
    Name        = "private-subnet"
  }
}

## Security Group

resource "aws_security_group" "stanely-sg" {
  name        = "Stainely-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.stanely-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

//////////////////////////////////IGW///////////////////////////////////

resource "aws_internet_gateway" "stanely-IGW" {
  vpc_id = aws_vpc.stanely-vpc.id

  tags = {
    Name = "${var.app_name}-IGW"
  }
}

## IGW Association

resource "aws_internet_gateway_attachment" "stanely-IGW-attach" {
  internet_gateway_id = aws_internet_gateway.stanely-IGW.id
  vpc_id              = aws_vpc.stanely-vpc.id
}

/////////////////////////////////Rout Table///////////////////////////////////

resource "aws_route_table" "stanely-rt" {
  vpc_id = aws_vpc.stanely-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stanely-IGW.id
  }

  tags = {
    Name = "${var.app_name}-rt"
  }
}

## RT Association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.stanely-rt.id
}