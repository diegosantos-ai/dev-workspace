module "network" {
  source = "../../modules/network"

  project_name       = var.project_name
  environment        = var.environment
  owner              = var.owner
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  public_subnet_az   = var.public_subnet_az
}

module "security" {
  source = "../../modules/security"

  project_name     = var.project_name
  environment      = var.environment
  owner            = var.owner
  ssh_allowed_cidr = var.ssh_allowed_cidr
  vpc_id           = module.network.vpc_id
}

module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  owner                 = var.owner
  instance_type         = var.instance_type
  key_pair_name         = var.key_pair_name
  public_subnet_id      = module.network.public_subnet_id
  web_security_group_id = module.security.web_security_group_id
}
