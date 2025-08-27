resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-tf-vpc"
  }
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_1_cidr
  map_public_ip_on_launch = true 
  availability_zone = "eu-central-1a"
  tags = {
    Name = "public-subnet-1"
  }
}
