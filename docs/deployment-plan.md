# Deployment Plan

This is the concrete MVP deployment plan for the self-hosted server at `server1.fsck.me.uk`.

Assumption: the server is reachable on the public internet, and DNS for the app will point at the server's public IP.

## Target shape

`DNS -> fsck.me.uk / www.fsck.me.uk / rghf.nl / www.rghf.nl -> ingress controller -> Kubernetes Service -> app Pods`

HTTPS terminates at the cluster edge. The app itself stays private inside the cluster network.

## Phase 1: Server prep

1. Confirm DNS.
   - Point `fsck.me.uk`, `www.fsck.me.uk`, `rghf.nl`, and `www.rghf.nl` at the server public IP addresses.
   - Keep the base server hostname ready for SSH and admin access.
2. Open firewall ports.
   - `22/tcp` for SSH
   - `80/tcp` for HTTP
   - `443/tcp` for HTTPS
3. Update the host OS.
   - Install security updates.
   - Reboot if required.
4. Add a 2 GB swapfile.
   - Enable it immediately.
   - Persist it in `/etc/fstab`.
5. Create a non-root admin user for day-to-day access.
   - Keep `root` for break-glass access only.

Example host prep commands:

```bash
apt-get update
apt-get upgrade -y
useradd -m -s /bin/bash deploy
usermod -aG sudo deploy
```

## Phase 2: Kubernetes bootstrap

1. Install `k3s` on the server using the install script.
2. Verify the node is ready.
3. Confirm the built-in networking and ingress path are working.
4. Decide whether to keep the default Traefik install or replace it later.

For MVP, the default `k3s` ingress path is enough unless there is a hard requirement to switch controllers.
On this single-node server, keep `servicelb` enabled so Traefik can bind the external `80` and `443` paths.

Example install path:

```bash
sh scripts/install-k3s.sh
kubectl get nodes
kubectl get pods -A
```

## Phase 3: TLS

1. Install `cert-manager`.
2. Create a `ClusterIssuer` for Let's Encrypt.
3. Create a certificate request for the frontend hostname.
4. Bind the certificate secret into the ingress resource.

This keeps certificate issuance and renewal automated.

Example install path:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.20.2/cert-manager.yaml
kubectl apply -k manifests/infra/
```

## Phase 4: App deployment

1. Build the frontend image as an OCI image.
2. Add the `oci_test` demo workload under `https://fsck.me.uk/oci_test` and `https://rghf.nl/oci_test` using a Kubernetes 1.36 `image` volume.
3. Add the `webpages` site under `https://fsck.me.uk`, `https://www.fsck.me.uk`, `https://rghf.nl`, and `https://www.rghf.nl` so the docs are visible from the cluster.
4. Push the images to GHCR with the commit SHA tag.
5. Deploy each app as a `Deployment`.
6. Expose each one with a `Service`.
7. Route traffic with an `Ingress`.
8. Validate HTTPS end-to-end.

This demo route depends on Kubernetes v1.36 or newer because the HTML is mounted from an OCI image volume instead of being baked into a compiled app binary.

Example app rollout:

```bash
kubectl apply -k manifests/app/
kubectl rollout status deployment/web -n k8s-oci
```

## Phase 5: Hardening

1. Add health probes.
2. Add resource requests and limits.
3. Set up backups for any persistent data.
4. Add basic logging and metrics.
5. Review image pull and rollback flow.

## Phase 6: Later work

- GitOps
- DNS automation
- Multi-environment promotion
- Better rollout strategy
- Keep both public domains live and update DNS only if the IP changes
