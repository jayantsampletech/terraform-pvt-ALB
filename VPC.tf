

# create the vpc 
resource "aws_vpc" "ap-south-1-CICD" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ap-south-1-CICD"
  }
}

# create the public subnet 

resource "aws_subnet" "ap-south-1-CICD-public-subnet" {
  vpc_id            = aws_vpc.ap-south-1-CICD.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.zone1
  tags = {
    Name = "ap-south-1-CICD-public-subnet"
  }
}

# public subnet 2 
resource "aws_subnet" "ap-south-1-CICD-public-subnet-2" {
  vpc_id            = aws_vpc.ap-south-1-CICD.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.zone2
  tags = {
    Name = "ap-south-1-CICD-public-subnet-2"
  }
}

# create the private subnet 

resource "aws_subnet" "ap-south-1-CICD-private-subnet" {
  vpc_id            = aws_vpc.ap-south-1-CICD.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.zone2
  tags = {
    Name = "ap-south-1-CICD-private-subnet"
  }
}


# create the internet gateway

resource "aws_internet_gateway" "ap-south-1-CICD_internetGateway" {
  tags = {
    Name = "ap-south-1-CICD_internetGateway"
  }
  vpc_id = aws_vpc.ap-south-1-CICD.id
}

# attach the internet gateway   no need to do this 

# resource "aws_internet_gateway_attachment" "attach_ig" {
#   internet_gateway_id = aws_internet_gateway.ap-south-1-CICD_internetGateway.id
#   vpc_id              = aws_vpc.ap-south-1-CICD.id
# }


# create the public route table 

resource "aws_route_table" "ap-south-1-CICDpublicRT" {
  vpc_id = aws_vpc.ap-south-1-CICD.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ap-south-1-CICD_internetGateway.id
  }
  tags = {
    Name = "ap-south-1-CICDpublicRT"
  }
}

# create the public route table association 1

resource "aws_route_table_association" "ap-south-1-CICDpublicRTassociation" {
  subnet_id      = aws_subnet.ap-south-1-CICD-public-subnet.id
  route_table_id = aws_route_table.ap-south-1-CICDpublicRT.id

}
# public route table association 2 
resource "aws_route_table_association" "public_rt_assoc_subnet2" {
  subnet_id      = aws_subnet.ap-south-1-CICD-public-subnet-2.id
  route_table_id = aws_route_table.ap-south-1-CICDpublicRT.id
}
# create the private route table 

resource "aws_route_table" "ap-south-1-CICDprivateRT" {
  vpc_id = aws_vpc.ap-south-1-CICD.id
  tags = {
    Name = "ap-south-1-CICDprivateRT"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }


}

# create the private route table association

resource "aws_route_table_association" "ap-south-1-CICDprivateRTassociation" {
  subnet_id      = aws_subnet.ap-south-1-CICD-private-subnet.id
  route_table_id = aws_route_table.ap-south-1-CICDprivateRT.id

}

# creating the EIP 
resource "aws_eip" "civpc-eip" {
  tags = {
    Name = "civpc-eip"
  }
}

# creatig the eip and nat association 
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.civpc-eip.id
  subnet_id     = aws_subnet.ap-south-1-CICD-public-subnet.id

  tags = {
    Name = "gw-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ap-south-1-CICD_internetGateway]
}