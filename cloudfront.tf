# --------------------------------------------------------------------
# CloudFront Distribution — fronts the ALB with HTTPS + ACM
# --------------------------------------------------------------------

locals {
  acm_certificate_arn = "arn:aws:acm:us-east-1:686699774218:certificate/26f7be78-08f7-4764-8a69-0fd528c263dd" 
  domain_name         = "ironlabs.online"
  app_subdomain       = "resilient-web-joao.ironlabs.online"
}

# --------------------------------------------------------------------
# CloudFront Distribution
# --------------------------------------------------------------------

resource "aws_cloudfront_distribution" "web" {
  enabled = true
  comment = "${var.project_name} CloudFront Distribution"
  aliases = [local.app_subdomain]

  # Origin — points to the ALB
  origin {
    domain_name = aws_lb.web.dns_name
    origin_id   = "alb-${var.project_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # ALB is HTTP, CloudFront handles HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Default cache behavior
  default_cache_behavior {
    target_origin_id       = "alb-${var.project_name}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewer

    compress = true
  }

  # HTTPS certificate
  viewer_certificate {
    acm_certificate_arn      = local.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.tags
}

# --------------------------------------------------------------------
# Route 53 — point subdomain to CloudFront
# --------------------------------------------------------------------

data "aws_route53_zone" "main" {
  name         = local.domain_name
  private_zone = false
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.app_subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.web.domain_name
    zone_id                = aws_cloudfront_distribution.web.hosted_zone_id
    evaluate_target_health = false
  }
}

# --------------------------------------------------------------------
# Outputs
# --------------------------------------------------------------------

output "cloudfront_domain" {
  description = "CloudFront distribution domain"
  value       = aws_cloudfront_distribution.web.domain_name
}

output "cloudfront_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.web.id
}

output "app_url" {
  description = "Your application URL"
  value       = "https://${local.app_subdomain}"
}
