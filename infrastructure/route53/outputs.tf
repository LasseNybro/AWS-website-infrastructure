output "https_cert_arn" {
  value = aws_acm_certificate.https_cert.arn
}

output "route53_zone_id" {
  value = aws_route53_zone.route_hosted_zone_root.zone_id
}