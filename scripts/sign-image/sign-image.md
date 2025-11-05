# Sign Image  

Use these commands to sign your container images using AWS Signer.  

1. Authenticate to Amazon ECR and retrieve the image digest.  
2. Call the AWS Signer `start-signing-job` with your signing profile and image reference.  
3. Retrieve the signed image and push it to ECR.
