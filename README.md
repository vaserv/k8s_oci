# k8s_oci

Concrete MVP for a self-hosted Kubernetes web app on `server2.rghf.nl`.

This repo starts with two things:

1. A step-by-step deployment runbook for a single-node self-hosted cluster.
2. Blog posts that document the build as the work progresses.

## MVP stack

- `k3s` on the server
- Traefik via the default `k3s` install, or an ingress controller you prefer later
- `cert-manager` for TLS
- OCI images pulled from a registry
- `Service` + `Ingress` for frontend exposure

## What is in scope now

- Bootstrapping the cluster
- Publishing the app over HTTPS
- Using OCI images for the workload
- Writing the first blog posts that explain each phase

## What is deferred

- CI/CD pipelines
- GitOps
- Multi-node failover
- Advanced observability
- Autoscaling beyond the basic MVP

## Docs

- [Deployment plan](docs/deployment-plan.md)
- [K3s install](docs/k3s-install.md)
- [Blog index](blog/index.md)
