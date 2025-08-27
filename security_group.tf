resource "aws_security_group" "allow_SSH_HTTP_HTTPS" {
  name = "SSH-SG"
  description = "Allows SSH from everywheres"
  tags = {
    Name = "SSH-SG"
  }
  vpc_id = aws_vpc.main_vpc.id
}
# Allow SSH Ingress & Egress
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = var.allow_all_ipv4
}
resource "aws_vpc_security_group_egress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.allow_all_ipv4
}
# Allow HTTP Ingress & Egress
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = var.allow_all_ipv4
}
resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  ip_protocol = "-1"
  cidr_ipv4 = var.allow_all_ipv4
}
# Allow HTTPS Ingress & Egress
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
  cidr_ipv4 = var.allow_all_ipv4
}