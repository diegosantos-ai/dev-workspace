#!/bin/bash
# Adiciona required_providers no ovh-terraform/envs/dev/provider.tf
sed -i '/provider "ovh" {/i terraform {\n  required_version = ">= 1.0.0"\n  required_providers {\n    ovh = {\n      source  = "ovh/ovh"\n      version = ">= 0.33.0"\n    }\n  }\n}\n' ovh-terraform/envs/dev/provider.tf || true

# Edita temporario (para arrumar erros na env aws base)
sed -i 's/terraform {/terraform {\n  required_version = ">= 1.5.0"/g' templates/terraform-aws-base/envs/dev/backend.tf || true
sed -i '/provider "aws" {/i terraform {\n  required_version = ">= 1.5.0"\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = "~> 5.0"\n    }\n  }\n}\n' templates/terraform-aws-base/envs/dev/provider.tf || true

# Remove unused dynamodb_table_name
sed -i '/dynamodb_table_name =/d' templates/terraform-aws-base/infra/backend/main.tf || true

# Adiciona versioning nas modules
for mod in compute network security; do
  sed -i '1i terraform {\n  required_version = ">= 1.5.0"\n  required_providers {\n    aws = {\n      source  = "hashicorp/aws"\n      version = ">= 5.0"\n    }\n  }\n}\n' templates/terraform-aws-base/modules/$mod/main.tf || true
done
