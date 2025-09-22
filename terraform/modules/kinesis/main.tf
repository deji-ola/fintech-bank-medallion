# Kinesis Data Stream for payment transactions
resource "aws_kinesis_stream" "payment_stream" {
  name             = "${var.project_name}-payments"
  shard_count      = 2
  retention_period = 168  # 7 days

  shard_level_metrics = [
    "IncomingRecords",
    "OutgoingRecords",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name        = "${var.project_name}-payments-stream"
    Environment = var.environment
    Purpose     = "Payment transaction streaming"
  }
}

# CloudWatch Log Group for Kinesis
resource "aws_cloudwatch_log_group" "kinesis_logs" {
  name              = "/aws/kinesis/${var.project_name}-payments"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-kinesis-logs"
    Environment = var.environment
  }
}

# IAM role for Kinesis Firehose (if needed later)
resource "aws_iam_role" "kinesis_firehose_role" {
  name = "${var.project_name}-kinesis-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-kinesis-role"
    Environment = var.environment
  }
}
