Here's a step-by-step checklist to deploy your project on AWS using your Visual Studio Code setup and GitLab repository:

1. AWS Account Preparation
Ensure you have an AWS account with permissions to create EKS, EC2, VPC, RDS, S3, IAM, and CloudWatch resources.

Create an EC2 Key Pair in your target region (matching the key name in your Terraform variables).

2. Configure AWS CLI Locally
Install AWS CLI and configure credentials in Visual Studio Code terminal:

 
aws configure
(Input your access key, secret key, region, default output)

3. Prepare Local Environment
Make sure you have:

Terraform installed

kubectl CLI installed

aws-iam-authenticator (for EKS)

docker installed (for image build/test)

Clone your latest GitLab repo locally if not already:

 
git clone https://gitlab.com/yourusername/assignment-octabyte.git
cd assignment-octabyte
4. Infrastructure Provisioning (Terraform)
Edit infra/eks/terraform.tfvars to set your AWS region, bucket, key pair, DB credentials, etc.

In infra/eks/, initialize and apply Terraform:

 
terraform init
terraform apply
Confirm EKS, VPC, RDS, ALB, and other resources are created successfully.

5. Setup kubeconfig for EKS
Update your local kubeconfig for the newly created EKS cluster:

 
aws eks update-kubeconfig --region <your-region> --name sushantketucluster
Test cluster access:

 
kubectl get nodes
6. Deploy Kubernetes Manifests
Deploy your app and necessary resources:

 
kubectl apply -f k8s-manifests/
7. Monitoring & Logging Setup
Deploy Prometheus, Grafana, and Fluent Bit for Splunk (using provided YAMLs in monitoring/):

 
kubectl apply -f monitoring/logging/splunk-hec-secret.yaml
kubectl apply -f monitoring/logging/fluent-bit-configmap.yaml
kubectl apply -f monitoring/logging/fluent-bit-daemonset.yaml
# Similarly deploy Prometheus/Grafana using Helm or manifest as per your method
8. GitLab CI/CD Pipeline Preparation
On GitLab, go to Settings > CI/CD > Variables and add all required secrets:

AWS credentials (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

Docker registry creds

Splunk HEC tokens, Slack webhook, etc.

Ensure a GitLab runner is configured (shared or your own).

9. Run CI/CD Pipeline
Make a commit/push, or manually run the pipeline from the GitLab UI (it will build, test, scan, and deploy your app to EKS).

10. Verification
Use kubectl get pods, kubectl get svc etc. to verify deployments.

Check Prometheus/Grafana dashboards for metrics.

Check Splunk for log aggregation.

11. Security & Optimization
Consider setting up more robust secret management (AWS Secrets Manager, Vault) and production-grade IAM roles.

Enable backups for RDS (via AWS console or Terraform).

Monitor AWS billing for cost control.
