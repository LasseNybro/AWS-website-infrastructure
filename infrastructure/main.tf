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

provider "aws" {
  alias  = "eu_north_1"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

locals {
  domain_name = "lnybro.dk"
}

module "static_website" {
  source = "./s3"
  providers = {
    aws = aws.eu_north_1
  }

  domain_name = local.domain_name
}

module "route53" {
  source = "./route53"
  providers = {
    aws = aws.us_east_1
  }

  domain_name                            = local.domain_name
}

module "api_gateway" {
  source = "./api-gateway"
  providers = {
    aws = aws.eu_north_1
  }

  # get_lambda_invoke_arn   = 
  # post_lambda_invokde_arn = 
}

module "cloudfront" {
  source = "./cloudfront"
  providers = {
    aws = aws.us_east_1
  }

  domain_name           = local.domain_name
  s3_website_endpoint   = module.static_website.website_endpoint
  s3_bucket_id          = module.static_website.s3_bucket_id
  https_certificate_arn = module.route53.https_cert_arn
  depends_on            = [module.route53]
}

module "route53_alias" {
  source = "./route53-alias"
  providers = {
    aws = aws.us_east_1
  }

  domain_name                            = local.domain_name
  route53_zone_id                        = module.route53.route53_zone_id
  cloudfront_distribution_domain_name    = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_distribution_hosted_zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
}
