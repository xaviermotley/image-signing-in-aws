# Setup Guide  
This guide explains how to configure AWS Signer and other prerequisites for the image signing workflow.  

## Prerequisites  
- AWS CLI installed and configured with access to AWS Signer and Amazon ECR.  
- Docker or Podman installed.  
- Notation CLI installed.  
- A Kubernetes cluster ready.  
- Kyverno installed in the cluster.  

## Steps  

1. **Create an AWS Signer signing profile**.  
   Use the AWS CLI to create a signing profile:  
   ```bash  
   aws signer put-signing-profile \  
     --profile-name my-container-signer \  
     --platform-id AWSLambda-SHA384-ECDSA  
   ```  

2. **Authenticate to Amazon ECR**.  
   Login to your ECR registry:  
   ```bash  
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com  
   ```  

3. **Install Notation CLI**.  
   Follow the installation instructions in the [Notation documentation](https://notaryproject.dev/docs/installation/).  

4. **Install Kyverno**.  
   Install Kyverno in your Kubernetes cluster as described in the [Kyverno documentation](https://kyverno.io/docs/installation/).  

After completing these steps, you can move on to signing and verifying images.
