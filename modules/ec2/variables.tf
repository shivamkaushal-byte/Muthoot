variable "vpc_id"{
  type = string
}
variable "subnet_id"{
  type = string
}
variable "privatekey"{
  default = "developer"
}
variable "ami_id" {
   default = "ami-0499632f10efc5a62"
}
variable "instance_type" {
   default = "t2.micro"
}
