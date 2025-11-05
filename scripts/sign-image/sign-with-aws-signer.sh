#!/bin/bash
# Script to sign a container image using Notation CLI with AWS Signer plugin.
IMAGE_URI=$1
PROFILE_NAME=${2:-my-container-signer}
if [ -z "$IMAGE_URI" ]; then
  echo "Usage: $0 <image-uri> [profile-name]"
  exit 1
fi
notation sign "$IMAGE_URI" \
  --plugin com.aws.signer.notation.plugin \
  --id "$PROFILE_NAME"
echo "Signed image: $IMAGE_URI with profile: $PROFILE_NAME"
