# AWS Secrets Manager configuration

# Secret for OpenAI API Key
resource "aws_secretsmanager_secret" "openai_api_key" {
  name        = "${local.name_prefix}-openai-api-key"
  description = "OpenAI API key for remediation script generation"

  # Use default AWS managed key for Secrets Manager
  kms_key_id = "alias/aws/secretsmanager"

  tags = merge(local.common_tags, {
    Name      = "${local.name_prefix}-openai-secret"
    Component = "backend"
  })
}

# Secret version - uses write-only arguments for security
resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id = aws_secretsmanager_secret.openai_api_key.id

  # Use write-only arguments to prevent secret exposure in state/logs
  secret_string_wo = var.openai_api_key

  # Version counter to trigger updates when secret changes
  secret_string_wo_version = 1

  lifecycle {
    # Ignore changes to prevent drift when secret is updated outside Terraform
    ignore_changes = [secret_string_wo, secret_string_wo_version]
  }
}