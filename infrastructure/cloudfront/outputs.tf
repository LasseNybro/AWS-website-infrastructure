output cloudfront_distribution_hosted_zone_id {
  value = aws_cloudfront_distribution.website_cdn.hosted_zone_id
}

output cloudfront_distribution_domain_name {
  value = aws_cloudfront_distribution.website_cdn.domain_name
}