include "root" {
  path = find_in_parent_folders()
}

locals {
    read_environment  = read_terragrunt_config(find_in_parent_folders("environment.hcl")) # Deployment environment and region defined in environment.hcl
    environment       = local.read_environment.locals.env
    region            = local.read_environment.locals.region
    aws_prfile        = "nexon-prod"
    environment_owner = "rgangaderan@gmail.com"
    common_tags       =  {
      "Stage"           = "${local.environment}",
      "Name"            = "nexon-${local.environment}",
      "Technical_Owner" = "${local.environment_owner}"
  }
}

terraform {
  source = "git@github.com:rgangaderan/nexon-terraform-business-module.git//management-network?ref=v2.0.3.2"
}

inputs = {
  aws_profile         = local.aws_prfile
  region              = local.region
  cidr                = "10.0.0.0/16"
  max_azs             = 3
  single_nat_gateway  = true
  az_limit            = 6
  cidr_num_bits       = 6
  stage               = local.environment
  name                = "nexon"
  tag_info            = local.common_tags 
}
