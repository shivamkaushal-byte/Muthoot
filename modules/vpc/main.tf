resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "prod"
  }
}
resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1a"
    tags = {
        Name = "prod-subnet-public-1"
    }
}
resource "aws_subnet" "prod-subnet-private-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1b"
    tags = {
      Name = "prod-subnet-private-1"
   }
}
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "ig-prod"
  }
}
resource "aws_route_table" "prod-route" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }
  tags = {
    Name = "prod-route"
  }
}
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = aws_subnet.prod-subnet-public-1.id
    route_table_id = aws_route_table.prod-route.id
}        
