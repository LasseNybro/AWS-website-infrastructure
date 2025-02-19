output hosted_zone_id {
  value = aws_s3_bucket.bucket.hosted_zone_id
}

output website_endpoint {
  value = aws_s3_bucket_website_configuration.bucket_website_configuration.website_endpoint
}
