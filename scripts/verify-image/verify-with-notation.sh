#!/bin/bash
# Script to verify a signed container image using Notation CLI.
IMAGE_URI=$1
if [ -z "$IMAGE_URI" ]; then
  echo "Usage: $0 <image-uri>"
  exit 1
fi
notation verify "$IMAGE_URI"
echo "Verified image: $IMAGE_URI"
