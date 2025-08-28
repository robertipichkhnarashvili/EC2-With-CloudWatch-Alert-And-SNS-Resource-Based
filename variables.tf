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

# Configure this variables set values to meet your requirements
variable "emails" {
  type = set(string)
  default = ["sumemail1@example.com","sumemail2@example.com"]
}
variable "allow_all_ipv4" {
  default = "0.0.0.0/0"
}
variable "allowed_ports" {
  type = list(number)
  default = [443,80]
}

# Specify your public ipv4 address
variable "my_ipv4" {
  type = string
  default = ""
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_1_cidr" {
  default = "10.0.0.0/24"
}