# Step 5: Hosting the docs as a site

The repository already had the source docs. The next step was to make them visible on the live
server as a separate route.

## What changed

- A new `/webpages` route was added on `server2.rghf.nl`
- The docs were wrapped into a browsable HTML site
- The site was packaged as a tiny OCI image
- Nginx served the image through Kubernetes image volumes

## Why this matters

The server now exposes the deployment notes from the same place that runs the workloads.
That makes the project easier to inspect without opening the repository first.
