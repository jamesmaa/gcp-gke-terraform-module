# GCP GKE Infrastructure Terraform Module

This Terraform module creates a complete GKE infrastructure on Google Cloud Platform, including VPC networking, private GKE cluster, NAT gateway, service accounts, and firewall rules.

## Overview

This module provisions:

- **VPC Network**: VPC with regional routing
- **Subnets**: GKE subnet with secondary IP ranges for pods and services
- **GKE Cluster**: Private GKE cluster with VPC-native routing and workload identity enabled
- **Node Pools**: Configurable node pools with autoscaling
- **NAT Gateway**: Cloud NAT for outbound internet access from private nodes
- **Service Accounts**: Dedicated service account for GKE nodes with proper IAM roles
- **Firewall Rules**: SSH access via Identity-Aware Proxy (IAP)
- **APIs**: Required Google Cloud APIs automatically enabled

## Prerequisites

Before using this module, ensure you have:

1. **Google Cloud Platform Account** with billing enabled
2. **GCP Project** created with appropriate permissions
3. **Terraform** installed (>= 1.0)
4. **[gcloud CLI](https://cloud.google.com/sdk/docs/install)** installed and authenticated
   ```bash
   # Authenticate with gcloud
   gcloud auth login

   # Set application default credentials
   gcloud auth application-default login

   # Set your default project
   gcloud config set project YOUR_PROJECT_ID
   ```
5. **Required IAM Permissions**:
   - Compute Admin
   - Kubernetes Engine Admin
   - Service Account Admin
   - Project IAM Admin

## Quick Start

The `abridge-staging` folder is an example for spinning up a configured VPC and GKE cluster. It uses sensible values like non-overlapping CIDR ranges for GKE subnets. To use:

```bash
cd abridge-staging

terraform init

terraform apply -var 'project_id=YOUR_PROJECT_ID'
```

## Post-Deployment

### Connect to the GKE Cluster

```bash
# Get cluster credentials
gcloud container clusters get-credentials CLUSTER_NAME --region=REGION --project=PROJECT_ID

# Verify connection
kubectl get nodes
```

### [Optional]: Deploy a Sample Application

```bash
# Create a deployment
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

# Expose the deployment
kubectl expose deployment hello-world --type=LoadBalancer --port=8080

# Get the external IP
kubectl get services hello-world

# Curl the external IP to verify it works
curl 35.196.228.206:8080
```

## Configurations

### Required Variables

| Variable | Description | Type |
|----------|-------------|------|
| `project_id` | GCP project ID | `string` |


### Optional Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `region` | GCP region | `string` | `"us-east1"` |
| `vpc_name` | Name of the VPC network | `string` | `"gke-vpc"` |
| `gke_cluster_name` | Name of the GKE cluster | `string` | `"gke-cluster"` |
| `deletion_protection` | Enable deletion protection (set true for prod) | `bool` | `true` |
| `gke_subnet_node_ip_cidr_range` | CIDR for GKE nodes | `string` | `"10.0.0.0/14"` |
| `gke_subnet_pods_ip_cidr_range` | CIDR for GKE pods | `string` | `"10.4.0.0/14"` |
| `gke_subnet_services_ip_cidr_range` | CIDR for GKE services | `string` | `"10.8.0.0/18"` |
| `node_pools` | List of node pool configurations | `list(object)` | See below |

### Node Pool Configuration

| Parameter | Description | Type | Example Value |
|-----------|-------------|------|--------------|
| `name` | Name of the node pool | `string` | `"default-pool"` |
| `machine_type` | VM machine type | `string` | `"e2-medium"` |
| `total_min_node_count` | Minimum number of nodes | `number` | `1` |
| `total_max_node_count` | Maximum number of nodes | `number` | `3` |
| `preemptible` | Use preemptible/spot VMs | `bool` | `false` |
| `labels` | Node pool labels | `map(string)` | `{environment = "production", team = "platform"}` |


## Troubleshooting

### Common Issues

1. **API Not Enabled**: The module automatically enables required APIs, but it may take a few minutes.
2. **Insufficient Permissions**: Ensure your account has the required IAM roles listed in prerequisites.
3. **Quota Exceeded**: Check your GCP quotas for compute resources in the specified region.
4. **Network Connectivity**: If nodes can't pull images, check NAT gateway and firewall rules.


## Security Features

- **Private GKE Cluster**: Nodes have only private IP addresses
- **Workload Identity**: Secure access to Google Cloud services from pods
- **IAP SSH Access**: Secure SSH access through Identity-Aware Proxy
- **Service Account**: Dedicated service account with minimal required permissions

## Networking

- **VPC Native**: Uses alias IP ranges for pods and services
- **Private Nodes**: All nodes are private with no external IP addresses
- **Cloud NAT**: Provides outbound internet access for private nodes
- **Secondary IP Ranges**: Separate CIDR blocks for pods and services