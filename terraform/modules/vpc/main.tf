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
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = {
      Name = each.key
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
    for_each = var.private_subnets
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.vpc_private_subnet[each.value].id

    depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id

    route = {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
      Name = "Private_Route_Table"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "Public_Route_Table"
    }
}

resource "aws_route_table_association" "private_rta" {
    for_each = var.private_subnets
    subnet_id = aws_subnet.vpc_private_subnet[each.value].id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_rta" {
    for_each = var.public_subnets
    subnet_id = aws_subnet.vpc_public_subnet[each.value].id
    route_table_id = aws_route_table.public_rt
}

# resource "aws_route" "private_route" {
#     route_table_id = aws_route_table.private_rt.id
#     destination_cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
# }

# resource "aws_route" "public_route" {
#     route_table_id = aws_route_table.public_rt.id
#     destination_cidr_block = "0.0.0.0/0"
# }