# Main Terraform configuration for NIST Compliance Dashboard
# This file orchestrates the complete infrastructure deployment

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# Local values for common configurations
locals {
  name_prefix = "${var.app_name}-${var.environment}"

  common_tags = {
    Environment = var.environment
    Application = var.app_name
    ManagedBy   = "terraform"
  }

  # Select first 2 AZs for high availability
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}