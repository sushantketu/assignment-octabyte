# Splunk Logging Setup

This folder contains configuration for forwarding Kubernetes EKS logs from the `sushantketucluster` to Splunk, using Fluent Bit.

## Files

- `fluent-bit-configmap.yaml`: Fluent Bit config with Splunk output.
- `fluent-bit-daemonset.yaml`: DaemonSet for deploying Fluent Bit cluster-wide.
- `splunk-hec-secret.yaml`: K8s secret manifest for Splunk HEC endpoint/token.
- `README.md`: This documentation.

## How It Works

- Application, system, and access logs from all pods and nodes are tailed by Fluent Bit.
- Logs are enriched with Kubernetes metadata.
- Logs are securely forwarded to Splunk HTTP Event Collector (HEC).

## Setup

1. Edit `splunk-hec-secret.yaml` with your Splunk HEC endpoint and token.
2. Apply configs to the `kube-system` namespace:

kubectl apply -f splunk-hec-secret.yaml
kubectl apply -f fluent-bit-configmap.yaml
kubectl apply -f fluent-bit-daemonset.yaml

3. Monitor logs in your Splunk dashboard with search:

index=kubernetes sourcetype="fluentbit"

 
undefined