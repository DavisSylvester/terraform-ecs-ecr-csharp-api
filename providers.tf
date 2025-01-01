terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    
  }

#   backend "s3" {   
#     encrypt             = true    
#   }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "dsylvesteriii"
}