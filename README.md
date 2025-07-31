# 🛠️ Conversion – Document Conversion Backend on AWS

This project powers a document conversion backend (e.g., PDF ↔ DOCX). It is designed for companies and individuals who need automated, scalable document conversion — whether for internal use or client delivery.

## 🔧 What This Project Covers

- **Backend Infrastructure**: Deployed using Terraform (IaC) on AWS
- **Services Used**:
  - **S3**: For input/output file storage
  - **SQS**: Message queueing between upload and processing
  - **IAM**: Role and permission management
  - **VPC**: Isolated network environment
  - **ECS Fargate + ECR**: Container orchestration and image hosting
- **App Stack**:
  - Python script with `docx2pdf` for file conversion
  - Dockerized app deployed to ECS via ECR

## 🐳 Docker & ECR Setup

```bash
# Create ECR repo
aws ecr create-repository --repository-name convertsaas-ecs

# Get AWS account ID and region
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1

# Authenticate Docker to AWS ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build and push Docker image
docker build -t convertsaas .
docker tag convertsaas:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/convertsaas-ecs:latest
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/convertsaas-ecs:latest
ECS DEPLOYMENT 
aws ecs describe-services \
  --cluster convertsaas-ecs-cluster \
  --services convertsaas-service \
  --query "services[0].{Status: status, DesiredCount: desiredCount, RunningCount: runningCount, PendingCount: pendingCount}" \
  --output table
cd /home/opate/convertsaas
GIT COMMAND
git init
git remote add origin https://github.com/tejumola-tech/conversion.git
git add .
git commit -m "Initial push: Terraform infra + ECS + app"
git push -u origin main --force
TERRAFORM COMMAND
terraform init
terraform plan
terraform apply

This project helped me understand how to:

Use Terraform for repeatable AWS infrastructure deployment

Integrate S3, SQS, and ECS Fargate using IaC

Build and deploy containerized apps using ECR + ECS

Handle cloud-native event-driven workflows
