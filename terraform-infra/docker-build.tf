# Docker build and push automation using Terraform Docker provider for ARM64 architecture

# Note: Data sources are defined in providers.tf to avoid duplication

# Local values for Docker build
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # ECR repository URLs
  frontend_ecr_url = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${aws_ecr_repository.frontend.name}"
  backend_ecr_url  = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${aws_ecr_repository.backend.name}"

  # Image tags with timestamp for uniqueness
  image_tag = "latest"
  build_tag = formatdate("YYYY-MM-DD-hhmm", timestamp())
}

# Frontend Docker image build
resource "docker_image" "frontend" {
  name = "${local.frontend_ecr_url}:${local.image_tag}"

  build {
    context    = "../frontend"
    dockerfile = "Dockerfile"
    platform   = "linux/arm64"

    # Build args if needed
    build_args = {
      BUILDPLATFORM = "linux/arm64"
    }
  }

  # Rebuild triggers
  triggers = {
    dockerfile_hash   = filemd5("../frontend/Dockerfile")
    nginx_conf_hash   = filemd5("../frontend/nginx.conf")
    package_json_hash = filemd5("../frontend/package.json")
    build_timestamp   = local.build_tag
  }

  depends_on = [aws_ecr_repository.frontend]
}

# Backend Docker image build
resource "docker_image" "backend" {
  name = "${local.backend_ecr_url}:${local.image_tag}"

  build {
    context    = "../backend"
    dockerfile = "Dockerfile"
    platform   = "linux/arm64"

    # Build args if needed
    build_args = {
      BUILDPLATFORM = "linux/arm64"
    }
  }

  # Rebuild triggers
  triggers = {
    dockerfile_hash   = filemd5("../backend/Dockerfile")
    package_json_hash = filemd5("../backend/package.json")
    build_timestamp   = local.build_tag
  }

  depends_on = [aws_ecr_repository.backend]
}

# Push frontend image to ECR
resource "docker_registry_image" "frontend" {
  name = docker_image.frontend.name

  depends_on = [
    docker_image.frontend,
    aws_ecr_repository.frontend
  ]
}

# Push backend image to ECR
resource "docker_registry_image" "backend" {
  name = docker_image.backend.name

  depends_on = [
    docker_image.backend,
    aws_ecr_repository.backend
  ]
}

# Output the image URIs for use in ECS task definitions
output "frontend_image_uri" {
  description = "Frontend Docker image URI in ECR"
  value       = docker_registry_image.frontend.name
  depends_on  = [docker_registry_image.frontend]
}

output "backend_image_uri" {
  description = "Backend Docker image URI in ECR"
  value       = docker_registry_image.backend.name
  depends_on  = [docker_registry_image.backend]
}