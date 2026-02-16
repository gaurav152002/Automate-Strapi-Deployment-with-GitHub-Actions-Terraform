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
#!/bin/bash

apt update -y
apt install docker.io -y

systemctl start docker
systemctl enable docker

usermod -aG docker ubuntu

# Create 2GB swap
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Pull Docker image
docker pull gauravjith/strapi-task6:${image_tag}

# Run Strapi with required environment variables
docker run -d -p 1337:1337 \
  --name strapi \
  --restart unless-stopped \
  -e APP_KEYS="IsSigc7coPDiBQM+8jtTHg==,SyaCArg/azXlfySStmV3PQ==,46l31FehiLUsZLWk43FoWQ==,mGmMa6kPEurH/hILqJL+kA==" \
  -e API_TOKEN_SALT="2z0oGPhBUkJrYLvUKXBFkA==" \
  -e ADMIN_JWT_SECRET="XrLYZf9YbHqZg0kdVqgeLg==" \
  -e JWT_SECRET="jwtsecret123" \
  gauravjith/strapi-task6:${image_tag}
