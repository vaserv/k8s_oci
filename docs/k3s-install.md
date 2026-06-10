# K3s Install for a 2 GB Server

This is the install path for the self-hosted node at `server1.fsck.me.uk`.

The goal is a small-footprint cluster that still supports:

- `Ingress` for HTTP and HTTPS
- `cert-manager` for TLS
- OCI image pulls for the app

## Why `k3s`

`k3s` is the lightest practical Kubernetes option for a small self-hosted server. It gives you a real Kubernetes API without the overhead of a full upstream control plane.

## What this install disables

- `local-storage`
- `metrics-server`

`servicelb` stays enabled because it is what exposes the single-node ingress on ports `80` and `443`.
The `/oci_test` demo route also requires Kubernetes v1.36 or newer because it uses the `image` volume source.

## Swap and operator tools

This server gets a 2 GB swapfile before Kubernetes is installed. That gives the node a little breathing room under pressure without changing the disk layout.

If you want to provision it manually first, the commands are:

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -q '^/swapfile ' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
```

After `k3s` is up, install Homebrew on Linux and `k9s` so the new host has a simple operator toolchain for cluster checks.

## Install steps

1. SSH into the server as `root`.
2. Copy `scripts/install-k3s.sh` to the machine.
3. Run it as root with `SERVER_NAME=server1.fsck.me.uk`.
4. Verify the node is ready.
5. Create or reuse a non-root operator account.
6. Install Homebrew on Linux and `k9s` with `scripts/install-ops-tools.sh`.
7. Apply the infra and app manifests.

## Expected result

After installation, the server should run a single-node cluster with the packaged Traefik ingress controller exposed on the host network through the lightweight service load balancer.
