#!/bin/bash

# Script to create an AWS Signer signing profile for container images.

PROFILE_NAME=${1:-my-container-signer}
PLATFORM_ID="AWSLambda-SHA384-ECDSA"

# Create the signing profile using AWS CLI
aws signer put-signing-profile \
  --profile-name "$PROFILE_NAME" \
  --platform-id "$PLATFORM_ID"

echo "Created signing profile: $PROFILE_NAME"
