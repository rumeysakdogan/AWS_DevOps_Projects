 #--- vpc/variables.tf

variable "vpc_cidr" {
  type = string
}

variable "pb_cidrs" {
  type = list(any)
}

variable "ext_ip" {
  type = string
}