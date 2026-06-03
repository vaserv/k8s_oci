# OCI HTML Template

This template is the reusable starter for future static HTML services that will be published as
OCI images and mounted into Kubernetes.

## Included pieces

- `templates/oci-html-site/site/` for the HTML content
- `templates/oci-html-site/Dockerfile` for the image build
- `templates/oci-html-site/manifests/` for the Kubernetes resources

## Intended flow

1. Copy the template into a new service directory.
2. Replace the HTML content.
3. Change the image name.
4. Point the ingress at the new host or path.
5. Add a GitHub Actions workflow if the site should deploy automatically.

## Design rule

Keep the content static and simple. If the page needs server-side logic, it is no longer the same
template.
