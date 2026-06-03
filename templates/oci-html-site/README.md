# OCI HTML Site Template

This template is the starting point for any future static site that should be shipped as an OCI
image and mounted into nginx on Kubernetes.

## Directory shape

- `site/` contains the HTML and CSS
- `Dockerfile` packages the site into an image
- `manifests/` contains the sample Kubernetes objects

## How to use it

1. Copy the directory into a new site name.
2. Replace the HTML under `site/`.
3. Change the image name in the manifests and workflow.
4. Adjust the ingress host and path.

The template is intentionally small so it can be reused without pulling in extra build tools.
