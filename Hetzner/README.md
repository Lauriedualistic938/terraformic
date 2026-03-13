# Hetzner HA Kubernetes (kubeadm)

Modular Terraform setup to create a 3x control-plane / 2x worker HA Kubernetes cluster on Hetzner Cloud with a managed load balancer and Longhorn.

This deployment bootstraps the cluster via cloud-init only (no SSH). Vault runs **inside** the cluster in single-node dev mode with self-signed TLS and stores the kubeconfig.

## Prereqs
- Terraform >= 1.5
- Hetzner Cloud API token
- SSH public key (uploaded to servers; SSH is optional)

## Backend state
Edit `Hetzner/backend.tf` and replace `REPLACE_ME_*` values before running `terraform init`.

## Usage
1. Create a `terraform.tfvars` with your settings.
2. Run `terraform init && terraform apply`.

Example `terraform.tfvars`:
```hcl
hcloud_token        = "YOUR_TOKEN"
ssh_public_key_path = "/path/to/id_ed25519.pub"
project_name        = "k8s-ha"
location            = "fsn1"
vault_root_token    = "REPLACE_WITH_STRONG_TOKEN"
```

## Retrieve kubeconfig (Vault)
1. Get the Vault endpoint from Terraform output `vault_endpoint`.
2. Fetch kubeconfig from Vault:

```bash
export VAULT_ADDR=https://<vault-endpoint>
export VAULT_TOKEN=<vault_root_token>

curl -k -H "X-Vault-Token: $VAULT_TOKEN" \
  $VAULT_ADDR/v1/secret/data/kubeconfig | \
  jq -r '.data.data.value' | base64 -d > kubeconfig
```

## Outputs
- Load balancer public IP
- Control plane / worker public IPs
- Vault endpoint

## Notes
- Kubernetes version series is configurable via `kubernetes_version_series` (default `v1.30`).
- Ubuntu image is configurable via `image` (default `ubuntu-24.04`).
- Longhorn chart version is optional via `longhorn_version`.
- Vault runs in dev mode with a static root token for bootstrap convenience. Do not use as-is for production.
