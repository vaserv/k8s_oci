#!/usr/bin/env sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root." >&2
  exit 1
fi

SERVER_NAME="${SERVER_NAME:-server2.rghf.nl}"
K3S_CHANNEL="${K3S_CHANNEL:-stable}"
SWAPFILE="${SWAPFILE:-/swapfile}"
SWAPSIZE="${SWAPSIZE:-2G}"

if ! swapon --show | grep -q "^${SWAPFILE} "; then
  if [ ! -f "${SWAPFILE}" ]; then
    fallocate -l "${SWAPSIZE}" "${SWAPFILE}" || dd if=/dev/zero of="${SWAPFILE}" bs=1M count=2048
  fi
  chmod 600 "${SWAPFILE}"
  mkswap "${SWAPFILE}"
  swapon "${SWAPFILE}"
  grep -q "^${SWAPFILE} " /etc/fstab || echo "${SWAPFILE} none swap sw 0 0" >> /etc/fstab
fi

mkdir -p /etc/rancher/k3s

cat >/etc/rancher/k3s/config.yaml <<EOF
write-kubeconfig-mode: "0644"
node-name: "${SERVER_NAME}"
disable:
  - local-storage
  - metrics-server
EOF

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_CHANNEL="${K3S_CHANNEL}" \
  INSTALL_K3S_EXEC="server --config /etc/rancher/k3s/config.yaml" \
  sh -

echo
echo "k3s installation complete."
echo "Kubeconfig: /etc/rancher/k3s/k3s.yaml"
echo "Verify with: kubectl get nodes"
