# Manual Steps for the entire Project.

## On AWS Account

1.	AWS Account 
2.	EC2 Instance for GHA Self Hosted Runner 
    In each repository you can find the steps to create self-hosted runners.
    Steps are mentioned in main Readme.md file

3.	IAM Instance profile with necessary permissions.
4.	AWS CLI Profile
 
5.	SSH KeyPare
6.	SSM and Secret managers to store Docker, RDS Instance credentials

-  Secret Manager 
-  SSM
 
## On GitHub.com

1.	Create GHA Secrets for Workflows
- Terraform Cloud Token
-	SSH Private key in-order to pull repos in GHA EC2
-	Docker Hub Credentials
-	GHA Environment for manual approvals on deployments 

## On Terraform Cloud

1.	Since we are using Terraform cloud only for remote state, please make sure to change Execution Mode to local once done with terraform init.

 
