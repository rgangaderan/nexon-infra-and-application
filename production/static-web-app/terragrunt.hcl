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
  config_path = "${path_relative_from_include()}/development/network"
}

terraform {
  source = "git@github.com:rgangaderan/nexon-terraform-business-module.git//static-web-app?ref=v2.0.3.2"
}

inputs = {
  profile        = local.aws_profile
  cidr           = dependency.network.outputs.vpc_cidr_block
  subnet_id      = dependency.network.outputs.private_subnet_ids[0]
  vpc_id         = dependency.network.outputs.vpc_id
  vpc_cidr_block = [dependency.network.outputs.vpc_cidr_block]
  key_name       = "mypuc"
  region         = local.region
  stage          = local.environment
  name           = "nexon"
  volume_size    = 20
  volume_type    = "gp2"
  instance_coun  = 1
  max_size       = 5
  min_size       = 2
  subnets        = dependency.network.outputs.public_subnet_ids
  tag_info       = local.common_tags

  vpc_zone_identifier = dependency.network.outputs.private_subnet_ids


  instance_type = {
    development = "t2.micro"
    staging     = "t2.micro"
    production  = "t3.micro"
  }
}
