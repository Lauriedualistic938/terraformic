# GCP GKE

Terraform setup for a GKE cluster in EU with 3 worker nodes, one per zone, and shared storage via Filestore.

## Prereqs
- Terraform >= 1.5
- GCP project + credentials (ADC or service account JSON)

## Usage
1. Create a `terraform.tfvars` with your settings.
2. Run `terraform init && terraform apply`.

Example `terraform.tfvars`:
```hcl
project_id       = "your-project"
region           = "europe-west1"
project_name     = "k8s-gke"
```

## Storage (Filestore)
- Terraform provisions Filestore.
- Creates a default StorageClass `filestore-sc` for the Filestore CSI driver.

## Notes
- This creates one node pool per zone with `node_per_zone = 1` by default.

## Outputs
- GKE cluster name
- API endpoint
- Filestore instance name
