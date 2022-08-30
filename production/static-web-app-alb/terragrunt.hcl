include "root" {
  path = find_in_parent_folders()
}

locals {
    read_environment  = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
    environment       = local.read_environment.locals.env
    region            = local.read_environment.locals.region
    aws_profile       = "nexon-prod"
    environment_owner = "rgangaderan@gmail.com"
    common_tags       =  {
      Stage           = "${local.environment}",
      Name            = "nexon-${local.environment}",
      Technical_Owner = "${local.environment_owner}"
  }
}


dependency "network" {
  config_path = "${path_relative_from_include()}/production/network"
}

terraform {
  source =  "git@github.com:rgangaderan/nexon-terraform-business-module.git//static-web-app-alb?ref=v3.0.3"
}

inputs = {
  network        = dependency.network.outputs
  tag_info       = local.common_tags
  name           = "nexon"
  region         = local.region
  stage          = local.environment
  allowed_ips    = ["0.0.0.0/0"]
  vpc_id         = dependency.network.outputs.vpc_id
  profile        = local.aws_profile
  cidr           = dependency.network.outputs.vpc_cidr_block
  vpc_cidr_block = [dependency.network.outputs.vpc_cidr_block]
  subnet_id      = dependency.network.outputs.private_subnet_ids[0]
  key_name       = "mypuc"
  instance_count = 2
  tag_info       = local.common_tags

  vpc_zone_identifier = dependency.network.outputs.private_subnet_ids

  instance_type = {
    development = "t2.micro"
    staging     = "t2.micro"
    production  = "t2.micro"
  }
}
