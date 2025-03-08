terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
  }
}

locals {
  domain_name = "lnybro.dk"
}

module "static_website" {
  source = "./s3"

  domain_name = local.domain_name
}

module "https_cert" {
  source = "./https-cert"

  domain_name = local.domain_name
}

module "route53" {
  source = "./route53"

  domain_name     = local.domain_name
  lnybro_cert_arn = module.https_cert.lnybro_cert_arn
  depends_on      = [module.https_cert]
}

module "api_gateway" {
  source = "./api-gateway"

  # get_lambda_invoke_arn   = 
  # post_lambda_invokde_arn = 
}

module "cloudfront" {
  source = "./cloudfront"

  domain_name           = local.domain_name
  s3_website_endpoint   = module.static_website.website_endpoint
  s3_bucket_id          = module.static_website.s3_bucket_id
  https_certificate_arn = module.https_cert.lnybro_cert_arn
  depends_on            = [module.https_cert]
}

module "route53_alias" {
  source = "./route53-alias"

  domain_name                            = local.domain_name
  route53_zone_id                        = module.route53.route53_zone_id
  cloudfront_distribution_domain_name    = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_distribution_hosted_zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
}