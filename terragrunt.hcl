locals {
    env             = path_relative_to_include()
    terraform_token = get_env("TERRAFORM_TOKEN") # Terraform cloud token placed in GitHub Secret, 
                                                 # it will fetch when terragrunt init executes from self-hosted GHA Runers.
 }
# In order to create unique workspace in terraform cloud I have used local.env for workspace name #
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "remote" {
  hostname = "app.terraform.io"
  organization = "nexon-backend"
  token =  "${local.terraform_token}"
    workspaces {
      name = "nexon-${replace(local.env, "/", "-")}"
    }
  }
}
EOF
}
