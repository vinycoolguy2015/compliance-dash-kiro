variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name for resource naming"
  type        = string
  default     = "nist-dashboard"
}

variable "openai_api_key" {
  description = "OpenAI API key for remediation script generation"
  type        = string
  sensitive   = true
}
