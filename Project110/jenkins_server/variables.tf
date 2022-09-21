variable "mykey" {
  default = "FirstKey"
}
variable "myami" {
  default = "ami-0022f774911c1d690"
}
variable "instancetype" {
  default = "t3a.medium"
}
variable "tag" {
  default = "Jenkins_Server"
}
variable "jenkins-sg" {
  default = "jenkins-server-sec-gr-208"
}