#!/bin/bash

sudo apt-get update -y

# Install Java, fontconfig and curl for Jenkins
sudo apt install -y fontconfig openjdk-21-jre curl
java -version

#Add Jenkins repository and key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null


#Install Jenkins
sudo apt update
sudo apt install -y jenkins

#Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

#Install Docker
sudo apt-get install -y docker.io

#Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

#Install Docker Compose
sudo apt-get install -y docker-compose-v2

#Add user to docker group
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

#Refresh group membership
newgrp docker

#Restart Jenkins to apply changes
sudo systemctl restart jenkins


