variable "subnet_id" {
  default = "subnet-0927c1fcfe88a715a"
}
variable "default_CPU_treshold" {
  type = number
  default = 44
}
variable "default_region" {
  default = "eu-central-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "emails" {
  default = ["robaflex77@gmail.com","robapichkhnarashvili@gmail.com"]
}
variable "allow_all_ipv4" {
  default = "0.0.0.0/0"
}
variable "allowed_ports" {
  type = list(number)
  default = [443,80]
}
variable "my_ipv4" {
  default = "212.58.119.49/32"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_1_cidr" {
  default = "10.0.0.0/24"
}