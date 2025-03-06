output https_certificate_arn {
  value = aws_acm_certificate.lnybro_cert.arn
}

output route53_zone_id {
  value = aws_route53_zone.route_hosted_zone_root.zone_id
}