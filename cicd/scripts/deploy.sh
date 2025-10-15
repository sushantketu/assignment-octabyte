
#!/bin/bash
set -e

ENVIRONMENT=$1
IMAGE_TAG=$2

echo "Deploying image $IMAGE_TAG to $ENVIRONMENT on EKS..."

# Set up kubeconfig for sushantketucluster
aws eks update-kubeconfig --region us-east-1 --name sushantketucluster

kubectl set image deployment/myapp-deployment myapp-container=$IMAGE_TAG -n $ENVIRONMENT --record
