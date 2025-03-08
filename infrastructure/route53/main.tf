resource "aws_route53_zone" "route_hosted_zone_root" {
  name = var.domain_name
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in var.lnybro_cert : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.route_hosted_zone_root.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = var.lnybro_cert_arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
