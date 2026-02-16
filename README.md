cat > README.md << 'EOF'
# 🚀 Automate Strapi Deployment with GitHub Actions + Terraform

## 📌 Project Overview

This project demonstrates a complete CI/CD pipeline for deploying a Strapi application using Docker, GitHub Actions, Terraform, and AWS EC2.

The pipeline automatically:
- Builds a Docker image
- Pushes it to Docker Hub
- Deploys infrastructure using Terraform
- Pulls and runs the latest image on AWS EC2

---

# 🏗 Architecture Flow

Developer Push -> GitHub Actions (CI) -> Docker Image Build -> Push to Docker Hub -> Terraform Workflow (CD) -> AWS EC2 (Ubuntu) -> Docker Pull + Run -> Strapi Available via Public IP

---

# 🧰 Technologies Used

- Node.js 20
- Strapi v5
- Docker
- GitHub Actions
- Terraform
- AWS EC2 (Ubuntu)
- Security Groups
- 2GB Swap Memory
- 25GB Root Volume

---

# 🐳 Docker Configuration

## Dockerfile

- Uses Node 20 slim
- Installs required dependencies
- Exposes port 1337
- Runs Strapi using `npm run develop`

Build locally:

docker build -t strapi-task6 .
docker run -p 1337:1337 --env-file .env strapi-task6

---

# ⚙️ CI Pipeline (GitHub Actions)

File: `.github/workflows/ci.yaml`

Trigger:
workflow_dispatch (Manual)

Steps:
1. Checkout repository
2. Setup Docker Buildx
3. Login to Docker Hub
4. Build Docker image
5. Push image tagged with commit SHA

Image format:
gauravjith/strapi-task6:<commit-sha>

---

# ☁️ CD Pipeline (Terraform)

File: `.github/workflows/terraform.yaml`

Trigger:
workflow_dispatch (Manual)

Input Required:
image_tag

Steps:
1. Checkout repository
2. Setup Terraform
3. Configure AWS credentials
4. Terraform init
5. Terraform plan
6. Terraform apply

---

# 🖥 Terraform Infrastructure

Creates:

- Ubuntu EC2 Instance
- Security Group (Ports 22 & 1337 open)
- Public IP enabled
- 25GB Storage
- 2GB Swap Memory
- Docker Installation
- Automatic Strapi Deployment via user_data

---

# 🚀 Deployment Steps

1️⃣ Push Code

git add .
git commit -m "Update"
git push origin main

2️⃣ Run CI

GitHub → Actions → Build and Push Docker Image → Run workflow

Copy the generated image tag.

3️⃣ Run Terraform Deployment

GitHub → Actions → Terraform Deployment → Run workflow

Enter:
image_tag = <commit-sha>

4️⃣ Access Application

AWS → EC2 → Copy Public IP

Open:
http://{public-ip}:1337

---

# 🛠 Debugging Commands

SSH into EC2:

ssh -i <keyname> ubuntu@<public-ip>

Check container:

sudo docker ps

View logs:

sudo docker logs strapi

---


# 🏆 Final Outcome

✅ Fully Automated CI/CD Pipeline  
✅ Infrastructure as Code  
✅ Dockerized Application  
✅ AWS Cloud Deployment  
✅ Publicly Accessible Strapi Application  

---
