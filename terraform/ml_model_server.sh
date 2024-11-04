#!/bin/bash

# Redirect stdout and stderr to a log file
exec > /var/log/user-data.log 2>&1

# Ensure all commands are run with superuser privileges
echo "Running as user: $(whoami)"
cd /home/ubuntu

# Update and install basic packages
apt update
apt install -y python3-pip 
apt install -y python3-venv 
apt install -y unzip

# Install NVIDIA drivers and CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
apt -y install cuda-drivers
apt install -y cuda-toolkit-12-6 cudnn-cuda-12

# Set up CUDA environment variables for immediate use in this script
export PATH=/usr/local/cuda-12.6/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH

# Set up CUDA environment variables
echo 'export PATH=/usr/local/cuda-12.6/bin:$PATH' >> /home/ubuntu/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH' >> /home/ubuntu/.bashrc
# source ~/.bashrc

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Download dataset from S3
mkdir -p /home/ubuntu/chest_xray
aws s3 cp s3://x-raysbucket/chest_xray/ /home/ubuntu/chest_xray --recursive --no-sign-request
sudo chown -R ubuntu:ubuntu /home/ubuntu/chest_xray

# Clone repository
cd /home/ubuntu
git clone https://github.com/kura-labs-org/AIWL1.git /home/ubuntu/CNN_deploy

# Set permissions on the repo
sudo chown -R ubuntu:ubuntu /home/ubuntu/CNN_deploy
