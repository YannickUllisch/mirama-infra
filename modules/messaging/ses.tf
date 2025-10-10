// General SES setup and verification
resource "aws_ses_domain_identity" "main" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.main.id
  name    = aws_ses_domain_identity.main.verification_token
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.main.verification_token]
}

// DKIM
resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = data.aws_route53_zone.main.id
  name    = "${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}._domainkey.${var.domain_name}"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

// EMAIL From and SPF setup
resource "aws_ses_domain_mail_from" "main" {
  domain                 = var.domain_name
  mail_from_domain       = "donotreply.${var.domain_name}"
  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "spf" {
  zone_id = data.aws_route53_zone.main.id
  name    = "donotreply.${var.domain_name}"
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "mail_from_mx" {
  zone_id = data.aws_route53_zone.main.id
  name    = "mail.${var.domain_name}"
  type    = "MX"
  ttl     = 600
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]
}
