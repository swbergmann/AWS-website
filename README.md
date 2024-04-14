# AWS-website
Host a simple webpage on AWS.

This file describes the steps and installations that were necessary to run the code in Visual Studio Code editor.

#1  
Install Terraform (via Homebrew)  
https://formulae.brew.sh/formula/terraform  
\
#2  
Upgrade Terraform (via Terminal)  
https://developer.hashicorp.com/terraform/install?product_intent=terraform  
\
#3
Install Terraform Formatter (for VS Code)  
https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform  
\
#4  
Install AWS CLI  
https://formulae.brew.sh/formula/awscli  
\
#5  
Create AWS IAM User with Admin Access  
Go to IAM console, create IAM User, do not click checkbox "Provide access to AWS Console", select "attach policy directly" and give AdministratorAccess rights, review and create user
\
#6  
Generate Access Key for IAM User  
click on the user, click on tab "Security credentials" and generate "new access key", select for (CLI) and create access key.  
\
#7  
Configure AWS (Terminal Connection)  
Open Terminal (i.e. terminal inside VS Code) and enter "aws configure", provide both keys from #6 and default zone "eu-central-1", then click enter.  
\
#8  
ami specifics  
When using an ami (amazon machine image) in the code, the region (i.e. eu-central-1) of the provider in the file config.tf must be the same region as selected in the AWS console (website) when you are selecting an ami (amazon machine image) number from the AWS Console.
\
#9  
Terraform commands:  
terraform init (run this after writing a new terraform configuration or cloning)  
terraform validate  
terraform plan  
terraform apply  
terraform delete  
\