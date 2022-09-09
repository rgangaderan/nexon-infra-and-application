# Infra-and-Application

Since we use terragrunt as our main deployment tool we are only passing needed (which will not change!!!!) values in business layer and no default variables for tech layer.

```
https://github.com/rgangaderan/nexon-terraform-tech-module
https://github.com/rgangaderan/nexon-terraform-business-module
```

- Terragrunt will help to keep our Terraform code dry, and it helps to keep different environment such as Development, Production or QA
Using the Terragrunt directory structure we can simply configure our backend using one root module instead hardcoded values and backend configuration for all our resources.

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

- In the above example you can see workspaces name in line number 27 has "name" attribute will get the values from local.env which is defined in line number 11, so, when ever you run Terragrunt in specific directory. such as development/network/ terragrun.hcl it will take the path name = "development/network/" and replace "/" with "-" then join with "nexon" (Since Terraform Cloud does not allow "/" as workspace name we need to replace that with something else, so I used "-"). So, the workspace name could looks like "nexon-development-network". this same approach will use for all the backend.

For more details you can find in Terragrun Docs.
```
https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/
```
## Prerequisites / Setup Required

1. Create an EC2 Instance on your AWS Account and configure GitHub Access Self Hosted Runner

<img width="785" alt="image" src="https://user-images.githubusercontent.com/41107404/189355806-cf853e48-dde6-4a6d-bc16-c225865f6ff3.png">



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
2. Create a feature branch and commit your changes, once merge with Dev it will automatically trigger the pipeline and deploy the dev environment.
3. Once dev branch merged with main branch you can manually trigger the production pipeline deployment will need a review and approve from your reviewer which already added in GHA Environment.

- <img width="1283" alt="image" src="https://user-images.githubusercontent.com/41107404/189356049-29f14b16-e07f-4592-ae8c-246e1c234649.png">
- <img width="1292" alt="image" src="https://user-images.githubusercontent.com/41107404/189356179-3b40c35f-a824-4d36-af31-07310818f8ea.png">
- <img width="1712" alt="image" src="https://user-images.githubusercontent.com/41107404/189356379-aba0d849-49e4-48ab-b0a4-2d43b542f706.png">
- <img width="1712" alt="image" src="https://user-images.githubusercontent.com/41107404/189356461-8e807cf6-5280-4179-b78c-c3c8a02432ac.png">
- <img width="1703" alt="image" src="https://user-images.githubusercontent.com/41107404/189356576-bb2435c3-6ea2-4ec5-a7a8-0a6ea885f5d1.png">
