output "lnybro_cert_arn" {
  value = aws_acm_certificate.https_cert.arn
}

output "lnybro_cert" {
  value = aws_acm_certificate.https_cert
}