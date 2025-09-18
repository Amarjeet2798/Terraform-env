######################provider for only single provider(aws)#################################
terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0.0"
        }

    }
    required_version = "~> 1.13.0"
}
provider "aws" {
     region = var.region
     access_key                  = "test"      # dummy, no real AWS
     secret_key                  = "test"      # dummy, no real AWS
     skip_credentials_validation = true        # skip AWS credential check
     skip_requesting_account_id  = true        # skip STS:GetCallerIdentity
}


/*
######################provider for multiple provides(aws/azure)################################
terraform {
    required_providers {
        aws = {
            source = "hashicrop/aws"
            version = "~>5.0" # >=5.0.0 AND < 6.0.0
        }

        azurerm = {
            source = "hashicrop/azurerm"
            version = "~>3.0"
        }
    }    
    required_version = "~>1.3.0"
}
provider "aws" {
    region = "ap-south-1"
}
provider "azurerm" {
    region = "ap-south-1"
}

*/

#######################provider for single provider but different regions#########################
/*
terraform{
    required_providers {
        aws = {
            source = "hashicrop/aws"
            version = "~>5.0"
        }
    }
    required_version = "~>1.3.0"
}
provider "aws" {
    region = "ap-south-1"
    alias = "aws-apsouth"
}
provider "aws" {
    region = "us-east-1"
    alias = "aws-us-east"
}
*/
