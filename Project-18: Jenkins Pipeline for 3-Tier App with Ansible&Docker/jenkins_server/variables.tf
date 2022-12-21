variable "mykey" {
  default = "FirstKey"
}
variable "myami" {
  default = "ami-0b5eea76982371e91" #Latest AmznLinux2 ami
}
variable "instancetype" {
  default = "t3a.medium"
}
variable "tag" {
  default = "Jenkins_Server"
}
variable "jenkins-sg" {
  default = "JenkinsSecGrp"
}