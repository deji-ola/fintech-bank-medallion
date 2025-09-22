# FinTech Bank Medallion Architecture - Deployment Guide

## Prerequisites

1. AWS Account with programmatic access
2. Terraform >= 1.0 installed
3. AWS CLI configured with credentials
4. Python 3.8+ installed

## Quick Deployment

### Step 1: Setup Infrastructure
Run the setup script:
./scripts/setup.sh

Deploy infrastructure:
cd terraform
terraform apply tfplan

### Step 2: Test Data Pipeline
Install Python dependencies:
pip3 install -r requirements.txt

Run payment simulator:
python3 src/data-ingestion/payment_simulator.py

### Step 3: Verify Deployment
1. Check AWS Console for created resources
2. Monitor CloudWatch logs for streaming data

## Architecture Components

### Bronze Layer - Raw Data
- Kinesis Data Stream: Real-time payment ingestion
- S3 Storage: Partitioned by date and payment type
- Format: JSON messages with metadata

### Silver Layer - Cleansed Data  
- Data Validation: Business rules applied
- Enrichment: Currency conversion, reference data
- Format: Parquet with improved schema

### Gold Layer - Analytics Ready
- Aggregated Views: Daily/monthly summaries
- Business Metrics: Payment volumes, success rates
- Access: Athena queries, BI dashboards

## Cost Optimization
- S3 Lifecycle: Automatic transition to cheaper storage
- Kinesis Shards: Right-sized for expected throughput
- Retention Policies: 7-day default, configurable

## Security Features
- Encryption: All data encrypted at rest and in transit
- IAM Roles: Least privilege access model
- Audit Logging: CloudTrail for compliance
