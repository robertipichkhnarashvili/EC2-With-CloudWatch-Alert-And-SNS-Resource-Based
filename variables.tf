variable "subnet_id" {
  default = "subnet-0927c1fcfe88a715a"
}
variable "default_CPU_treshold" {
  default = 80
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