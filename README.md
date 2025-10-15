# assignment-octabyte

## Overview

This repository contains a full production-like DevOps project demonstrating:
- Infrastructure provisioning on AWS EKS using Terraform
- GitLab CI/CD automation for application build, test, deploy
- Monitoring metrics collection with Prometheus and Grafana
- Centralized logging to Splunk using Fluent Bit
- Secure secret management and backup best practices

---

## Setup and Running the Infrastructure

1. Configure AWS CLI with credentials having permissions to create EKS, RDS, VPC, etc.
2. Update `infra/eks/terraform.tfvars` with your desired variables (region, key name, DB creds).
3. Initialize and apply Terraform:
terraform init
terraform apply

text
4. Deploy the Kubernetes manifests in `k8s-manifests/` to the EKS cluster.
5. Configure GitLab CI/CD variables and run pipelines for build and deployment.
6. Set up monitoring and logging by applying manifests in `monitoring/`.

---

## Architecture Decisions

- Used AWS managed EKS for Kubernetes to reduce cluster management overhead.
- VPC designed with public and private subnets for security and scalability.
- CI/CD with GitLab to automate tests, builds, image scanning, manual approvals.
- Prometheus + Grafana chosen for scalable, open-source metrics collection and visualization.
- Fluent Bit aggregates container, system, and access logs, sends securely to Splunk.
- RDS PostgreSQL for managed, automated backups and scaling database layer.

---

## Security Considerations

- Used Kubernetes Secrets for sensitive data (Splunk tokens, DB passwords).
- Terraform remote state stored in encrypted S3 bucket with restricted IAM access.
- Network policies and security groups enforce least privilege on Kubernetes workloads.
- Manual approval gate in CI/CD to avoid accidental production deployments.
- TLS enabled on all ingress and communication channels.

---

## Cost Optimization Measures

- Use appropriate instance types (t3.medium) and node autoscaling to lower costs.
- EKS managed node groups reduce operational overhead and optimize utilization.
- Use Amazon RDS for managed backups and automated patching instead of self-managed DB.
- Use monitoring data to identify underutilized resources and control autoscale limits.
- Destroy test environments promptly to avoid idle cloud cost.

---

## Secret Management

- Kubernetes Secrets used to store credentials securely in the cluster.
- CI/CD utilizes GitLab CI/CD variables to inject secrets at runtime.
- Recommended to use AWS Secrets Manager or HashiCorp Vault for centralized secrets in production.

---

## Backup Strategy

- Backup PostgreSQL database using automated RDS snapshot features.
- Terraform state backed up remotely in encrypted S3 bucket with versioning enabled.
- Monitor cluster and application backups regularly; keep multiple retention intervals.
- Use Git version control for all infrastructure and deployment code to enable rollback.

---

## Contact and Support

For any questions or assistance, contact the DevOps engineering team.

This README covers all requested documentation tasks and best practices for secret management and backup consistent with our project setup.
