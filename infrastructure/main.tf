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
    aws = aws
  }

  domain_name = local.domain_name
}

module "https_cert" {
  source = "./https-cert"
  providers = {
    aws = aws.us_east_1
  }

  domain_name = local.domain_name
}

module "route53" {
  source = "./route53"
  providers = {
    aws = aws.us_east_1
  }

  domain_name     = local.domain_name
  lnybro_cert_arn = module.https_cert.lnybro_cert_arn
  cloudfront_distribution_domain_name    = module.cloudfront.cloudfront_distribution_domain_name
  cloudfront_distribution_hosted_zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
  depends_on      = [module.https_cert]
}

module "api_gateway" {
  source = "./api-gateway"
  providers = {
    aws = aws
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
  https_certificate_arn = module.https_cert.lnybro_cert_arn
  depends_on            = [module.https_cert]
}
