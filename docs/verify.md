# Verify Signed Images  

This guide describes how to verify signed container images using Notation CLI and how to verify them within a Kubernetes cluster with Kyverno.  

## Verify Locally with Notation CLI  

- Ensure Notation CLI is installed on your system.  
- Pull the signed image from Amazon ECR to your local environment if necessary.  
- Use the `notation verify` command to check the signature.  

Example:  

```
bash
notation verify <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app:latest
```  

If verification succeeds, Notation will output a confirmation message indicating the signature is trusted.  

## Verify in Kubernetes with Kyverno  

To verify signatures in a Kubernetes environment, apply Kyverno policies that enforce signature verification.  

- Ensure Kyverno is installed in your cluster and running in the `kyverno` namespace.  
- Apply the provided policy that verifies signed images:  

```bash
kubectl apply -f policies/kyverno/verify-signed-images.yaml
```  

This policy instructs Kyverno to verify the signature of images pulled from Amazon ECR using the keyless configuration specified. If the signature is invalid or missing, Kyverno will reject the Pod creation.  

To test verification:  

1. Deploy a Pod referencing your signed image.  
2. Kyverno will validate the image signature at admission time.  
3. If the signature is valid, the Pod will be created; otherwise, the request will be denied.  

Refer to `verify-signed-images.yaml` for the policy configuration details.
