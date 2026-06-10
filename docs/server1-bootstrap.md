# Server1 Bootstrap

This is the clean bootstrap path for `server1.fsck.me.uk`.

The old server stays live until the new host passes the checks below.

## Target hostnames

- `fsck.me.uk`
- `www.fsck.me.uk`
- `argocd.fsck.me.uk`

`rghf.nl` will move here later, after the first cut is stable.

## Bootstrap order

1. SSH in as `root`.
2. Update the OS and add swap. The repo k3s installer creates `/swapfile` if it is not present.
3. Install `k3s` with the repo script.
4. Install `cert-manager`.
5. Install ArgoCD.
6. Sync the child Applications.
7. Create or reuse a non-root operator account.
8. Install Homebrew on Linux and `k9s` for that operator account.
9. Verify HTTPS and app health.
10. Move DNS only after the new server is confirmed healthy.

## Commands

```bash
ssh root@server1.fsck.me.uk
apt-get update
apt-get upgrade -y
SERVER_NAME=server1.fsck.me.uk sh scripts/install-k3s.sh
kubectl get nodes
kubectl apply -k manifests/infra
kubectl apply -k manifests/argocd/bootstrap
kubectl -n argocd get pods
kubectl -n argocd get app
```

## Operator tools

After the control plane is healthy, create a sudo-capable operator account and install the daily tooling there.

```bash
adduser ops
usermod -aG sudo ops
su - ops
git clone https://github.com/vaserv/k8s_oci.git
cd k8s_oci
sh scripts/install-ops-tools.sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
k9s
```

If you already have an admin SSH key on the old server, migrate the authorized keys, not the private key material:

```bash
scp root@old-server.example:/root/.ssh/authorized_keys /tmp/authorized_keys
install -o ops -g ops -m 600 /tmp/authorized_keys /home/ops/.ssh/authorized_keys
```

If you want to keep root login for emergency access, repeat the copy for `/root/.ssh/authorized_keys` on the new host.

## Verification

```bash
curl -fsS https://fsck.me.uk
curl -fsS https://fsck.me.uk/docs/
curl -fsS https://fsck.me.uk/oci_test
curl -k -H 'Host: argocd.fsck.me.uk' https://127.0.0.1
```

## Rollback

- Keep the old server online until the new host is stable.
- If the new host fails, point DNS back to the old server and keep the old workloads untouched.
- ArgoCD can be disabled by leaving the old cluster in place and not moving the DNS.
