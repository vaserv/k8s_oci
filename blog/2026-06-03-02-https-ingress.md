# Step 2: Putting HTTPS in Front of the App

The frontend needs TLS from the start. For this MVP, certificate automation matters more than hand-built security ceremony.

## What we use

- Kubernetes `Ingress`
- `cert-manager`
- Let's Encrypt for public certificates

## Why this is the right layer

The app should not manage certificates itself. Kubernetes owns routing, and `cert-manager` owns issuance and renewal.

## Implementation outline

1. Create a `ClusterIssuer`.
2. Request a certificate for `server2.rghf.nl`.
3. Attach the certificate secret to the ingress.
4. Validate the HTTPS endpoint from a browser and from `curl`.

## Result

The app is now reachable with a valid certificate, and the cluster can renew it without manual intervention.
