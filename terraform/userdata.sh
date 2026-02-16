#!/bin/bash

# Update system
apt update -y

# Install Docker
apt install docker.io -y

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Create 2GB swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Pull Docker image
docker pull gauravjith/strapi-task6:${image_tag}

# Run Strapi container
docker run -d -p 1337:1337 \
  --name strapi \
  --restart unless-stopped \
  gauravjith/strapi-task6:${image_tag}
