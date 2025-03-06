variable domain_name {
  type = string
}

variable "lnybro_cert" {
  type = object({
    arn = string
    domain_validation_options = list(object({
      name = string
      type = string
      value = string
    }))
  })
}