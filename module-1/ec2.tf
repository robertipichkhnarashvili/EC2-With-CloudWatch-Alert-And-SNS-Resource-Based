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
    host = self.host_id
    private_key = file("${path.root}/private_key.pem")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install stress -y",
      "sudostress --cpu 8 --timeout 800"
    ]
  }
}
variable "subnet_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "ami" {}
variable "user_data" {}
variable "vpc_security_group_ids" {}
output "instance_id" {
  value = aws_instance.monitored_ec2[*].id
}