# ExternalDNS and Cloudflare

This repo uses `external-dns` to keep the public DNS records for `fsck.me.uk` and
`rghf.nl` aligned with the Kubernetes ingress objects.

## Security model

- The Cloudflare API token is stored in `manifests/external-dns/cloudflare-token.sops.yaml`.
- The file is encrypted with SOPS and an age recipient.
- The age private key stays outside the repo, either on the operator machine or on the server.
- The token must be valid for the target zones and must not be restricted away from the server's public IPs.

## What it manages

- `fsck.me.uk`
- `www.fsck.me.uk`
- `rghf.nl`
- `www.rghf.nl`

The controller watches ingress resources and creates the corresponding DNS records in Cloudflare.

## Install steps

```bash
ssh root@server1.fsck.me.uk
cd /root/k8s_oci
sh scripts/apply-external-dns.sh
```

The install script verifies the Cloudflare token with the API before it applies the deployment. If Cloudflare rejects the token, fix the token policy in Cloudflare first.

If the age private key is not on the server yet, place it at:

```bash
/root/.config/sops/age/keys.txt
```

or point `SOPS_AGE_KEY_FILE` at the key file before running the script.

## Verification

```bash
kubectl -n external-dns logs deploy/external-dns
dig +short fsck.me.uk
dig +short www.fsck.me.uk
dig +short rghf.nl
dig +short www.rghf.nl
```

## Notes

- The controller uses a TXT registry so record ownership stays explicit.
- The current deployment uses ingress hostnames only, which keeps the DNS source of truth in the Kubernetes manifests.
- If you later move this under ArgoCD, keep the SOPS decryption path separate from the application manifests unless you add a SOPS-aware sync step.
