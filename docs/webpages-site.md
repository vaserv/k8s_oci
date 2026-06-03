# Webpages Site

`/webpages` is the hosted wrapper for the project documentation and the future `www.rghf.nl`
home pages.

## What it contains

- A landing page for the hosted docs site
- The deployment and platform notes
- The reusable OCI HTML template
- A short blog that tracks the rollout

## Why it exists

The repository already has the source docs. The site turns those files into something the
cluster can serve directly, which makes the operational state visible from the same server that
runs the workloads.

## Live route

`https://server2.rghf.nl/webpages`

## Layout

- `webpages/index.html` is the landing page
- `webpages/docs/` contains the hosted docs
- `webpages/blog/` contains the build log
- `webpages/assets/site.css` holds the shared styling

## Deployment

The content is packaged into a tiny OCI image and mounted into an nginx container using the
Kubernetes 1.36 `image` volume feature.
