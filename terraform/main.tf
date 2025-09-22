terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "FinTech-Bank-Medallion"
      Environment = var.environment
      Owner       = "Solutions-Architect"
    }
  }
}

# Data Sources
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# S3 Data Lake
module "s3_data_lake" {
  source = "./modules/s3"
  
  project_name = var.project_name
  environment  = var.environment
}

# Kinesis Data Streams
module "kinesis_streams" {
  source = "./modules/kinesis"
  
  project_name = var.project_name
  environment  = var.environment
}

# AWS Glue Data Catalog
module "glue_catalog" {
  source = "./modules/glue"
  
  project_name        = var.project_name
  environment         = var.environment
  s3_data_lake_bucket = module.s3_data_lake.bucket_name
}
