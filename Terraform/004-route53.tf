#----------------------------------------------------
#                   Route53 Record
#----------------------------------------------------

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "capstone-24-EKS-record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.EKS-ingress-service.status.0.load_balancer.0.ingress.0.hostname]
}

resource "namedotcom_domain_nameservers" "capstone-24-EKS" {
  domain_name = var.domain_name
  nameservers = [
    "${data.aws_route53_zone.hosted_zone.name_servers.0}",
    "${data.aws_route53_zone.hosted_zone.name_servers.1}",
    "${data.aws_route53_zone.hosted_zone.name_servers.2}",
    "${data.aws_route53_zone.hosted_zone.name_servers.3}",
  ]
}