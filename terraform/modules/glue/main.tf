# Glue Data Catalog Database
resource "aws_glue_catalog_database" "payment_database" {
  name         = "${var.project_name}_payment_db"
  description  = "Data catalog for payment transaction data"
  
  tags = {
    Name        = "${var.project_name}-payment-database"
    Environment = var.environment
    Purpose     = "Payment data catalog"
  }
}

# Glue Crawler for Bronze layer
resource "aws_glue_crawler" "bronze_crawler" {
  database_name = aws_glue_catalog_database.payment_database.name
  name          = "${var.project_name}-bronze-crawler"
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://${var.s3_data_lake_bucket}/bronze/"
  }

  configuration = jsonencode({
    Version = 1.0
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
  })

  tags = {
    Name        = "${var.project_name}-bronze-crawler"
    Environment = var.environment
  }
}

# Glue Crawler for Silver layer
resource "aws_glue_crawler" "silver_crawler" {
  database_name = aws_glue_catalog_database.payment_database.name
  name          = "${var.project_name}-silver-crawler"
  role          = aws_iam_role.glue_crawler_role.arn

  s3_target {
    path = "s3://${var.s3_data_lake_bucket}/silver/"
  }

  tags = {
    Name        = "${var.project_name}-silver-crawler"
    Environment = var.environment
  }
}

# IAM role for Glue Crawler
resource "aws_iam_role" "glue_crawler_role" {
  name = "${var.project_name}-glue-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-glue-crawler-role"
    Environment = var.environment
  }
}

# IAM policy for Glue Crawler
resource "aws_iam_role_policy" "glue_crawler_policy" {
  name = "${var.project_name}-glue-crawler-policy"
  role = aws_iam_role.glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_data_lake_bucket}",
          "arn:aws:s3:::${var.s3_data_lake_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach AWS managed policy
resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
