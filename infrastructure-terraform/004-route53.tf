#----------------------------------------------------
#                   Route53 Record
#----------------------------------------------------

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "capstone-24-record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300

  records = [
    aws_elastic_beanstalk_environment.capstone-24-app-env.cname
  ]
}


resource "namedotcom_domain_nameservers" "capstone-24" {
  domain_name = var.domain_name
  nameservers = [
    "${data.aws_route53_zone.hosted_zone.name_servers.0}",
    "${data.aws_route53_zone.hosted_zone.name_servers.1}",
    "${data.aws_route53_zone.hosted_zone.name_servers.2}",
    "${data.aws_route53_zone.hosted_zone.name_servers.3}",
  ]
}