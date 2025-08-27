resource "aws_instance" "monitored_ec2" {
  ami = var.ami
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = var.user_data
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = var.vpc_security_group_ids
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = var.private_key
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install stress -y",
      "sudo stress--cpu 8 --timeout 800 >/dev/null 2>&1 &"
    ]
  }
}
variable "subnet_id" {}
variable "private_key" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "ami" {}
variable "user_data" {}
variable "vpc_security_group_ids" {}
output "instance_id" {
  value = aws_instance.monitored_ec2[*].id
}