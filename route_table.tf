resource "aws_route_table" "table_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "public-route"
  }
}
resource "aws_route_table_association" "public_association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.table_public.id
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "my-main_IGW"
  }
}
