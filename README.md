# k8s_oci

Concrete MVP for a self-hosted Kubernetes web app on `server1.fsck.me.uk`.

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
- Serving a hello-world demo at `/oci_test` from a Kubernetes 1.36 image volume
- Serving the wrapped docs and future home pages at `https://fsck.me.uk` and `https://www.fsck.me.uk`
- Building and deploying the site images from GitHub Actions
- Bootstrapping ArgoCD for GitOps rollouts
- Installing operator tooling such as Homebrew on Linux and `k9s`
- Writing the first blog posts that explain each phase

## What is deferred

- GitOps
- Multi-node failover
- Advanced observability
- Autoscaling beyond the basic MVP
- Full DNS automation for the final `rghf.nl` handoff

## Docs

- [Deployment plan](docs/deployment-plan.md)
- [K3s install](docs/k3s-install.md)
- [Webpages site](docs/webpages-site.md)
- [OCI HTML template](docs/oci-html-template.md)
- [ArgoCD bootstrap](docs/argocd-bootstrap.md)
- [Server1 bootstrap](docs/server1-bootstrap.md)
- [Blog index](blog/index.md)
- [Operator tools install](scripts/install-ops-tools.sh)

## CI/CD

- Workflows: `.github/workflows/oci-test.yml`, `.github/workflows/webpages.yml`
- Required secret for deploys: `DEPLOY_SSH_KEY`
- The deploy keypair was generated for this setup; if you rotate to a new server key, keep the replacement out of the repo and update the GitHub secret that the workflows read.
