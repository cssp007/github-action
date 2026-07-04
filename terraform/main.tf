resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "terraform_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "Terraform Public Subnet"
  }
}

resource "aws_subnet" "terraform_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Terraform Private Subnet"
  }
}

resource "aws_internet_gateway" "terraform_ig" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "Terraform Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.terraform_ig.id
  }

  tags = {
    Name = "Terraform Public Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sonarQ_sg" {
  name   = "SoranQ and SSH"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
