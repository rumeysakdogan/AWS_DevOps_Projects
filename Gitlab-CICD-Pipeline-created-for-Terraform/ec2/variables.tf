# --- ec2/variables.tf

variable "webserver_type" {
  type    = string
  default = "t2.micro"
}

variable "web_sg" {}
#variable "pt_sg" {}
#variable "pt_sn" {}
variable "pub_subnets" {}
variable "key" {}