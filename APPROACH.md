**Infrastructure as Code and CI/CD Approach**
This project was designed with a focus on modular, scalable infrastructure provisioning using Terraform and integrating a reliable CI/CD pipeline for continuous deployment.

Modular Terraform Design: Resources were broken down into reusable modules representing core AWS components: VPC, subnets, EKS cluster, managed node groups, RDS, and application load balancer. This improves maintainability and scalability.

Terraform State Management: Used S3 backend with versioning enabled for secure, consistent remote state storage and team collaboration.

EKS Cluster Automation: Leveraged official terraform-aws-modules EKS module (v21.4.0) for simplified, best-practice managed Kubernetes cluster setup.

CI/CD Pipeline: Implemented automated infrastructure provisioning and application deployment triggered by code changes using GitHub Actions (or your chosen tool), enabling rapid and safe rollouts.

Security and Access Control: Followed least-privilege IAM roles, isolated networks with private subnets, and encrypted RDS databases.

Testing and Validation: Emphasized validation stages in pipeline and manual plan reviews before apply to ensure infrastructure correctness.

The approach balances automation, security, reliability, and extensibility aligned with DevOps best practices.
