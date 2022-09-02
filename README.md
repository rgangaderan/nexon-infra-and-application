# nexon-infra-and-application
nexon-infra-and-application

Since we use terragrunt as our main deployment tool we are not passing any values in business layer and the tech layer.
https://github.com/rgangaderan/nexon-terraform-tech-module
https://github.com/rgangaderan/nexon-terraform-business-module

Terragrunt will help to keep our Terraform code dry, and it helps to keep different environment such as Development, Production or QA
Using the Terragrunt structure we can simply configure our backend using one root module instead hardcoded values and backend configuration for all our resources.

```
locals {
    env             = path_relative_to_include()
    terraform_token = get_env("TERRAFORM_TOKEN") # Terraform cloud token placed in GitHub Secret, 
                                                 # it will fetch when terragrunt init executes from self-hosted GHA Runers.
 }
# In order to create unique workspace in toerrafrom cloud I have used local.env for workspace name #
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
```

In the below example you can see workspaces name in line number 27 has name attribute will calling as which is defined in line number 11 local.env, so when ever you run Terragrunt in specific directory
like development/network/ terragrun.hcl it will take the 
path name = "development/network/" and replace "/" with "-" then join with "nexon" (Since Terraform Cloud does not allow "/" as workspace name we need to replace that with something else, so I used "-")

so, the workspace name could looks like "nexon-development-network". this same approach will use for all the backend.

more details you can find in Terragrun Docs.
