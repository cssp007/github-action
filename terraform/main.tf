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
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarQ_instance" {
  ami           = "ami-03a933af70fa97ad2"
  instance_type = "t2.medium"
  key_name      = "cssp"

  subnet_id                   = aws_subnet.terraform_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sonarQ_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  sudo apt update -y
  sudo apt install -y openjdk-11-jdk
  wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
  echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
  sudo apt update -y
  sudo apt install -y postgresql-13
  wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.0.1.46107.zip
  sudo apt -y install unzip
  sudo unzip sonarqube-*.zip -d /opt
  sudo mv /opt/sonarqube-* /opt/sonarqube
  EOF

  tags = {
    "Name" : "SonarQ Server"
  }
}
