resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name  = var.vpc_name
    }
}

resource "aws_subnet" "vpc_private_subnet" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = {
      Name = each.key
    }
}

resource "aws_subnet" "vpc_public_subnet" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.vpc
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = {
      Name = each.key
    }
  
}