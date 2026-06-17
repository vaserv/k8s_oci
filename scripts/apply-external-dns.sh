#!/usr/bin/env sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root on the target cluster host." >&2
  exit 1
fi

if ! command -v sops >/dev/null 2>&1; then
  echo "sops is required." >&2
  exit 1
fi

if [ -z "${SOPS_AGE_KEY_FILE:-}" ] && [ ! -f /root/.config/sops/age/keys.txt ]; then
  echo "Set SOPS_AGE_KEY_FILE or place the age key at /root/.config/sops/age/keys.txt." >&2
  exit 1
fi

verify_tmp="$(mktemp)"
trap 'rm -f "$verify_tmp"' EXIT

token="$(
  sops -d manifests/external-dns/cloudflare-token.sops.yaml |
    awk '
      /^stringData:/{in_stringdata=1; next}
      in_stringdata && /^[[:space:]]+CF_API_TOKEN:/ {
        sub(/^[[:space:]]+CF_API_TOKEN:[[:space:]]+/, "")
        print
        exit
      }
    '
)"

if [ -z "$token" ]; then
  echo "Unable to decrypt the Cloudflare token from the SOPS secret." >&2
  exit 1
fi

if ! curl -fsS -H "Authorization: Bearer $token" \
  https://api.cloudflare.com/client/v4/user/tokens/verify >"$verify_tmp" 2>&1; then
  echo "Cloudflare token verification failed. The token must be valid and must not be restricted away from this server's source IPs." >&2
  cat "$verify_tmp" >&2
  exit 1
fi

if ! grep -q '"success":[[:space:]]*true' "$verify_tmp"; then
  echo "Cloudflare token verification returned a negative result. The token must be valid and must not be restricted away from this server's source IPs." >&2
  cat "$verify_tmp" >&2
  exit 1
fi

kubectl apply -k manifests/external-dns
sops -d manifests/external-dns/cloudflare-token.sops.yaml | kubectl apply -f -
kubectl -n external-dns rollout status deployment/external-dns --timeout=120s

echo
echo "external-dns is installed."
