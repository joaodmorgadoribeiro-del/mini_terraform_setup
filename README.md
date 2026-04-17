# Resilient Web Infrastructure on AWS

A simple AWS project built with Terraform that connects multiple services to deliver a secure, scalable web environment accessible via HTTPS.

## What it does

This project provisions a fully working AWS infrastructure where:
- **EC2 instances** run the web application inside private subnets
- **Auto Scaling Group (ASG)** keeps the app healthy and scalable
- **Application Load Balancer (ALB)** distributes traffic across instances
- **CloudFront** serves as a global CDN with HTTPS support
- **ACM** provides the SSL/TLS certificate for a secure browser connection
- **S3 + DynamoDB** manage Terraform remote state safely

## Architecture

```
User → HTTPS → Route 53 → CloudFront (ACM) → ALB → EC2 (private)
```

## How to deploy

```bash
terraform init
terraform plan 
terraform apply 
```

## Author

João Ribeiro
