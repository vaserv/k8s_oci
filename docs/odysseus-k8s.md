# Odysseus on Kubernetes

This bundle is the starting point for a k3s deployment of Odysseus.

## What is included

- The Odysseus app
- ChromaDB
- SearXNG
- ntfy
- A single public ingress for the authenticated Odysseus entrypoint

## What is not included

- A model host
- GPU scheduling
- Email, calendar, or external API provisioning
- Public access without authentication

## Security posture

The upstream project is explicit: keep `AUTH_ENABLED=true`, keep `LOCALHOST_BYPASS=false`, use `SECURE_COOKIES=true` behind HTTPS, and keep the supporting services and raw model ports internal-only.

## What still needs to be set

- Replace `odysseus.example.com` with your real host
- Replace `model.example.com` with a reachable model endpoint, if you use one
- Fill in `manifests/odysseus/secret.example.yaml`
- Build or pull the Odysseus image you want to run

## Storage

The bundle uses persistent volumes for the app data, ChromaDB, SearXNG, and ntfy cache so state survives pod restarts.

## Practical sizing

- App plus bundled services only: 4 vCPU, 8-16 GB RAM, 100 GB SSD
- Comfortable small deployment: 8 vCPU, 16-32 GB RAM, 200 GB NVMe
- Local model serving: add GPU and VRAM sized for the model, not just the UI
