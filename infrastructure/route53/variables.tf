variable domain_name {
  type = string
}

variable lnybro_cert_arn {
  type = string
}

variable lnybro_cert {
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}