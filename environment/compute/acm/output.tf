output "certificate_arn" {

  value = module.acm.certificate_arn
}

output "certificate_domain_name" {

  value = module.acm.certificate_domain_name
}

output "certificate_status" {

  value = module.acm.certificate_status
}

output "alb_id" {

  value = module.alb.alb_id
}

output "alb_zone_id" {

  value = module.alb.alb_zone_id
}