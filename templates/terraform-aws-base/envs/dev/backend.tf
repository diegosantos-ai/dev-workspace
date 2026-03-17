terraform {
  backend "s3" {
    bucket       = "projeto-02-dev-tfstate"
    key          = "projeto-02/dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}