#!/bin/bash

# FinTech Bank Medallion Architecture Setup Script
echo "🏦 Setting up FinTech Bank Medallion Architecture..."

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform required. Install: https://terraform.io/downloads" >&2; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "❌ AWS CLI required. Install: https://aws.amazon.com/cli/" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "❌ Python 3 required." >&2; exit 1; }

echo "✅ Prerequisites check passed"

# Check AWS credentials
aws sts get-caller-identity >/dev/null 2>&1 || { 
    echo "❌ AWS credentials not configured. Run: aws configure" >&2; exit 1; 
}
echo "✅ AWS credentials configured"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# Initialize Terraform
echo "🚀 Initializing Terraform..."
cd terraform
terraform init

# Create terraform.tfvars
cat > terraform.tfvars << EOL
aws_region = "eu-west-2"
project_name = "fintech-bank-medallion"
environment = "dev"
EOL

echo "📋 Created terraform.tfvars"

# Plan deployment
echo "📊 Planning Terraform deployment..."
terraform plan -out=tfplan

echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Review plan: terraform show tfplan"
echo "   2. Deploy: terraform apply tfplan"
echo "   3. Test: python3 ../src/data-ingestion/payment_simulator.py"
