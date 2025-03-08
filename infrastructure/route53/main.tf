terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_acm_certificate" "lnybro_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

resource "aws_route53_zone" "route_hosted_zone_root" {
  name = var.domain_name
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in try(data.aws_acm_certificate.lnybro_cert.domain_validation_options, []) : dvo.domain_name => {
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

resource "aws_route53_record" "route_record_root" {
  zone_id = aws_route53_zone.route_hosted_zone_root.id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route_record_www" {
  zone_id = aws_route53_zone.route_hosted_zone_root.id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

/*resource "aws_route53_zone" "route_hosted_zone" {
  name = "api.${var.domain_name}"
}

resource "aws_route53_record" "route_record" {
  zone_id = aws_route53_zone.route_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.
    zone_id                = var.s3_bucket_hosted_zone_id
    evaluate_target_health = true
  }
}*/
