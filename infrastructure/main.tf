terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
  }
}

module "static_website" {
  source = "./s3"
}

module "route53" {
  source = "./route53"

  domain_name                = "lnybro.dk"
  s3_bucket_hosted_zone_id   = module.static_website.hosted_zone_id
  s3_bucket_website_domain = module.static_website.website_domain
}

module "api_gateway" {
  source = "./api-gateway"

  # get_lambda_invoke_arn   = 
  # post_lambda_invokde_arn = 
}
