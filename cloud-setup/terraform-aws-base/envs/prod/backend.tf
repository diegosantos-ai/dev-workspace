terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    # Altere para seu bucket de producao
    bucket       = "projeto-02-prod-tfstate"
    key          = "projeto-02/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
