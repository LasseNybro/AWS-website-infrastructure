variable domain_name {
  type = string
}

variable "domain_validation_options" {
  type = list(object({
      resource_record_name = string
      resource_record_type = string
      resource_record_value = string
  }))
}

variable lnybro_cert_arn {
  type = string
}