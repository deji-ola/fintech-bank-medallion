output "database_name" {
  description = "Name of the Glue catalog database"
  value       = aws_glue_catalog_database.payment_database.name
}

output "bronze_crawler_name" {
  description = "Name of the Bronze layer crawler"
  value       = aws_glue_crawler.bronze_crawler.name
}

output "silver_crawler_name" {
  description = "Name of the Silver layer crawler"
  value       = aws_glue_crawler.silver_crawler.name
}

output "glue_role_arn" {
  description = "ARN of the Glue service role"
  value       = aws_iam_role.glue_crawler_role.arn
}
