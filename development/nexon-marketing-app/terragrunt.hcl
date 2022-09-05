include "root" {
  path = find_in_parent_folders()
}

locals {
    read_environment  = read_terragrunt_config(find_in_parent_folders("environment.hcl")) # Deployment environment and region defined in environment.hcl
    environment       = local.read_environment.locals.env
    region            = local.read_environment.locals.region
    aws_profile        = "nexon-dev"
    environment_owner = "rgangaderan@gmail.com"
    common_tags       =  {
      "Stage"           = "${local.environment}",
      "Name"            = "nexon-${local.environment}",
      "Technical_Owner" = "${local.environment_owner}"
  }
}

dependency "network" {
  config_path = "${path_relative_from_include()}/development/network"
}

terraform {
  source = "git@github.com:rgangaderan/nexon-terraform-business-module.git//nexon-marketing?ref=v4.1.0"
}

inputs = {
  network        = dependency.network.outputs
  profile        = local.aws_profile
  tag_info       = local.common_tags
  region         = local.region
  stage          = local.environment
  private_cidr   = [dependency.network.outputs.private_cidr]
  name           = "nexon"
  tag_info       = local.common_tags
  allowed_ips    = ["0.0.0.0/0"]
  type           = "ip"

  private_subnet_ids = dependency.network.outputs.private_subnet_ids

  db                   = yamldecode(file("db-configurations.yml"))
  ecs_configuration    = yamldecode(file("ecs-configuration.yml"))
  environment          = [yamldecode(file("ecs-configuration.yml"))]
  secrets               = [
    {
      name  = "string_var",
      valueFrom = "arn:aws:ssm:us-east-1:126609036647:parameter/docker/docker_user_name"
    }
  ]
  assign_public_ip     = false
  subnet_ids           = dependency.network.outputs.private_subnet_ids
  account_ids          = ["126609036647","911149727616"]

  }
