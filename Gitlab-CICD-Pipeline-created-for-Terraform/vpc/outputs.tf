# ---- vpc/outputs.tf

output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "web_sg" {
  value = aws_security_group.webSecGrp.id
}

output "pub_subnets" {
  value = aws_subnet.public_subnets[*].id
}