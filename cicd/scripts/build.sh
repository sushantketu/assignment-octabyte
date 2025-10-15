#!/bin/bash
set -e

IMAGE_TAG=$1
echo "Building Docker image with tag: $IMAGE_TAG"

docker build -t $IMAGE_TAG .
