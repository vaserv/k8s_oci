# ArgoCD Bootstrap

This repo now includes a bootstrap path for ArgoCD on the single-node k3s cluster.

## Bootstrap command

Apply the bootstrap kustomization once from a machine that can reach the cluster:

```bash
kubectl apply -k manifests/argocd/bootstrap
```

## What it installs

- the ArgoCD control plane in its own namespace
- an HTTPS ingress for `argocd.rghf.nl`
- a certificate managed by cert-manager
- a project scoped to this repository
- a root Application that points to the child Application manifests

## Child Applications

The bootstrap application fans out into three child applications:

- `shared-infra`
- `webpages`
- `oci-test`

That gives each workload its own sync and rollback boundary while keeping the bootstrap
process small.

## Security notes

- Keep the ArgoCD admin password out of the repo and rotate it after first login.
- Do not expose ArgoCD without TLS.
- Keep the project source repo list and destination namespaces narrow.
- Add new workloads as separate child Applications instead of broadening the project scope.
