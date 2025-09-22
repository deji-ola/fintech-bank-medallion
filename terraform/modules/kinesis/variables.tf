variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "shard_count" {
  description = "Number of shards for Kinesis stream"
  type        = number
  default     = 2
}

variable "retention_period" {
  description = "Data retention period in hours"
  type        = number
  default     = 168  # 7 days
}
