provider "aws" {
  region = var.aws_region

  # Tags padrão aplicadas a todos os recursos suportados pelo provider.
  # A tag Name será definida individualmente em cada recurso.
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
    }
  }
}