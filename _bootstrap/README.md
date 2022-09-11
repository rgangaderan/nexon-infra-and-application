# Manual Steps for the entire Project.

## On AWS Account

1.	AWS Account 
2.	EC2 Instance for GHA Self Hosted Runner 
    In each repository you can find the steps to create self-hosted runners.
    ### Steps are mentioned in main Readme.md file
3.	IAM Instance profile with necessary permissions.
4.	AWS CLI Profile
<img width="452" alt="image" src="https://user-images.githubusercontent.com/41107404/189518774-43014eb6-3e3d-49b9-8421-13174ebbee99.png">

5.	SSH KeyPare
6.	SSM and Secret managers to store Docker, RDS Instance credentials
-  Secret Manager 
<img width="452" alt="image" src="https://user-images.githubusercontent.com/41107404/189518785-6dd1e591-27d5-4f51-8bde-ae47380d88f9.png">
-  SSM
<img width="452" alt="image" src="https://user-images.githubusercontent.com/41107404/189518790-e68be2b9-f191-4287-9b65-41cc886fb8e5.png">

 
## On GitHub.com

1.	Create GHA Secrets for Workflows
- Terraform Cloud Token
-	SSH Private key in-order to pull repos in GHA EC2
-	Docker Hub Credentials
-	GHA Environment for manual approvals on deployments 

## On Terraform Cloud

1.	Since we are using Terraform cloud only for remote state, please make sure to change Execution Mode to local once done with terraform init.
<img width="452" alt="image" src="https://user-images.githubusercontent.com/41107404/189518804-884c3165-df4b-4809-98a4-352f848344a0.png">

