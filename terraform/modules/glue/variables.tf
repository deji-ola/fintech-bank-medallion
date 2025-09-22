variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "s3_data_lake_bucket" {
  description = "Name of the S3 data lake bucket"
  type        = string
}
