# AWS-website
Host a simple webpage on AWS.

This file describes the steps and installations that were necessary to run the code in Visual Studio Code editor.

#1  
Install Terraform  
https://formulae.brew.sh/formula/terraform  
\
#2  
Upgrade Terraform  
https://developer.hashicorp.com/terraform/install?product_intent=terraform  
\
#3
Install Terraform Formatter vor VS Code  
https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform  
\
#4  
Install AWS CLI  
https://formulae.brew.sh/formula/awscli  
\
#5
Go to IAM console, create IAM User, do not click checkbox "Provide access to AWS Console", select "attach policy directly" and give AdministratorAccess rights, review and create user, click on the user, click on tab "Security credentials" and generate "new access key", select for (CLI) and create access key.  
\
#6
Open Terminal (i.e. inside VS Code) and enter "aws configure", provide both keys and default zone "eu-central-1", then click enter.  
\
#7
ami specifics  
the REGION (i.e. eu-central-1) of the provider in the file main.tf must be the same region as selected in the AWS console (website) when you are selecting an ami (amazon machine image).
\
#8 
Terraform commands:  
terraform init (run this after writing a new terraform configuration or cloning)  
terraform validate  
terraform plan  
terraform apply  
terraform delete  
\