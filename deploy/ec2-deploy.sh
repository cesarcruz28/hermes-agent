#!/bin/bash
# Hermes EC2 deploy script
# Placeholders __ECR_IMAGE__, __ECR_REGISTRY__, __REGION__ are substituted
# by GitHub Actions before this script is sent to EC2 via SSM.
set -e

ECR_IMAGE="__ECR_IMAGE__"
ECR_REGISTRY="__ECR_REGISTRY__"
REGION="__REGION__"
LOG="/home/ubuntu/github-deploy.log"

echo "=== Deploy $(date) ===" > "$LOG"
echo "Image: $ECR_IMAGE" >> "$LOG"

aws ecr get-login-password --region "$REGION" \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY" 2>&1 | tee -a "$LOG"

sed -i "s|image: .*hermes-agent.*|image: ${ECR_IMAGE}|g" /home/ubuntu/docker-compose.yml

docker compose -f /home/ubuntu/docker-compose.yml pull 2>&1 | tee -a "$LOG"
docker compose -f /home/ubuntu/docker-compose.yml up -d --force-recreate 2>&1 | tee -a "$LOG"

echo "=== Deploy complete $(date) ===" | tee -a "$LOG"
docker ps 2>&1 | tee -a "$LOG"
