# S3 Bucket for Data Lake
resource "aws_s3_bucket" "data_lake" {
  bucket = "${var.project_name}-data-lake-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    id     = "medallion_lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}

# Create layer prefixes
resource "aws_s3_object" "bronze_prefix" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "bronze/"
  content = ""
}

resource "aws_s3_object" "silver_prefix" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "silver/"
  content = ""
}

resource "aws_s3_object" "gold_prefix" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "gold/"
  content = ""
}
