output "s3_bucket_name" {
  description = "Name of the S3 data lake bucket"
  value       = module.s3_data_lake.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 data lake bucket"
  value       = module.s3_data_lake.bucket_arn
}

output "kinesis_stream_name" {
  description = "Name of the Kinesis data stream"
  value       = module.kinesis_streams.stream_name
}

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis data stream"
  value       = module.kinesis_streams.stream_arn
}
