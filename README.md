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
https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/

# Pre-Request to Deployment

1. Create an EC2 Instance on your AWS Account and configure GitHub Access Self Hosted Runner
 <img width="291" alt="image" src="https://user-images.githubusercontent.com/36160986/188068773-62e7145d-22b3-480f-9558-9d5cf295b897.png">


2. IAM Role for Instance Profile with switch account access. Create role with enough permission to deploy your services
```
https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-iam-instance-profile.html
```
3. Install AWS CLI on EC2 and configure profile to deploy on multi account
```
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-cli.html
```

# Deployment Process
1. We have GitHub Workflow files located in “.github/workflow” directory
2. Create a feature branch and commit your changes and it will 1st run Terrafrom Validation, once merge with Dev it will automatically trigger the pipeline and deploy the dev environment.
3. Once dev branch merged with main branch you can manually trigger the production pipeline deployment will need a review and approve from your reviewer which already added in GHA Environment.
1. <img width="452" alt="image" src="https://user-images.githubusercontent.com/36160986/188068810-d7bf4b5e-2d5e-40ed-8f5b-ba5145b007d2.png">

2. <img width="452" alt="image" src="https://user-images.githubusercontent.com/36160986/188068843-26346343-d60a-4bcf-b92c-54ef7b67b3fd.png">

3. <img width="452" alt="image" src="https://user-images.githubusercontent.com/36160986/188068881-3fe2f6df-b229-4805-a388-88c26070b265.png">


