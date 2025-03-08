terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_acm_certificate" "https_cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "route_hosted_zone_root" {
  name = var.domain_name
}

resource "aws_route53_record" "cert" {
  name  = aws_acm_certificate.https_cert.domain_validation_options.0.resource_record_name
  type  = aws_acm_certificate.https_cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.route_hosted_zone_root.zone_id
  records = [aws_acm_certificate.https_cert.domain_validation_options.0.resource_record_value, aws_acm_certificate.https_cert.domain_validation_options.1.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.https_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}
