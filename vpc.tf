resource "aws_vpc" "main" {
  cidr_block = "10.10.4.0/22"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "davis test vpc"
  }
  

}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1a"
  

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "second" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true


  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "myIgw"{
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table"{
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIgw.id
    }
}

resource "aws_route_table_association" "public_route_table_association"{
    subnet_id = aws_subnet.main.id
    route_table_id = aws_route_table.public_route_table.id
}