resource "aws_acm_certificate" "main" {
  domain_name       = "${var.sub_domain}.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}