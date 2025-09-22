output "stream_name" {
  description = "Name of the Kinesis data stream"
  value       = aws_kinesis_stream.payment_stream.name
}

output "stream_arn" {
  description = "ARN of the Kinesis data stream"
  value       = aws_kinesis_stream.payment_stream.arn
}

output "stream_id" {
  description = "ID of the Kinesis data stream"
  value       = aws_kinesis_stream.payment_stream.id
}

output "firehose_role_arn" {
  description = "ARN of the Kinesis Firehose IAM role"
  value       = aws_iam_role.kinesis_firehose_role.arn
}
