resource "aws_route53_zone" "akashy_zone" {
  name = var.domain_name
}