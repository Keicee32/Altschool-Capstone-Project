# #----------------------------------------------------
# #                   Route53 Record
# #----------------------------------------------------

# resource "aws_acm_certificate" "capstone-24-ssl-cert" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"
# }

# data "aws_route53_zone" "capstone-24-hosted-zone" {
#   name         = var.domain_name
#   private_zone = false
# }

# resource "aws_route53_record" "capstone-24-record" {
#   for_each = {
#     for dvo in aws_acm_certificate.capstone-24-ssl-cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.capstone-24-hosted-zone.zone_id
# }

# resource "aws_acm_certificate_validation" "capstone-24-cert-validation" {
#   certificate_arn         = aws_acm_certificate.capstone-24-ssl-cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.capstone-24-record : record.fqdn]
# }

# resource "namedotcom_domain_nameservers" "capstone-24" {
#   domain_name = var.domain_name
#   nameservers = [
#     "${data.aws_route53_zone.capstone-24-hosted-zone.name_servers.0}",
#     "${data.aws_route53_zone.capstone-24-hosted-zone.name_servers.1}",
#     "${data.aws_route53_zone.capstone-24-hosted-zone.name_servers.2}",
#     "${data.aws_route53_zone.capstone-24-hosted-zone.name_servers.3}",
#   ]
# }