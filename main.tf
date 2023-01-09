# Synthetic test from AWS regions Terraform Code
resource "datadog_synthetics_test" "site_test" {
  type    = "api"
  subtype = "http"
  request_definition {
    method = "GET"
    url    = var.website-name
  }
  request_headers = {
    Content-Type   = "application/json"
    Authentication = "Token: 1234566789"
  }
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  locations = var.aws_regions
  options_list {
    tick_every = var.testing_frequency

    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 120
    }
  }
  name    = var.website-name
  message = "Notify @${var.slack_channel_name}"
  tags    = "Name:test-site"

  status = "live"
}
