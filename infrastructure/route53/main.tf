resource "aws_route_53" "route_hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "route_record" {
  zone_id = aws_route53_zone.route_hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.s3_bucket_website_endpoint
    zone_id                = var.s3_bucket_hosted_zone_id
    evaluate_target_health = true
  }
}
