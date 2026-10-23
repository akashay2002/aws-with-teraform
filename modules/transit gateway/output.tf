output "mumbai_vpc_id" {
  value = aws_vpc.vpc_mumbai.id
}

output "singapore_vpc_id" {
  value = aws_vpc.vpc_singapore.id
}

output "virginia_vpc_id" {
  value = aws_vpc.vpc_virginia.id
}
output "mumbai_public_subnet_ids" {
  description = "IDs of Mumbai public subnets"
  value       = aws_subnet.mumbai_vpc_Public_subnets[*].id
}
output "singapure_public_subnet_ids" {
  description = "IDs of Singapure public subnets"
  value       = aws_subnet.singapore_vpc_Public_subnets[*].id
}
output "virginia_public_subnet_ids" {
  description = "IDs of virginia public subnets"
  value       = aws_subnet.virginia_vpc_Public_subnets[*].id
}
# output "virginia_public_ips" {
#   value       = aws_instance.virginia_vpc_instance[*].public_ip
# }
# output "mumbai_public_ips" {
#   value = aws_instance.mumbai_vpc_instance[*].public_ip
# }
# output "singapore_public_ips" {
#   value = aws_instance.singapore_vpc_instance[*].public_ip
# }