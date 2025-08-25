# IAM roles and policies for ECS services

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.name_prefix}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Policy for ECS task execution role to access Secrets Manager
resource "aws_iam_policy" "ecs_execution_secrets_policy" {
  name        = "${local.name_prefix}-ecs-execution-secrets-policy"
  description = "Policy for ECS task execution role to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.openai_api_key.arn
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${var.aws_region}.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach secrets policy to ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_execution_secrets_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_secrets_policy.arn
}

# Backend Task Role (for runtime AWS service access)
resource "aws_iam_role" "backend_task_role" {
  name = "${local.name_prefix}-backend-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Policy for backend to access Secrets Manager
resource "aws_iam_policy" "backend_secrets_policy" {
  name        = "${local.name_prefix}-backend-secrets-policy"
  description = "Policy for backend service to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.openai_api_key.arn
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${var.aws_region}.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach secrets policy to backend task role
resource "aws_iam_role_policy_attachment" "backend_secrets_policy_attachment" {
  role       = aws_iam_role.backend_task_role.name
  policy_arn = aws_iam_policy.backend_secrets_policy.arn
}

# Policy for backend to access AWS Config Service
resource "aws_iam_policy" "backend_config_policy" {
  name        = "${local.name_prefix}-backend-config-policy"
  description = "Policy for backend service to access AWS Config Service"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "config:DescribeConfigRules",
          "config:DescribeComplianceByConfigRule",
          "config:GetComplianceDetailsByConfigRule",
          "config:DescribeConfigurationRecorders",
          "config:DescribeDeliveryChannels"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.common_tags
}

# Attach config policy to backend task role
resource "aws_iam_role_policy_attachment" "backend_config_policy_attachment" {
  role       = aws_iam_role.backend_task_role.name
  policy_arn = aws_iam_policy.backend_config_policy.arn
}