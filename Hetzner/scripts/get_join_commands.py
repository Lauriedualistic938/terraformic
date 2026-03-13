#!/usr/bin/env python3
import json
import os
import subprocess
import sys

query = json.load(sys.stdin)
host = query.get("host")
user = query.get("user")
key_path = query.get("key_path")

if not host or not user or not key_path:
    print(json.dumps({"error": "host, user, and key_path are required"}))
    sys.exit(0)

ssh_base = [
    "ssh",
    "-o",
    "StrictHostKeyChecking=no",
    "-i",
    key_path,
    f"{user}@{host}",
]

def run_ssh(cmd):
    full_cmd = ssh_base + [cmd]
    return subprocess.check_output(full_cmd, text=True).strip()

worker_cmd = run_ssh("kubeadm token create --print-join-command")
cert_key = run_ssh("cat /etc/kubeadm/cert.key")
control_plane_cmd = f"{worker_cmd} --control-plane --certificate-key {cert_key}"

print(json.dumps({
    "worker": worker_cmd,
    "control_plane": control_plane_cmd,
}))
