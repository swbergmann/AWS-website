# AWS-website
Build AWS Cloud Infrastructure as Code (IaC) using Terraform and deploy a Static Website on it.

# Project Description
This application creates (and destroys) the necessary cloud infrastructure resources to host a static website on AWS. It also uploads (and destroys) the static website (located in the directory: s3_content/) to the S3 backend.  

## Requirements/Scope
A combination of AWS CloudFront and AWS S3 is used to implement:
* high availability of the website, 
* no latency for visitors worldwide,
* automatic scaling of infrastructure components to serve high amounts of user traffic.

## Architecture
![AWSArchitecture drawio](https://github.com/swbergmann/AWS-website/assets/52543581/2d907f4a-38fc-430f-900b-c5c9f31d30d6)

# How to Setup the Project

This section describes the steps and installations that were necessary to create and run the code in Visual Studio Code on macOS Sonoma.

## 1. Install Terraform (i.e. via Homebrew)
https://formulae.brew.sh/formula/terraform  

## 2. Upgrade Terraform (i.e. via Terminal)
https://developer.hashicorp.com/terraform/install?product_intent=terraform  

## 3. Install Terraform Formatter for VS Code (optional)
https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform  

## 4. Install AWS CLI
https://formulae.brew.sh/formula/awscli  

## 5. Create AWS IAM User with Administrator Access
Go to IAM console, create IAM User, do not click checkbox "Provide access to AWS Console", select "attach policy directly" and give AdministratorAccess rights, review and create user  

## 6. Generate Access Key for IAM User
click on the user, click on tab "Security credentials" and generate "new access key", select for (CLI) and create access key.  

## 7. Configure AWS (Terminal Connection)
Open Terminal (i.e. terminal inside VS Code) and enter "aws configure", provide both keys from #6 and default zone "eu-central-1", then click enter.  

## 8. note on ami specifics  
When using an ami (amazon machine image - i.e. when creating an EC2 instance) in the Terraform code, the region (i.e. eu-central-1) of the provider in the file config.tf must be the same region as selected in the AWS console (website) when you are choosing an ami (amazon machine image) number from the AWS Console.  

# How to Run the Project
After cloning the project to your computer and setting up the described configurations, use the following commands.  

## Terraform commands:

### terraform init  
run this after writing a new terraform configuration or cloning the project from github  

### terraform validate
to validate the terraform code  

### terraform plan
to preview the execution plan  

### terraform apply
confirm with "yes" - to create the cloud infrastructure  
and wait for the deployment to complete  

# Check the result
In the AWS Console navigate to the newly created "CloudFront" distribution  
copy the "Domain name" (i.e. abc123123123xyz.cloudfront.net) and access it using a browser  

The result should look similar to this image:
![Screenshot 2024-04-14 at 17 15 52](https://github.com/swbergmann/AWS-website/assets/52543581/fd039a9c-6019-40ab-9747-f02ee8237f1f)

# Cleanup of Infrastructure
In order to destroy all resources (i.e. the static website files) as well as all created cloud infrastructure resources, run the following command.

## Terraform commands:

### terraform delete
confirm with "yes" - to destroy the cloud infrastructure

## Confirm deletion
It is recommended to verify successful deletion of all resources by navigating through the AWS Console and making sure of it.
