resource "aws_route53_record" "route_record_root" {
  zone_id = var.s3_bucket_hosted_zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route_record_www" {
  zone_id = var.s3_bucket_hosted_zone_id
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
