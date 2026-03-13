# Hetzner HA Kubernetes (kubeadm)

Modular Terraform setup to create a 3x control-plane / 2x worker HA Kubernetes cluster on Hetzner Cloud with a managed load balancer and Longhorn.

## Prereqs
- Terraform >= 1.5
- `ssh`/`scp` available locally
- Hetzner Cloud API token
- SSH keypair (public key uploaded via Terraform)

## Backend state
Edit `Hetzner/backend.tf` and replace `REPLACE_ME_*` values before running `terraform init`.

## Usage
1. Create a `terraform.tfvars` with your settings.
2. Run `terraform init && terraform apply`.

Example `terraform.tfvars`:
```hcl
hcloud_token          = "YOUR_TOKEN"
ssh_public_key_path   = "/path/to/id_ed25519.pub"
ssh_private_key_path  = "/path/to/id_ed25519"
project_name          = "k8s-ha"
location              = "fsn1"
```

## Outputs
- Load balancer public IP
- Control plane / worker public IPs
- `kubeconfig` written to `Hetzner/kubeconfig`

## Notes
- Kubernetes version series is configurable via `kubernetes_version_series` (default `v1.30`).
- Ubuntu image is configurable via `image` (default `ubuntu-24.04`).
- Longhorn chart version is optional via `longhorn_version`.
