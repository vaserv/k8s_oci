# K3s Install for a 2 GB Server

This is the install path for the self-hosted node at `server2.rghf.nl`.

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

## Install steps

1. SSH into the server as `root`.
2. Copy `scripts/install-k3s.sh` to the machine.
3. Run it as root.
4. Verify the node is ready.
5. Apply the infra and app manifests.

## Expected result

After installation, the server should run a single-node cluster with the packaged Traefik ingress controller exposed on the host network through the lightweight service load balancer.
