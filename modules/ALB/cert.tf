# The entire section create a certiface, public zone, and validate the certificate using DNS method

# Create hosting zone
resource "aws_route53_zone" "jmn_hosted_zone" {
  name = "constanet.wip.la"
}

# Create the certificate using a wildcard for all the domains created in somdev.ga
resource "aws_acm_certificate" "jmn_cert" {
  domain_name       = "*.constanet.wip.la"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# calling the hosted zone
data "aws_route53_zone" "jmn_hosted_zone" {
  name         = "constanet.wip.la"
  private_zone = false
  depends_on = [aws_route53_zone.jmn_hosted_zone]
}

# selecting validation method
resource "aws_route53_record" "jmn_record" {
  for_each = {
    for dvo in aws_acm_certificate.jmn_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.jmn_hosted_zone.zone_id
}

# validate the certificate through DNS method
resource "aws_acm_certificate_validation" "jmn_validation" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.jmn_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.jmn_record : record.fqdn]
}

# create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.jmn_hosted_zone.zone_id
  name    = "tooling.constanet.wip.la"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}

# create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.jmn_hosted_zone.zone_id
  name    = "wordpress.constanet.wip.la"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}