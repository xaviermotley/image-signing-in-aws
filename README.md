# Image Signing in AWS  
**Container image signing, verification, and attestation with AWS Signer, Notation CLI, Amazon ECR, and Kyverno**  

![Architecture Diagram](./docs/architecture-diagram.png)  

---  

## 📘 Overview  

This project demonstrates an **end-to-end container image signing and verification workflow** using:  

- **AWS Signer** – to generate and manage cryptographic signatures for container images  
- **Amazon ECR** – to store and distribute signed container images  
- **Notation CLI** – to verify container image signatures locally and within Kubernetes clusters  
- **Kyverno** – to enforce policies ensuring that only signed and trusted images can be deployed  

It showcases a **secure software supply chain** on AWS, from image build to policy enforcement in Kubernetes.  

---  

## 🏗️ Architecture  

```mermaid  
graph TD  
    A[Build Container Image] --> B[Sign Image with AWS Signer]  
    B --> C[Push Signed Image to Amazon ECR]  
    C --> D[Verify Signature with Notation CLI]  
    D --> E[Deploy to Kubernetes Cluster]  
    E --> F[Kyverno Policy Enforces Signed Images]  
```  

Each step builds on AWS-native and open-source tooling to create a verifiable chain of trust.  

---  

## 📂 Repository Structure  

```
image-signing-in-aws/
├── README.md
├── docs/
│   ├── overview.md
│   ├── setup.md
│   ├── verify.md
│   └── architecture-diagram.png
├── scripts/
│   ├── setup-signer/
│   │   └── create-signer-profile.sh
│   ├── sign-image/
│   │   └── sign-with-aws-signer.sh
│   └── verify-image/
│       └── verify-with-notation.sh
├── policies/
│   └── kyverno/
│       ├── require-signed-images.yaml
│       ├── verify-signed-images.yaml
│       └── clusterpolicy.yaml
└── LICENSE
```  

---  

## ⚙️ Prerequisites  

- AWS CLI configured with IAM permissions for AWS Signer and ECR  
- Docker or Podman installed locally  
- Notation CLI ([install guide](https://notaryproject.dev/docs/installation/))  
- A running Kubernetes cluster  
- Kyverno installed ([kyverno.io](https://kyverno.io/docs/installation/))  

---  

## 🚀 Getting Started  

### 1️⃣ Set up AWS Signer Profile  
Create a signing profile and register it in AWS Signer.  

```bash  
aws signer put-signing-profile \  
  --profile-name my-container-signer \  
  --platform-id AWSLambda-SHA384-ECDSA  
```  

### 2️⃣ Build and Push Your Image to ECR  
```bash  
docker build -t <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app:latest .  
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com  
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app:latest  
```  

### 3️⃣ Sign the Image  
```bash  
notation sign <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app:latest \  
  --plugin com.aws.signer.notation.plugin \  
  --id my-container-signer  
```  

### 4️⃣ Verify the Signature  
```bash  
notation verify <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app:latest  
```  

### 5️⃣ Apply Kyverno Policy  
Apply Kyverno policies to ensure only signed images can run.  

```bash  
kubectl apply -f policies/kyverno/require-signed-images.yaml  
kubectl apply -f policies/kyverno/verify-signed-images.yaml  
```  

---  

## 🔒 Kyverno Policy Example  

```yaml  
apiVersion: kyverno.io/v1  
kind: ClusterPolicy  
metadata:
  name: verify-signed-images  
spec:
  validationFailureAction: enforce  
  background: false  
  webhookTimeoutSeconds: 30  
  rules:
    - name: verify-image-signature  
      match:
        any:
          - resources:
              kinds:
                - Pod  
      verifyImages:
        - image: "<account-id>.dkr.ecr.<region>.amazonaws.com/*"  
          keyless:
            issuer: "https://signer.aws.amazon.com"  
            subject: "my-container-signer"  
```  

---  

## 🧩 Example End-to-End Demo Flow  

1. Create the signer profile (`scripts/setup-signer/`)  
2. Build and push your container image to ECR  
3. Sign the image (`scripts/sign-image/`)  
4. Verify the signature locally (`scripts/verify-image/`)  
5. Deploy to a Kubernetes cluster  
6. Enforce Kyverno policies to allow only verified images  

---  

## 👍 License  

This project is licensed under the [MIT License](./LICENSE).  

---  

## 🧠 References  

- [AWS Signer Documentation](https://docs.aws.amazon.com/signer/latest/developerguide/Welcome.html)  
- [Notation CLI Docs](https://notaryproject.dev/docs/)  
- [Kyverno Policies Reference](https://kyverno.io/policies/)  
- [Nirmata kyverno-notation-aws](https://github.com/nirmata/kyverno-notation-aws)  
- [AWS Blog: Simplify container image signing with AWS Signer and Notation](https://aws.amazon.com/blogs/containers/simplify-container-image-signing-with-aws-signer-and-notation/)
