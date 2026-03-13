# AWS EKS

Terraform setup for an EKS cluster in `eu-central-1` with 3 worker nodes, one per AZ, and shared storage via EFS.

## Prereqs
- Terraform >= 1.5
- AWS credentials configured in your environment
- SSH keypair (optional, only used if `enable_public_ssh = true`)

## Usage
1. Create a `terraform.tfvars` with your settings.
2. Run `terraform init && terraform apply`.

Example `terraform.tfvars`:
```hcl
region              = "eu-central-1"
ssh_public_key_path = "/path/to/id_ed25519.pub"
project_name        = "k8s-eks"
```

## Storage (EFS)
- Terraform provisions EFS + mount targets.
- Installs the EFS CSI driver (EKS addon with IRSA).
- Creates a default StorageClass `efs-sc` that uses the EFS file system.

## Notes
- This creates one managed node group per subnet (AZ) with `node_per_az = 1` by default.
- If `enable_public_ssh = true`, SSH access is allowed only from instances attached to the created SSH access security group (use a bastion/VPN).

## Outputs
- EKS cluster name
- API endpoint
- Cluster CA data
- Node group names
- EFS file system ID
