resource "aws_route53_zone" "route_hosted_zone_root" {
  name = var.domain_name
}

resource "aws_route53_record" "route_record_root" {
  zone_id = aws_route53_zone.route_hosted_zone_root.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.s3_bucket_website_endpoint
    zone_id                = var.s3_bucket_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "route_hosted_zone_www" {
  name = "www.${var.domain_name}"
}

resource "aws_route53_record" "route_record_www" {
  zone_id = aws_route53_zone.route_hosted_zone_www.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.s3_bucket_website_endpoint
    zone_id                = var.s3_bucket_hosted_zone_id
    evaluate_target_health = true
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
