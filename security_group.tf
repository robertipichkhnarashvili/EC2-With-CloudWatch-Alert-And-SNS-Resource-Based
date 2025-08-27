resource "aws_security_group" "allow_SSH_HTTP_HTTPS" {
  name = "SSH-SG"
  description = "Allows SSH from everywheres"
  tags = {
    Name = "SSH-SG"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ingress_ssh" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  cidr_ipv4 = var.allow_all_ipv4
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_egress_all" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  ip_protocol = "-1"
  cidr_ipv4 = var.allow_all_ipv4
}
resource "aws_vpc_security_group_ingress_rule" "allow_allowed_ports" {
  security_group_id = aws_security_group.allow_SSH_HTTP_HTTPS.id
  cidr_ipv4 = var.allow_all_ipv4
  for_each = {for port in var.allowed_ports : port => port}
  from_port = tonumber(each.value)
  ip_protocol = "tcp"
  to_port = tonumber(each.value)
}