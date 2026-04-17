#!/bin/bash
set -euo pipefail

echo "🚀 Starting Terraform workflow..."
echo "=================================="

echo ""
echo "📦 [1/5] terraform init"
echo "----------------------------------"
terraform init

echo ""
echo "🎨 [2/5] terraform fmt"
echo "----------------------------------"
terraform fmt

echo ""
echo "✅ [3/5] terraform validate"
echo "----------------------------------"
terraform validate

echo ""
echo "📋 [4/5] terraform plan"
echo "----------------------------------"
terraform plan -out=tfplan

echo ""
echo "⚠️  Review the plan above."
read -p "Do you want to apply? (yes/no): " confirm

if [[ "$confirm" == "yes" ]]; then
  echo ""
  echo "🔧 [5/5] terraform apply"
  echo "----------------------------------"
  terraform apply tfplan
  echo ""
  echo "✅ Apply complete!"
else
  echo ""
  echo "❌ Apply cancelled. The tfplan file is still saved if you want to apply later:"
  echo "   terraform apply tfplan"
fi