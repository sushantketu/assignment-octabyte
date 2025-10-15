#!/bin/bash
set -e

IMAGE_TAG=$1
echo "Scanning image $IMAGE_TAG for vulnerabilities..."

# Using Trivy for scanning
trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_TAG
