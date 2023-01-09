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
  tags    = var.tags

  status = "live"
}


# Dashboard Terraform code
resource "datadog_dashboard" "site_monitor_dashboard" {
  title        = "Website Monitoring Dashboard"
  description  = "Website Monitoring Dashboard created using the Datadog provider in Terraform"
  layout_type  = "ordered"
  is_read_only = true

    widget {
        manage_status_definition {
        color_preference    = "text"
        display_format      = "countsAndList"
        hide_zero_counts    = true
        query               = "tag:(websiteName:${var.website-name}"
        show_last_triggered = false
        sort                = "status,asc"
        summary_type        = "monitors"
        title               = "Website Monitor"
        title_size          = 16
        title_align         = "left"
        }
        widget_layout {
        height = var.widget_layout
        width  = var.widget_layout
        x      = 0
        y      = 0
        }
    }
}

