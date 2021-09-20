provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
# local variable declaration 
locals {
  private_subnets = {
    "${var.region}a" = "192.168.10.0/24"
    "${var.region}b" = "192.168.20.0/24"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    "Name" = "myvpc"
  }

}
# Create and attach internet gateway to above created vpc 
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "my_igw"
  }

}

# create subnets 

resource "aws_subnet" "mypublic" {
  cidr_block              = "192.168.1.0/24"
  vpc_id                  = aws_vpc.myvpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "mypublic"
  }
}

resource "aws_subnet" "myprivate" {
  count                   = length(local.private_subnets)
  cidr_block              = element(values(local.private_subnets), count.index)
  vpc_id                  = aws_vpc.myvpc.id
  availability_zone       = element(keys(local.private_subnets), count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "myprivate-${count.index}"
  }

}

# Update main route table of vpc into public route table 
resource "aws_default_route_table" "Public_RT" {
  default_route_table_id = aws_vpc.myvpc.main_route_table_id
  tags = {
    "Name" = "Public_RT"
  }
}

resource "aws_route" "Public_route" {
  route_table_id         = aws_default_route_table.Public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "Public_RTA" {
    subnet_id = aws_subnet.mypublic.id
    route_table_id = aws_default_route_table.Public_RT.id
  
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "Private_RT"
  }

}

resource "aws_route_table_association" "Private_RTA" {
    count = length(local.private_subnets)
    subnet_id = element(aws_subnet.myprivate.*.id, count.index)
    route_table_id = aws_route_table.Private_RT.id
  
}

resource "aws_eip" "myeip" {
  vpc = true
  tags = {
    "Name" = "myeip"
  }
  
}

resource "aws_nat_gateway" "myNat" {
  allocation_id = aws_eip.myeip.id
  subnet_id = aws_subnet.mypublic.id
  tags = {
    "Name" = "myNat"
  }
  
}

resource "aws_route" "myprivate_route" {
  route_table_id = aws_route_table.Private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.myNat.id
  
}

resource "aws_security_group" "Public_SG" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Public_SG"
  }

}

resource "aws_security_group" "Private_SG" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "Private_SG"
  }
}

resource "aws_security_group_rule" "public_ingress_rules" {
  for_each = var.Public_SG
  type = "ingress"
  from_port = each.value.from
  to_port = each.value.to
  cidr_blocks = ["0.0.0.0/0"]
  protocol = each.value.protocol
  security_group_id = aws_security_group.Public_SG.id
}

resource "aws_security_group_rule" "private_ingress_rules" {
  for_each = var.Private_SG
  type = "ingress"
  from_port = each.value.from
  to_port = each.value.to
  protocol = each.value.protocol
  cidr_blocks = [aws_subnet.mypublic.cidr_block]
  security_group_id = aws_security_group.Private_SG.id
}